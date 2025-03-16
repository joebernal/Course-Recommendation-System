# Import necessary libraries
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import StaleElementReferenceException
import time
import requests
from bs4 import BeautifulSoup
import sqlite3
import re

from prereqfunction import find_prereqs

# Retrieve webpage HTML and parse using BeautifulSoup
website = "http://catalog.citruscollege.edu/programs-study/graduation-requirements-associate-degree/general-education-requirements-transfer-csu-csuge-option-ii/#csugerequirementstext"
prereqs = find_prereqs(website)
webpage = requests.get(website)
soup = BeautifulSoup(webpage.content, "html.parser")
table_data = soup.find_all(['h2', 'td'])

#print(table_data)
#print(len(table_data))

# Remove empty elements from table_data
table_data = [elem for elem in table_data if elem.get_text().strip()]

def clean_table_name(name):
    # Replace non-alphanumeric characters with underscores
    name = ''.join(c if c.isalnum() else '_' for c in name)
    # Remove leading/trailing whitespace and underscores
    name = name.strip('_ ').strip()
    # Convert to lowercase
    name = name.lower()
    # Replace consecutive underscores with a single underscore
    name = re.sub('_+', '_', name)
    # Make exception for "U.S." by replacing "u_s_" with "us_"
    name = name.replace('u_s_', 'us_')
    # Remove "area_"
    name = name.removeprefix("area_")
    # Split the string into words and join the first six words with underscores
    words = name.split('_')
    name = '_'.join(words[:4])
    return name

# Connect to database
conn = sqlite3.connect('csugecourses.db')

current_table = ""
i = 2
j = 0

#print(len(table_data))
while i < len(table_data) - 1:
    if ":" in table_data[i].get_text() or "," in table_data[i].get_text():
        if '.' in table_data[i+1].get_text():
            current_table = clean_table_name(table_data[i+1].get_text())
            conn.execute("CREATE TABLE {} \
                         (id INTEGER PRIMARY KEY AUTOINCREMENT, \
                         course_name TEXT NOT NULL, \
                         course_description TEXT NOT NULL, \
                         course_units TEXT NOT NULL, \
                         course_prereqs TEXT NOT NULL);".format(current_table))
            i += 2
        else:
            current_table = clean_table_name(table_data[i].get_text())
            conn.execute("CREATE TABLE {} \
                         (id INTEGER PRIMARY KEY AUTOINCREMENT, \
                         course_name TEXT NOT NULL, \
                         course_description TEXT NOT NULL, \
                         course_units TEXT NOT NULL, \
                         course_prereqs TEXT NOT NULL);".format(current_table))
            i += 1
    elif '.' in table_data[i].get_text():
        current_table = clean_table_name(table_data[i].get_text())
        conn.execute("CREATE TABLE {} \
                         (id INTEGER PRIMARY KEY AUTOINCREMENT, \
                         course_name TEXT NOT NULL, \
                         course_description TEXT NOT NULL, \
                         course_units TEXT NOT NULL, \
                         course_prereqs TEXT NOT NULL);".format(current_table))
        i += 1
    else:
        course_name = table_data[i].get_text().replace('\xa0', " ")
        course_description = table_data[i+1].get_text().replace('\xa0', " ")
        course_units = table_data[i+2].get_text()
        course_prereqs = prereqs[j]
        sql = "INSERT INTO {} (course_name, course_description, course_units, course_prereqs) \
                VALUES (?, ?, ?, ?)".format(current_table)
        conn.execute(sql, (course_name, course_description, course_units, course_prereqs))
        i += 3
        j += 1

# Save changes and close connection
conn.commit()
conn.close()