from flask import Blueprint, jsonify
from routes.db_operations import query_db

major_bp = Blueprint('major_bp', __name__)

@major_bp.route('/', methods=['GET'])
def get_all_majors():
    query = "SELECT id, major_name FROM majors"
    result = query_db(query)
    print("DEBUG: ", result)

    majors = [{"id": row["id"], "major_name": row["major_name"]} for row in result]
    return jsonify(majors)
