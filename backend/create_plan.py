import os
import random
import mysql.connector
from dotenv import load_dotenv
from routes.db_operations import query_db, DB_CONFIG  # Using central DB helper

load_dotenv()

# Global in-memory set to track IDs of courses added to the plan.
added_course_ids = set()

# Global in-memory dictionary to count the number of GE courses added per GE category.
ge_counts = {
    'A1': 0,  # Oral Communication
    'A2': 0,  # Written Communication
    'A3': 0,  # Critical Thinking
    'B1': 0,  # Physical Sciences
    'B2': 0,  # Biological Sciences
    'B4': 0,  # Mathematics/Quantitative Reasoning
    'C1': 0,  # Arts
    'C2': 0,  # Humanities
    'D': 0,   # Social/Political and Cultural Studies
    'E': 0,   # Lifelong Understanding
    'F': 0,   # Ethnic Studies
    'US': 0,  # US History (default not for Associate’s plans)
    'AM': 0   # American Institutions (default not for Associate’s plans)
}

# GE category limits mapping.
table_limits = {
    'A1': 1,
    'A2': 1,
    'A3': 1,
    'B1': 1,
    'B2': 1,
    'B4': 1,
    'C1': 2,
    'C2': 2,
    'D': 2,
    'E': 1,
    'F': 1,
    'US': 0,
    'AM': 0
}

###############################################################################
# Helper function: Create Course Plan
###############################################################################
def create_course_plan(user_id, plan_name):
    """
    Inserts a new row into the course_plans table for the given user and returns the plan ID.
    """
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("INSERT INTO course_plans (user_id, plan_name) VALUES (%s, %s)", (user_id, plan_name))
    conn.commit()
    plan_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return plan_id

###############################################################################
# User and Course Utility Functions
###############################################################################
def get_user_preferences(user_id):
    result = query_db(
        "SELECT enrollment_status, available_winter, available_summer FROM users WHERE id = %s",
        (user_id,)
    )
    return result[0] if result else None

def get_completed_courses(user_id):
    result = query_db("SELECT course_id FROM completed_courses WHERE user_id = %s", (user_id,))
    return set(row['course_id'] for row in result)

###############################################################################
# Recursive Prerequisite Checking
###############################################################################
def prerequisites_met(course_id, user_id, added_course_ids, visited=None):
    """
    Recursively checks if all prerequisites for a given course have been met (completed
    or already added). Returns (True, []) if met; otherwise, returns (False, missing_list)
    where missing_list contains course IDs of missing prerequisites (the last element is the deepest missing prerequisite).
    """
    if visited is None:
        visited = set()
    if course_id in visited:
        return True, []
    visited.add(course_id)
    
    result = query_db("SELECT prereq_id FROM prerequisites WHERE course_id = %s", (course_id,))
    prereq_ids = [row['prereq_id'] for row in result]
    if not prereq_ids:
        return True, []
    
    missing = []
    completed = get_completed_courses(user_id).union(added_course_ids)
    for prereq in prereq_ids:
        if prereq not in completed:
            met, sub_missing = prerequisites_met(prereq, user_id, added_course_ids, visited)
            if not met:
                missing.extend(sub_missing)
            missing.append(prereq)
    return (len(missing) == 0), missing

###############################################################################
# GE Categories and Courses Functions
###############################################################################
def get_available_ge_categories(user_id, major_id, include_us_am=False):
    """
    Returns a list of available GE category codes by subtracting those satisfied
    by the major's courses (via a join on ge_course_mappings).
    Optionally excludes 'US' and 'AM' if include_us_am is False.
    """
    result = query_db("SELECT category_code FROM ge_categories")
    all_ge_codes = {row["category_code"] for row in result}
    
    result = query_db("""
        SELECT DISTINCT gcm.ge_category_code
          FROM major_courses mc
          JOIN ge_course_mappings gcm ON mc.course_id = gcm.course_id
         WHERE mc.major_id = %s
    """, (major_id,))
    satisfied = {row["ge_category_code"] for row in result}
    
    available_ge_cat_codes = all_ge_codes - satisfied
    if not include_us_am:
        available_ge_cat_codes -= {"US", "AM"}
    return list(available_ge_cat_codes)

