document.getElementById("loginForm").addEventListener("submit", function(event) {
    event.preventDefault(); 

    let username = document.getElementById("username").value;
    let password = document.getElementById("password").value;
    let rememberMe = document.getElementById("rememberMe").checked;

    if (username && password) {  // Acepta cualquier usuario y contraseña si no están vacíos
        localStorage.setItem("loggedInUser", username);
        localStorage.setItem("userPassword", password); // Guarda la contraseña (opcional)
        
        if (rememberMe) {
            localStorage.setItem("rememberMe", "true");
        }

        console.log("Usuario guardado:", username); // Depuración en consola
        window.location.href = "main.html"; // Redirección a la página principal
    } else {
        alert("Por favor, ingresa un usuario y una contraseña válidos.");
    }
});

// scripts/login.js

// Tu código existente de document.getElementById("loginForm").addEventListener...

function checkLogin() {
    let user = localStorage.getItem("loggedInUser");
    const userWelcomeSpan = document.getElementById("userWelcome");

    if (!user) {
        // No es necesario alertar aquí si la página main.html siempre requiere login
        // La redirección se manejará si se accede directamente sin estar logueado
        console.log("No autenticado, redirigiendo a index.html");
        window.location.href = "index.html";
    } else {
        if (userWelcomeSpan) {
            // InnerHTML permite usar el icono de Font Awesome
            userWelcomeSpan.innerHTML = `<i class="fas fa-user-circle"></i> Bienvenido, ${user}`; 
        }
    }
}

function logout() {
    localStorage.removeItem("loggedInUser");
    localStorage.removeItem("userPassword"); // Asegúrate de remover esto si lo guardas
    localStorage.removeItem("rememberMe"); // Y esto también
    window.location.href = "index.html";
}

// Llama a checkLogin cuando el DOM esté listo si no usas onload en body
// document.addEventListener('DOMContentLoaded', checkLogin); 
// Si ya tienes onload="checkLogin()" en el body, esto no es necesario.
