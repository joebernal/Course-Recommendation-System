document.addEventListener("DOMContentLoaded", function () {
  const userId = 1; // Replace with dynamic ID if using auth
  const container = document.getElementById("plans-container");

  fetch(`http://127.0.0.1:5001/api/plans/user/${userId}`)
    .then((res) => res.json())
    .then((plans) => {
      if (plans.length === 0) {
        container.innerHTML = "<p>No plans found.</p>";
        return;
      }

      plans.forEach((plan) => {
        const div = document.createElement("div");
        div.className = "plan-card";
        div.innerHTML = `
          <h3>${plan.plan_name}</h3>
          <a href="/web/view-plan.html?plan_id=${plan.id}">
            <button class="button secondary">View Plan</button>
          </a>
        `;
        container.appendChild(div);
      });
    })
    .catch((err) => {
      console.error("Failed to load plans:", err);
      container.innerHTML = "<p>Error loading plans.</p>";
    });
});