def get_available_ge_courses(user_id, added_course_ids, available_ge_cat_codes):
    """
    Returns GE courses (with GE category code included) from courses that belong to the GE categories
    provided—filtered so that the course has not yet been completed, added to the plan, or is an honors course.
    """
    completed = get_completed_courses(user_id)
    placeholders = ','.join(['%s'] * len(available_ge_cat_codes))
    query = f"""
        SELECT c.id, c.course_code, c.course_name, c.course_units, c.course_description, gcm.ge_category_code
          FROM courses c
          JOIN ge_course_mappings gcm ON c.id = gcm.course_id
         WHERE gcm.ge_category_code IN ({placeholders})
           AND c.id NOT IN (SELECT course_id FROM honors_courses)
    """
    result = query_db(query, tuple(available_ge_cat_codes))
    return [row for row in result if row['id'] not in completed and row['id'] not in added_course_ids]


def get_filtered_ge_courses(user_id, added_course_ids, available_ge_cat_codes):
    # Get all available GE courses first.
    courses = get_available_ge_courses(user_id, added_course_ids, available_ge_cat_codes)
    filtered = []
    for course in courses:
        cat = course['ge_category_code']
        # If category is C1 or C2, skip if the count is already at the limit.
        if cat in ['C1', 'C2']:
            limit = table_limits[cat]
            if ge_counts.get(cat, 0) < limit:
                filtered.append(course)
        else:
            # For other GE categories, just add if within limit.
            if ge_counts.get(course['ge_category_code'], 0) < table_limits.get(course['ge_category_code'], 0):
                filtered.append(course)
    return filtered


def select_random_ge_course(user_id, available_ge_cat_codes):
    """
    Randomly selects a GE course from the available GE courses (from the given GE categories)
    while respecting the individual and combined limits.
    
    Prioritizes ENGL 101 if it hasn’t been added yet. Since ENGL 101 is known to belong to GE
    category A1, we simply add it if available.
    """
    # Priority: select ENGL 101 if available.
    result = query_db("SELECT * FROM courses WHERE course_code = %s", ('ENGL 101',))
    if result:
        engl_101 = result[0]
        if engl_101['id'] not in added_course_ids:
            engl_101['ge_category_code'] = 'A2'
            added_course_ids.add(engl_101['id'])
            ge_counts['A2'] = ge_counts.get('A2', 0) + 1
            return engl_101

    # Otherwise, retrieve all available GE courses from the provided categories.
    available = get_available_ge_courses(user_id, added_course_ids, available_ge_cat_codes)
    
    # Filter the available courses so that each course's GE category count is below its limit.
    # For categories C1 and C2 we enforce a combined maximum of 3 courses.
    filtered = []
    for course in available:
        cat = course['ge_category_code']
        if cat in ['C1', 'C2']:
            combined = ge_counts.get('C1', 0) + ge_counts.get('C2', 0)
            if combined < 3:
                filtered.append(course)
        else:
            if ge_counts.get(cat, 0) < table_limits.get(cat, 0):
                filtered.append(course)
    
    if not filtered:
        return None

    # Shuffle the filtered list and randomly select one course.
    random.shuffle(filtered)
    selected_course = random.choice(filtered)
    
    # For GE categories C1/C2, ensure the combined count is still less than 3.
    cat = selected_course['ge_category_code']
    if cat in ['C1', 'C2']:
        combined = ge_counts.get('C1', 0) + ge_counts.get('C2', 0)
        if combined >= 3:
            return None
    added_course_ids.add(selected_course['id'])
    ge_counts[cat] = ge_counts.get(cat, 0) + 1
    return selected_course


###############################################################################
# Major Courses Selection with Prerequisite Checking
###############################################################################
def select_major_course_with_prereq(major_id, candidate_code, user_id):
    """
    For a candidate major course (identified by candidate_code),
    retrieve the course by joining major_courses with courses, and check prerequisites.
    If prerequisites are met, return the course; otherwise, return the deepest missing prerequisite.
    """
    query = """
        SELECT c.*
          FROM major_courses mc
          JOIN courses c ON mc.course_id = c.id
         WHERE mc.major_id = %s AND c.course_code = %s
    """
    result = query_db(query, (major_id, candidate_code))
    if not result:
        return None
    course = result[0]
    met, missing = prerequisites_met(course['id'], user_id, added_course_ids)
    if met:
        return course
    if missing:
        fallback_id = missing[-1]
        fallback_result = query_db("SELECT * FROM courses WHERE id = %s", (fallback_id,))
        if fallback_result:
            fallback_course = fallback_result[0]
            fallback_met, _ = prerequisites_met(fallback_course['id'], user_id, added_course_ids)
            if fallback_met:
                return fallback_course
    return None

