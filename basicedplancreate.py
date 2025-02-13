import sqlite3
import random

# Connect to your SQLite database
conn = sqlite3.connect('csdegreecourses.db')
cursor = conn.cursor()

def reset_selected_values():
    for table_name in table_names:
        try:
            cursor.execute(f"UPDATE {table_name} SET selected = 0")
            conn.commit()
        except sqlite3.Error as e:
            print(f"Error resetting selected value in table {table_name}: {e}")

def get_all_table_names():
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'b%' AND name NOT LIKE 'group%';")
    tables = cursor.fetchall()
    return [table[0] for table in tables]

def update_table_limits():
    global table_limits
    c1_arts_selected = count_selected_courses('c1_arts')
    c2_humanities_selected = count_selected_courses('c2_humanities')

    if c1_arts_selected >= table_limits.get('c1_arts', 2):
        table_limits['c2_humanities'] = 1
    elif c2_humanities_selected >= table_limits.get('c2_humanities', 2):
        table_limits['c1_arts'] = 1
    

def count_selected_courses(table_name):
    cursor.execute(f"SELECT COUNT(*) FROM {table_name} WHERE selected = 1")
    count = cursor.fetchone()[0]
    return count

def is_course_selected(course_name):
    cursor.execute("SELECT selected FROM major_courses WHERE course_name = ?", (course_name,))
    selected = cursor.fetchone()
    if selected:
        return selected[0] == 1
    return False

def select_random_ge_course():
    update_table_limits()
    
    # Prioritize selecting ENGL 101 if not already taken
    cursor.execute("SELECT * FROM a2_written_communication WHERE course_name = 'ENGL 101' AND selected = 0")
    engl_101 = cursor.fetchone()
    
    if engl_101:
        cursor.execute("UPDATE a2_written_communication SET selected = 1 WHERE id = ?", (engl_101[0],))
        conn.commit()
        return engl_101  # Return ENGL 101 first before selecting other GE courses
    
    # Proceed with random GE course selection if ENGL 101 is already taken
    filtered_ge_tables = [table for table in ge_tables if count_selected_courses(table) < table_limits.get(table, 2)]

    if not filtered_ge_tables:
        return None

    selected_table = random.choice(filtered_ge_tables)
    cursor.execute(f"SELECT * FROM {selected_table} WHERE selected = 0 AND course_units = 3 AND course_name NOT LIKE '%H' AND course_name NOT LIKE '%E'")
    available_courses = cursor.fetchall()

    if not available_courses:
        return None

    random_course = random.choice(available_courses)

    cursor.execute(f"UPDATE {selected_table} SET selected = 1 WHERE id = ?", (random_course[0],))
    conn.commit()

    return random_course


def select_major_courses(specific_course=None):
    # Define the sequential list of first major courses
    first_major_courses = ['CS 111', 'CS 225', 'CS 232', 'CS 242', 'CS 252']

    # If specific_course is provided and it's in the first_major_courses list, use it; otherwise, select the first available course
    cs_course = None
    if specific_course:
        cursor.execute(f"SELECT * FROM major_courses WHERE course_name = '{specific_course}' AND selected = 0")
        cs_course = cursor.fetchone()
        if cs_course:
            cursor.execute("UPDATE major_courses SET selected = 1 WHERE id = ?", (cs_course[0],))
    else:
        for course_name in first_major_courses:
            cursor.execute(f"SELECT * FROM major_courses WHERE course_name = '{course_name}' AND selected = 0")
            cs_course = cursor.fetchone()
            if cs_course:
                cursor.execute("UPDATE major_courses SET selected = 1 WHERE id = ?", (cs_course[0],))
                break

    # Define the sequential list of second major courses
    second_major_courses = ['MATH 175', 'MATH 190', 'MATH 191', 'PHYS 201', 'BIOL 124', 'BIOL 125']

    # If specific_course is provided and it's in the second_major_courses list, use it; otherwise, select the first available course
    other_course = None
    if specific_course:
        cursor.execute(f"SELECT * FROM major_courses WHERE course_name = '{specific_course}' AND selected = 0")
        other_course = cursor.fetchone()
        if other_course:
            cursor.execute("UPDATE major_courses SET selected = 1 WHERE id = ?", (other_course[0],))
            if specific_course == 'BIOL 124' or specific_course == 'BIOL 125':
                cursor.execute("UPDATE major_courses SET selected = 1 WHERE course_name = 'BIOL 124' OR course_name = 'BIOL 125'")
    else:
        for course_name in second_major_courses:
            if course_name == 'BIOL 124' or course_name == 'BIOL 125':
                    # Randomly choose between BIOL 124 and BIOL 125
                    random_choice = random.choice(['BIOL 124', 'BIOL 125'])
                    course_name = random_choice
            cursor.execute(f"SELECT * FROM major_courses WHERE course_name = '{course_name}' AND selected = 0")
            other_course = cursor.fetchone()
            if other_course:
                cursor.execute("UPDATE major_courses SET selected = 1 WHERE id = ?", (other_course[0],))
                if course_name == 'BIOL 124' or course_name == 'BIOL 125':
                    cursor.execute("UPDATE major_courses SET selected = 1 WHERE course_name = 'BIOL 124' OR course_name = 'BIOL 125'")
                break

    selected_courses = []
    if cs_course:
        selected_courses.append(cs_course)
    if other_course:
        selected_courses.append(other_course)

    return selected_courses

