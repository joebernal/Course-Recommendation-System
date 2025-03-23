document.addEventListener("DOMContentLoaded", function () {
  fetch("http://127.0.0.1:5001/api/majors")
    .then((response) => response.json())
    .then((data) => {
      const selectElement = document.getElementById("degree");

      data.forEach((major) => {
        const option = document.createElement("option");
        option.value = major.id;
        option.textContent = major.major_name;
        selectElement.appendChild(option);
      });
    })
    .catch((error) => {
      console.error("Error fetching majors:", error);
    });
});
