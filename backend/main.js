import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  signOut,
} from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

console.log("Fetching Firebase Configuration...");

// Fetch Firebase config from Flask API
fetch(
  "https://course-recommendation-system-8lj7.onrender.com/api/firebase-config"
)
  .then((response) => response.json())
  .then((firebaseConfig) => {
    console.log("Firebase Config Loaded", firebaseConfig);

    // Initialize Firebase with the fetched config
    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    auth.languageCode = "en";
    const provider = new GoogleAuthProvider();

    // Google Login Button Event Listener
    const googleLogin = document.getElementById("google-login-btn");
    googleLogin.addEventListener("click", function () {
      signInWithPopup(auth, provider)
        .then((result) => {
          const user = result.user;
          alert("Welcome " + user.displayName);
        })
        .catch((error) => {
          console.error("Error during login:", error);
        });
    });

    // Google Sign-out Button Event Listener
    const googleSignout = document.getElementById("google-signout-btn");
    googleSignout.addEventListener("click", function () {
      signOut(auth)
        .then(() => {
          alert("Signed out");
        })
        .catch((error) => {
          console.error("Error during sign-out:", error);
        });
    });
  })
  .catch((error) => console.error("Failed to fetch Firebase config:", error));
