from flask import Blueprint, request, jsonify
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

auth_bp = Blueprint("auth_bp", __name__)

@auth_bp.route('/firebase-config', methods=['GET'])
def get_firebase_config():
    return jsonify({
        "apiKey": os.getenv("FIREBASE_API_KEY"),
        "authDomain": os.getenv("FIREBASE_AUTH_DOMAIN"),
        "projectId": os.getenv("FIREBASE_PROJECT_ID"),
        "storageBucket": os.getenv("FIREBASE_STORAGE_BUCKET"),
        "messagingSenderId": os.getenv("FIREBASE_MESSAGING_SENDER_ID"),
        "appId": os.getenv("FIREBASE_APP_ID")
    })