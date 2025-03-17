import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import { getAuth, GoogleAuthProvider, signInWithPopup, signOut } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyALBQ_Ip9HoRoURlNKwCHoy0II92Bzt4hk",
    authDomain: "course-recommendation-sys.firebaseapp.com",
    projectId: "course-recommendation-sys",
    storageBucket: "course-recommendation-sys.firebasestorage.app",
    messagingSenderId: "993504943664",
    appId: "1:993504943664:web:4680229913b504129497f5"
};

// Initialize Firebase
console.log("Initializing Firebase");
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
auth.languageCode = 'en';
const provider = new GoogleAuthProvider();

const googleLogin = document.getElementById('google-login-btn');
if (googleLogin)
googleLogin.addEventListener("click", function () {
    signInWithPopup(auth, provider)
        .then((result) => {
            const credential = GoogleAuthProvider.credentialFromResult(result);
            const user = result.user;
            window.location.href = '/web/dashboard.html';
        }).catch((error) => {
            const errorCode = error.code;
            const errorMessage = error.message;
        });
});

const googleSignout = document.getElementById('google-signout-btn');
googleSignout.addEventListener("click", function () {
    signOut(auth).then(() => {
        window.location.href = '/web/index.html';
    }).catch((error) => {
        
    });
});