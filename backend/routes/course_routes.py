from flask import Blueprint, request, jsonify
from db_operations import query_db

course_bp = Blueprint("course_bp", __name__)

@course_bp.route("/", methods=["GET"])
def get_courses():
    courses = query_db("SELECT * FROM courses")
    return jsonify(courses)

@course_bp.route("/<int:course_id>", methods=["GET"])
def get_course(course_id):
    course = query_db("SELECT * FROM courses WHERE id = %s", (course_id,))
    return jsonify(course)

@course_bp.route("/", methods=["POST"])
def add_course():
    data = request.get_json()
    query_db("INSERT INTO courses (course_name, course_description, course_units) VALUES (%s, %s, %s)",
             (data["course_name"], data["course_description"], data["course_units"]))
    return jsonify({"message": "Course added"}), 201