def add_ge_course_to_semester(semester_courses):
    ge_course = select_random_ge_course()
    if ge_course:
        semester_courses.append(ge_course)


table_names = get_all_table_names()

# Define the maximum number of allowed selected courses for each table
table_limits = {
    'a1_oral_communication': 1,
    'a2_written_communication': 1,
    'a3_critical_thinking': 1,
    'c1_arts': 2,
    'c2_humanities': 2,
    'd_social_political': 2,
    'e_lifelong_understanding': 1,
    'f_ethnic_studies': 1
}

# Reset selected values for all tables
reset_selected_values()


# Separate the table names into major requirements and GE requirements lists
major_tables = [name for name in table_names if name.startswith('major')]
ge_tables = [name for name in table_names if not name.startswith('major')]

include_summer = False  # Set to True if you want to include summer classes
include_winter = True  # Set to True if you want to include winter classes

semester = "Fall"
year = 2024

if include_summer and include_winter:
    semester_names = ["Fall", "Winter", "Spring", "Summer"]
elif include_summer:
    semester_names = ["Fall", "Spring", "Summer"]
elif include_winter:
    semester_names = ["Fall", "Winter", "Spring"]
else:
    semester_names = ["Fall", "Spring"]

first_winter = True

while True:

    semester_courses = []
    if semester == "Fall" or semester == "Spring":
        major_courses = select_major_courses()
        if major_courses:
            semester_courses.extend(major_courses)
        # Calculate the total units
        total_units = sum(float(course[3]) for course in semester_courses if course is not None)
        # Add GE course if the total units are less than or equal to 11
        while total_units <= 11:
            ge_course = select_random_ge_course()
            if ge_course:
                semester_courses.append(ge_course)
                total_units += float(ge_course[3])
            else:
                break

    if semester == "Winter":
        # Add CS 252 class for the next winter or summer session if CS 225 has been selected
        if is_course_selected("CS 225") and not is_course_selected("CS 252"):
            cs_252 = select_major_courses("CS 252")
            if cs_252:
                semester_courses.extend(cs_252)
            add_ge_course_to_semester(semester_courses)
        else:
            add_ge_course_to_semester(semester_courses)
            add_ge_course_to_semester(semester_courses)
   
    # Add a GE course if the semester is "Summer"
    if semester == "Summer":
        add_ge_course_to_semester(semester_courses)

    # If semester_courses is empty for summer or winter, continue to the next iteration
    if not semester_courses and (semester == "Summer" or semester == "Winter"):
        # Update the semester and year
        semester_index = semester_names.index(semester)
        next_semester_index = (semester_index + 1) % len(semester_names)
        semester = semester_names[next_semester_index]
        continue

    # If semester_courses is empty for fall or spring, break the loop
    if not semester_courses and (semester == "Fall" or semester == "Spring"):
        break

    # Print the semester courses
    print(f"{semester} {year}:")
    for course in semester_courses:
        print(f"{course[1]}: {course[2]} ({course[3]} units)")
    print("")
    
    # Update the semester and year
    semester_index = semester_names.index(semester)
    next_semester_index = (semester_index + 1) % len(semester_names)
    semester = semester_names[next_semester_index]

    if not include_winter and semester == "Spring" or (include_winter and semester == "Winter"):
        year += 1

# Close the database connection
conn.commit()
conn.close()