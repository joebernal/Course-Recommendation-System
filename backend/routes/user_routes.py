from flask import Blueprint, request, jsonify
from db_operations import query_db

user_bp = Blueprint("user_bp", __name__)