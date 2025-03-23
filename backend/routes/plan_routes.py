from flask import Blueprint, request, jsonify
from routes.db_operations import query_db

plan_bp = Blueprint("plan_bp", __name__)