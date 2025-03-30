from flask import Blueprint, request, jsonify
from routes.db_operations import query_db

user_bp = Blueprint("user_bp", __name__)

@user_bp.route('/', methods=['POST'])
def add_user():
    data = request.get_json()
    existing_user = query_db("SELECT * FROM users WHERE google_uid = %s", (data["google_uid"],))

    if existing_user:
        return jsonify({"error": "User with this Google UID already exists"}), 400
    
    query_db("INSERT INTO users (email, google_uid, full_name) VALUES (%s, %s, %s)", 
            (data["email"], data["google_uid"], data["full_name"]))
    return jsonify({"message": "User added"}), 201