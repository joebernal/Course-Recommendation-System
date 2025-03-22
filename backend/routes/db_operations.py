import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME")
}

def query_db(query, params=None):
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute(query, params or ())
    
    if query.strip().upper().startswith("SELECT"):
        results = cursor.fetchall()
    else:
        conn.commit()
        results = {"message": "Success"}
    
    cursor.close()
    conn.close()
    return results
