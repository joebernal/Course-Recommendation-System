from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import StaleElementReferenceException
from bs4 import BeautifulSoup
import time

website = "http://catalog.citruscollege.edu/disciplines/computer-science/computer-science-adt/#requirementstext"
def find_prereqs(website):
    # Start a Selenium browser instance
    driver = webdriver.Chrome()
    driver.get(website)

    # Find all the elements with class attribute containing the string "bubblelink code"
    course_popups = driver.find_elements(By.CSS_SELECTOR, '.codecol a[class*=bubblelink]')
    #for popup in course_popups:
    #    print(popup)
    #print(course_popups)
    prereqs_list = []
    index = 1
    # Loop through each element, click it, and collect the HTML
    for popup in course_popups:
        try:
            # Click on the element
            popup.click()
            attempts = 0
            max_attempts = 3
            delay = 2  # delay in seconds between attempts
            while attempts < max_attempts:
                # Wait for dynamic content to load
                time.sleep(delay)    
                # Extract the HTML
                html = driver.page_source
                # Use Beautiful Soup to parse the HTML and extract data
                soup = BeautifulSoup(html, 'html.parser')
                bubble_content = soup.find(class_='lfjsbubblecontent')
                bubble_prereqs = bubble_content.find('i')
                if bubble_prereqs:
                    prereqs_list.append(bubble_prereqs.get_text().replace('\xa0', " "))
                    break
                else:
                    attempts += 1
                if attempts == max_attempts and bubble_prereqs is None:
                    prereqs_list.append("None")
        except Exception as e:
            print(f"Error processing element: {e}")
            prereqs_list.append("None")
        #bubblelinks = driver.find_elements(By.CSS_SELECTOR, '.lfjsbubblecontent .bubblelink')
    #print(prereqs_list)
    return prereqs_list

if __name__ == "__main__":
    find_prereqs(website)