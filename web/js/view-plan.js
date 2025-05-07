document.addEventListener("DOMContentLoaded", function () {
    const params = new URLSearchParams(window.location.search);
    const planId = params.get("plan_id");
    const container = document.getElementById("course-list");
  
    if (!planId) {
      container.innerHTML = "<p>No plan selected.</p>";
      return;
    }
  
    fetch(`http://127.0.0.1:5001/api/plans/${planId}/courses`)
      .then((res) => res.json())
      .then((courses) => {
        if (courses.length === 0) {
          container.innerHTML = "<p>This plan has no courses.</p>";
          return;
        }
  
        courses.forEach((course) => {
          const div = document.createElement("div");
          div.className = "course-item";
          div.innerHTML = `
            <strong>${course.course_code}</strong>: ${course.course_name} 
            (${course.course_units} units, ${course.ge_category_code}) — 
            ${course.semester} ${course.year}
          `;
          container.appendChild(div);
        });
      })
      .catch((err) => {
        console.error("Error loading courses:", err);
        container.innerHTML = "<p>Failed to load plan details.</p>";
      });
  });
  