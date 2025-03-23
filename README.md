# 🏫 Course Recommendation System 📚

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Activity Diagram](#activity-diagram)
- [File Structure](#file-structure)
- [Installation](#installation)
- [Future Enhancements](#future-enhancements)
- [License](#license)

## Overview

The Course Recommendation System is designed for students at Citrus College pursuing an Associate Degree for Transfer (AD-T) in Computer Science. It helps students create personalized education plans based on major and general education (GE) requirements. The system dynamically selects courses while tracking previously selected courses to avoid duplication. The project is transitioning from a SQLite-based terminal application to a web-based system using MySQL and Flask.

## Features

- **Flexible Course Load**: Accommodates full-time, part-time, and optional winter and summer session preferences.
- **Automatic Course Selection**: Recommends courses for a structured degree plan.
- **Handles Multiple Databases**: Supports MySQL for scalable course storage.
- **Semester-Based Planning**: Assigns courses based on semesters (Fall, Winter, Spring, Summer).
- **Google Authentication**: Allows users to log in with Google accounts.

## Activity Diagram

<img src="web/img/Activity Diagram Design.png" alt="Activity Diagram" width="1000">

## File Structure

```
Course-Recommendation-System/
├── backend/                 # Flask backend API
│   ├── app.py               # Main Flask API script
│   ├── main.js              # Firebase authentication handling
│   ├── .env.example         # Example environment file for Firebase keys
│   └── requirements.txt     # Python dependencies
│
├── mysql_version/           # MySQL database schema
│   └── database_v1.0.0.sql  # SQL script to create MySQL tables
│
├── sqlite_version/          # Legacy SQLite database & scripts
│   ├── py/                  # Python scripts for SQLite version
│   │   ├── addselectedcolumn.py # Adds `selected` column for tracking
│   │   ├── attachdatabase.py    # Merges multiple SQLite databases
│   │   ├── basicedplancreate.py # Generates course plans dynamically
│   │   ├── csmajorcourses.py    # Handles CS major course selection
│   │   ├── csugecourses.py      # Scrapes and stores GE course data
│   │   ├── prereqfunction.py    # Scrapes prerequisite information
│   ├── db/                  # SQLite database files
│   │   ├── csdegreecourses.db   # Stores major and GE courses
│   │   ├── csmajorcourses.db    # Contains CS-specific courses
│   │   ├── csugecourses.db      # Stores general education courses
│
├── web/                     # Web application files
│   ├── index.html           # Homepage with project info and login/register button redirects
│   ├── about.html           # About page with project and team information
│   ├── login.html           # Login page for user authentication
│   ├── img/                 # Image assets for the website
│   │   ├── activity-diagram.png  # Website activity flowchart
│   │   ├── logo.png              # Site logo
│   │   └── sample_output.png     # Example course plan output
│
├── .gitignore               # Ignore unnecessary files in Git
├── Procfile                 # Deployment configuration for Render
└── README.md                # This README file
```

## Installation

### Prerequisites

- Python 3.x
- MySQL Server
- Flask
- Firebase Authentication for Google Login

### Setup

1. **Clone the Repository**
   ```sh
   git clone https://github.com/joebernal/Course-Recommendation-System
   cd course-recommendation-system
   ```

2. **Set Up MySQL Database**
   - Start MySQL Server
   - Run the MySQL schema script
     ```sh
     mysql -u root -p < mysql_version/database_v1.0.0.sql
     ```

### Set Up Backend

1. **Create a virtual environment** (only needed the first time)
   ```bash
   python3 -m venv venv
   ```

3. **Activate the virtual environment**

   - On **macOS/Linux**:
     ```bash
     source venv/bin/activate
     ```

   - On **Windows**:
     ```cmd
     venv\Scripts\activate
     ```

4. **Create a `.env` file using `.env.example` as a reference**
   ```bash
   cp .env.example .env  # Or manually create it
   ```

5. After activation, your terminal should show something like this:

```bash
(venv) user@machine:~/project$
```
This means the virtual environment is active.

6. **Install dependencies (inside the virtual environment)**
   ```bash
   pip install -r requirements.txt
   ```

7. **Run the Flask API**
   ```bash
   python backend/app.py
   ```

8. **(Optional) Exit the virtual environment**
   ```bash
   deactivate
   ```

---

### Set Up Frontend

To view the frontend in your browser:

1. Open VS Code and navigate to the project folder.
2. Locate the file: `web/index.html`.
3. **Right-click on `index.html`** and select **"Open with Live Server"** (make sure you have the [Live Server extension](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) installed).
4. A new browser tab should open automatically with your frontend running on something like `http://127.0.0.1:5501/web/index.html`.

> If Live Server doesn’t open, you can manually go to that URL in your browser or click "Go Live" in the bottom-right of VS Code.

---

## Future Enhancements

- **Backend API**: Fetch course plans, completed courses, and available courses via Flask.
- **Support for More STEM Majors**: Expand to include additional STEM degrees offered at Citrus College.
- **Enhanced UI**: Improve user experience with modern UI components.
- **Cloud Deployment**: Deploy the backend API and database to a cloud provider.
- **User-Generated Course Plans**: Allow students to manually create custom course plans.
- **User Profile Management**: Track completed courses and create multiple education plans.

## License

This project is licensed under the MIT License.
