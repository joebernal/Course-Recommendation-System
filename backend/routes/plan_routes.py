from flask import Blueprint, request, jsonify
from routes.db_operations import query_db

plan_bp = Blueprint('plan_bp', __name__)

@plan_bp.route('/<int:plan_id>/courses', methods=['GET'])
def get_plan_courses(plan_id):
    """
    Retrieve all courses for a given plan_id.
    """
    query = """
        SELECT c.course_code, c.course_name, c.course_units, 
               IFNULL(gcm.ge_category_code, 'Major') AS ge_category_code,
               pc.semester, pc.year
        FROM plan_courses pc
        JOIN courses c ON pc.course_id = c.id
        LEFT JOIN ge_course_mappings gcm ON c.id = gcm.course_id
        WHERE pc.plan_id = %s
        ORDER BY pc.year, 
                 FIELD(pc.semester, 'Fall', 'Winter', 'Spring', 'Summer')
    """
    courses = query_db(query, (plan_id,))
    return jsonify(courses)

@plan_bp.route('/user/<int:user_id>', methods=['GET'])
def get_user_plans(user_id):
    """
    Retrieve all course plans for a given user_id.
    """
    query = "SELECT id, plan_name FROM course_plans WHERE user_id = %s"
    plans = query_db(query, (user_id,))
    return jsonify(plans)
