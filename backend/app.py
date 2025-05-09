from flask import Flask, jsonify
from flask_cors import CORS
import os

from routes.auth_routes import auth_bp
from routes.course_routes import course_bp
from routes.plan_routes import plan_bp
from routes.user_routes import user_bp
from routes.major_routes import major_bp

app = Flask(__name__)
CORS(app, origins=["http://127.0.0.1:5501", "http://127.0.0.1:5002"], supports_credentials=True)

# Register Blueprints (Routes)
app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(course_bp, url_prefix='/api/courses')
app.register_blueprint(plan_bp, url_prefix='/api/plans')
app.register_blueprint(user_bp, url_prefix='/api/users')
app.register_blueprint(major_bp,url_prefix='/api/majors')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001, debug=True)