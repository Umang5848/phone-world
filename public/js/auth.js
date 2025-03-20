// public/js/auth.js
const container = document.getElementById('container');
const loginBtn = document.getElementById('login');
const registerBtn = document.getElementById('register');

loginBtn.addEventListener('click', () => {
    container.classList.remove("active");
    history.replaceState(null, null, '/login');
});

registerBtn.addEventListener('click', () => {
    container.classList.add("active");
    history.replaceState(null, null, '/signup');
});

// Handle initial state based on URL
document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const mode = urlParams.get('mode');
    
    if (mode === 'signup') {
        container.classList.add("active");
    }
});