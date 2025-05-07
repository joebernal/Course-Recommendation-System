from flask import Blueprint, request, jsonify, session
from routes.db_operations import query_db

plan_bp = Blueprint('plan_bp', __name__)

@plan_bp.route('/<int:plan_id>/courses', methods=['GET'])
def get_plan_courses(plan_id):
    """
    Retrieve all courses for a given plan_id.
    """
    query = """
        SELECT c.course_code, c.course_name, c.course_units,
            pc.assigned_ge_category AS ge_category_code,
            pc.semester, pc.year
        FROM plan_courses pc
        JOIN courses c ON pc.course_id = c.id
        WHERE pc.plan_id = %s
        ORDER BY pc.year, 
                FIELD(pc.semester, 'Fall', 'Winter', 'Spring', 'Summer')
    """

    courses = query_db(query, (plan_id,))
    return jsonify(courses)

@plan_bp.route('/create', methods=['POST'])
def create_plan():
    data = request.get_json()
    #user_id = session.get('user_id')
    user_id = 1  # For dev testing only


    if not user_id:
        return jsonify({'error': 'Unauthorized'}), 401

    major_id = data['major']
    start_semester = data['start_semester']
    start_year = data['start_year']
    enrollment_status = data['enrollment_status']
    available_winter = data['available_winter']
    available_summer = data['available_summer']

    # Lookup major_id and major_acronym
    major_info = query_db("SELECT major_name, major_acronym FROM majors WHERE id = %s", (major_id,))
    if not major_info:
        return jsonify({'error': 'Major not found'}), 400
    major_name = major_info[0]['major_name']
    major_acronym = major_info[0]['major_acronym']

    # Update user preferences
    query_db("""
        UPDATE users 
        SET enrollment_status = %s, available_winter = %s, available_summer = %s 
        WHERE id = %s
    """, (enrollment_status, available_winter, available_summer, user_id))

    # Create the plan and generate course plan
    from create_plan import generate_plan, create_course_plan
    plan_name = f"{major_name} Plan {enrollment_status.capitalize()}, starts {start_semester} {start_year}"
    plan_id = create_course_plan(user_id, plan_name)

    generate_plan(user_id, major_id, major_name, major_acronym, start_semester, start_year, plan_id, include_us_am=False)


    return jsonify({'plan_id': plan_id})
@plan_bp.route('/user/<int:user_id>', methods=['GET'])
def get_user_plans(user_id):
    """
    Retrieve all course plans for a given user_id.
    """
    query = "SELECT id, plan_name FROM course_plans WHERE user_id = %s"
    plans = query_db(query, (user_id,))
    return jsonify(plans)