def select_major_courses(major_id, major_name, major_acronym, user_id):
    """
    Select major courses for the current plan.
    For Computer Science, uses defined sequential lists for a well-rounded plan:
       - first_major_seq for courses (e.g., CS courses)
       - second_major_seq for the remaining major requirements.
    For other majors, if no sequence is defined, retrieve courses by insertion order,
    then split the courses into two groups:
       - Those starting with the major_acronym (to keep consistency in early semesters).
       - All other courses.
    Each candidate is checked for prerequisite fulfillment.
    """
    selected = []
    if major_name.strip().lower() == "computer science":
        first_major_seq = ['CS 111', 'CS 225', 'CS 232', 'CS 242', 'CS 252']
        second_major_seq = ['MATH 190', 'MATH 191', 'PHYS 201', 'BIOL 124', 'BIOL 125']
        
        cs_course = None
        for code in first_major_seq:
            candidate = select_major_course_with_prereq(major_id, code, user_id)
            if candidate and candidate['id'] not in added_course_ids:
                added_course_ids.add(candidate['id'])
                cs_course = candidate
                break
        if cs_course:
            selected.append(cs_course)
        
        other_course = None
        for code in second_major_seq:
            if code in ['BIOL 124', 'BIOL 125']:
                chosen = random.choice(['BIOL 124', 'BIOL 125'])
                candidate = select_major_course_with_prereq(major_id, chosen, user_id)
                if candidate and candidate['id'] not in added_course_ids:
                    added_course_ids.add(candidate['id'])
                    
                    # Block the OTHER course from being selected in the future
                    if chosen == 'BIOL 124':
                        other_code = 'BIOL 125'
                    else:
                        other_code = 'BIOL 124'
                    
                    other_course_id_result = query_db("""
                        SELECT c.id
                        FROM major_courses mc
                        JOIN courses c ON mc.course_id = c.id
                        WHERE mc.major_id = %s AND c.course_code = %s
                    """, (major_id, other_code))
                    
                    if other_course_id_result:
                        added_course_ids.add(other_course_id_result[0]['id'])
                    
                    other_course = candidate
                    break
            else:
                candidate = select_major_course_with_prereq(major_id, code, user_id)
                if candidate and candidate['id'] not in added_course_ids:
                    added_course_ids.add(candidate['id'])
                    other_course = candidate
                    break

        if other_course:
            selected.append(other_course)

    else:
        result = query_db("SELECT * FROM major_courses WHERE major_id = %s ORDER BY id ASC", (major_id,))
        courses = result
        first_group = [course for course in courses if course.get("course_code", "").startswith(major_acronym)]
        second_group = [course for course in courses if not course.get("course_code", "").startswith(major_acronym)]
        
        cs_course = None
        for course in first_group:
            met, _ = prerequisites_met(course['id'], user_id, added_course_ids)
            if met and course['id'] not in added_course_ids:
                added_course_ids.add(course['id'])
                cs_course = course
                break
        if cs_course:
            selected.append(cs_course)
        
        other_course = None
        for course in second_group:
            met, _ = prerequisites_met(course['id'], user_id, added_course_ids)
            if met and course['id'] not in added_course_ids:
                added_course_ids.add(course['id'])
                other_course = course
                break
        if other_course:
            selected.append(other_course)
    return selected

###############################################################################
# Insert Courses into the Plan
###############################################################################
def add_courses_to_plan(plan_id, semester, year, courses):
    for course in courses:
        category = course.get('ge_category_code', 'Major')  # fallback to 'Major' if key is missing
        query_db("""
            INSERT INTO plan_courses (plan_id, course_id, semester, year, assigned_ge_category)
            VALUES (%s, %s, %s, %s, %s)
        """, (plan_id, course['id'], semester, year, category))


