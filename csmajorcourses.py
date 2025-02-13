from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import StaleElementReferenceException
import time
import requests
from bs4 import BeautifulSoup
import sqlite3

from prereqfunction import find_prereqs



# Retrieve webpage HTML and parse using BeautifulSoup
website = "http://catalog.citruscollege.edu/disciplines/computer-science/computer-science-adt/#requirementstext"
prereqs = find_prereqs(website)
webpage = requests.get(website)
soup = BeautifulSoup(webpage.content, "html.parser")

# Find all table cells in the parsed HTML
table_data = soup.select("td:not(#curriculummaptextcontainer td)")
print(table_data)

# Connect to database
conn = sqlite3.connect('csmajorcourses.db')

# Create SQL table
conn.execute('''CREATE TABLE major_courses
             (id INTEGER PRIMARY KEY AUTOINCREMENT,
             course_name TEXT NOT NULL,
             course_description TEXT NOT NULL,
             course_units TEXT NOT NULL,
             course_prereqs TEXT NOT NULL,
             selected INTEGER DEFAULT 0
             );''')

# Loop through the table data and insert rows into the SQL table
i = 0
j = 0
while i < len(table_data)-2:
    if "or" not in table_data[i].get_text():
        # If there is no "or" in the class name, add the name, description, and units to a new row
        course_name = table_data[i].get_text().replace('\xa0', " ")
        course_description = table_data[i+1].get_text().replace('\xa0', " ")
        course_units = table_data[i+2].get_text()
        course_prereqs = prereqs[j]
        conn.execute("INSERT INTO major_courses (course_name, course_description, course_units, course_prereqs, selected) \
              VALUES (?, ?, ?, ?, ?);", (course_name, course_description, course_units, course_prereqs, 0))
        i += 3
        j += 1
    else:
        # If there is an "or" in the class name, add the name, description, and units to a new row
        # using the previous class's units
        course_name = table_data[i].get_text().replace('\xa0', " ")[3:]
        course_description = table_data[i+1].get_text()
        course_units = table_data[i-1].get_text()
        course_prereqs = prereqs[j]
        conn.execute("INSERT INTO major_courses (course_name, course_description, course_units, course_prereqs, selected) \
              VALUES (?, ?, ?, ?, ?);", (course_name, course_description, course_units, course_prereqs, 0))
        i += 2
        j += 1

# Save changes and close connection
conn.commit()
conn.close()
