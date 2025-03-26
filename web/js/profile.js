document.addEventListener("DOMContentLoaded", function () {
    fetch("http://127.0.0.1:5001/api/courses")
      .then((response) => response.json())
      .then((data) => {
        const selectElement = document.getElementById("courses");
  
        data.forEach((course) => {
          const option = document.createElement("option");
          option.value = course.id;
          option.textContent = course.course_code;
          selectElement.appendChild(option);
        });
      })
      .catch((error) => {
        console.error("Error fetching courses:", error);
      });
  });
  