###############################################################################
# Main Plan Generation Function
###############################################################################
def generate_plan(user_id, major_id, major_name, major_acronym, start_semester, start_year, plan_id, include_us_am=False):
    prefs = get_user_preferences(user_id)
    if not prefs:
        print("User preferences not found!")
        return
    enrollment = prefs.get('enrollment_status', 'fulltime')
    include_winter = prefs.get('available_winter', False)
    include_summer = prefs.get('available_summer', False)

    # Dynamically build semester list
    semesters = []
    if include_winter:
        semesters.append("Winter")
    semesters.append("Spring")
    if include_summer:
        semesters.append("Summer")
    semesters.append("Fall")  # Always include Fall

    # Step 2: Set start index based on start_semester
    current_semester_index = semesters.index(start_semester)
    semester = semesters[current_semester_index]
    year = start_year

    
    target_units = 12 if enrollment.lower() == "fulltime" else 6
    default_allowed_major_units = target_units / 2

    available_ge_cat_codes = get_available_ge_categories(user_id, major_id, include_us_am=include_us_am)
    print("Available GE categories for selection:", available_ge_cat_codes)

    while True:
        semester_courses = []
        total_units = 0

        if semester in ["Fall", "Spring"]:
            if major_name.strip().lower() == "computer science":
                major_courses = select_major_courses(major_id, major_name, major_acronym, user_id)
            else:
                result = query_db("SELECT * FROM major_courses WHERE major_id = %s ORDER BY id ASC", (major_id,))
                courses = result
                major_courses = []
                for course in courses:
                    if course['id'] not in added_course_ids:
                        met, _ = prerequisites_met(course['id'], user_id, added_course_ids)
                        if met:
                            major_courses.append(course)
            # GE courses available for this semester.
            available_ge = get_available_ge_courses(user_id, added_course_ids, available_ge_cat_codes)
            allowed_major_units = target_units if not available_ge else default_allowed_major_units

            # Add major courses until allowed_major_units is met.
            for course in major_courses:
                course_units = int(course["course_units"])
                if total_units < allowed_major_units:
                    semester_courses.append(course)
                    total_units += course_units
                if total_units >= target_units:
                    break

            # If units are still short, try to add GE courses.
            while total_units < target_units:
                course = select_random_ge_course(user_id, available_ge_cat_codes)
                if course:
                    course_units = int(course["course_units"])
                    cat = course['ge_category_code']
                    semester_courses.append(course)
                    total_units += course_units
                else:
                    break

        elif semester in ["Winter", "Summer"]:
            course = select_random_ge_course(user_id, available_ge_cat_codes)
            if course:
                course_units = int(course["course_units"])
                cat = course['ge_category_code']
                semester_courses.append(course)
                total_units += course_units
            else:
                # If no GE courses are available, add one available major course.
                major_available = select_major_courses(major_id, major_name, major_acronym, user_id)
                if major_available:
                    semester_courses.extend(major_available)

        # If no courses were selected, break out of the loop.
        if not semester_courses:
            break

        add_courses_to_plan(plan_id, semester, year, semester_courses)

        # Print the semester courses with their category.
        print(f"{semester} {year}:")
        for course in semester_courses:
            # Check if the course has a GE category, if not mark as "Major".
            category = course.get('ge_category_code', 'Major')
            print(f"{course['course_code']} - {course['course_name']} ({course['course_units']} units) ({category})")
        print("")

        # Rotate to next semester
        current_semester_index = (current_semester_index + 1) % len(semesters)
        semester = semesters[current_semester_index]

        # If we looped back to the first semester in list, increment year
        if current_semester_index == 0:
            year += 1

###############################################################################
# Main Execution
###############################################################################
if __name__ == '__main__':
    # In production these parameters are retrieved from the create-plan.html form via your API.
    user_id = 1
    major_id = 1
    major_name = "Computer Science"   # For CS, we use the defined sequential logic.
    major_acronym = "CS"              # The prefix used to split major courses.
    start_semester = "Fall"           # Provided by the user.
    start_year = 2024                 # Provided by the user.
    include_us_am = False             # Default setting for Associate's plans.

    # Create a new course plan record first so that plan_courses rows reference a valid plan.
    plan_name = f"{major_name} Plan starting {start_semester} {start_year}"
    plan_id = create_course_plan(user_id, plan_name)
    if plan_id:
        print("Created course plan with plan_id:", plan_id)
    else:
        print("Error creating course plan.")
        exit(1)

    generate_plan(user_id, major_id, major_name, major_acronym, start_semester, start_year, plan_id, include_us_am=False)
