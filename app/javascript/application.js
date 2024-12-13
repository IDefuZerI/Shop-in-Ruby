document.addEventListener("DOMContentLoaded", () => {
    const switchToRegister = document.getElementById("switchToRegister");
    const switchToLogin = document.getElementById("switchToLogin");
    const modalTitle = document.getElementById("loginModalLabel");
    const loginForm = document.getElementById("loginForm");
    const registerForm = document.getElementById("registerForm");
    const loginFooterText = document.getElementById("loginFooterText");
    const registerFooterText = document.getElementById("registerFooterText");
    const logoutLink = document.getElementById("logoutLink");

    // Display login form by default
    if (loginForm && registerForm && modalTitle) {
        loginForm.style.display = "block";
        registerForm.style.display = "none";
        loginFooterText.style.display = "block";
        registerFooterText.style.display = "none";

        switchToRegister?.addEventListener("click", (e) => {
            e.preventDefault();
            modalTitle.textContent = "Реєстрація";
            loginForm.style.display = "none";
            registerForm.style.display = "block";
            loginFooterText.style.display = "none";
            registerFooterText.style.display = "block";
        });

        switchToLogin?.addEventListener("click", (e) => {
            e.preventDefault();
            modalTitle.textContent = "Авторизація";
            loginForm.style.display = "block";
            registerForm.style.display = "none";
            loginFooterText.style.display = "block";
            registerFooterText.style.display = "none";
        });
    }

    // Handle login form submission
    loginForm?.addEventListener("submit", (e) => {
        e.preventDefault();
        const formData = new FormData(loginForm);
        fetch("/login", {
            method: "POST",
            body: formData,
            headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert(data.message, "success");
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showAlert(data.error, "danger");
                }
            });
    });

    // Handle registration form submission with field validation
    registerForm?.addEventListener("submit", (e) => {
        e.preventDefault();

        const email = document.getElementById("registerEmail").value.trim();
        const password = document.getElementById("registerPassword").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();

        // Check if any field is empty
        if (!email || !password || !confirmPassword) {
            showAlert("Поля не можуть бути порожніми", "danger");
            return;
        }

        // Check if passwords match
        if (password !== confirmPassword) {
            showAlert("Паролі не співпадають", "danger");
            return;
        }

        const formData = new FormData(registerForm);
        fetch("/signup", {
            method: "POST",
            body: formData,
            headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content }
        })
            .then(response => response.json().then(data => ({ status: response.status, data })))
            .then(({ status, data }) => {
                if (status === 200) {
                    showAlert(data.message, "success");
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showAlert(data.errors.join("\n"), "danger");
                }
            })
            .catch(error => console.error("Помилка при реєстрації:", error));
    });

    // Обробка натискання на кнопку "Вихід"
    if (logoutLink) {
        logoutLink.addEventListener("click", (e) => {
            e.preventDefault();

            fetch("/logout", {
                method: "DELETE",
                headers: {
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                    "Content-Type": "application/json"
                }
            })
                .then(response => {
                    if (response.ok) {
                        showAlert("Ви успішно вийшли з облікового запису", "success");
                        setTimeout(() => window.location.href = "/", 1500); // Перенаправляє на головну сторінку через 1.5 секунди
                    } else {
                        showAlert("Не вдалося вийти з облікового запису", "danger");
                    }
                })
                .catch(error => console.error("Помилка при виході:", error));
        });
    }

    // Обробка натискання кнопки "Купити"
    document.querySelectorAll(".buy-button").forEach(button => {
        button.addEventListener("click", (e) => {
            e.preventDefault();
            const productId = button.getAttribute("data-product-id");

            fetch(`/cart_items/${productId}`, {
                method: "POST",
                headers: {
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                    "Content-Type": "application/json",
                    "Accept": "application/json" // Зазначимо, що очікуємо JSON відповідь
                },
                body: JSON.stringify({ product_id: productId })
            })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(data => {
                            throw new Error(data.message || "Сталася помилка");
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        showAlert(data.message, "success");
                    } else {
                        showAlert(data.message, "danger");
                    }
                })
                .catch(error => {
                    showAlert(error.message, "danger");
                    console.error("Помилка при додаванні до кошика:", error);
                });
        });
    });

    // Обробка кнопок збільшення та зменшення кількості в кошику
    document.querySelectorAll(".increment-button, .decrement-button").forEach(button => {
        button.addEventListener("click", (e) => {
            e.preventDefault();
            const itemId = button.getAttribute("data-item-id");
            const action = button.classList.contains("increment-button") ? "increment" : "decrement";

            fetch(`/cart_items/${itemId}/${action}`, {
                method: "PATCH",
                headers: {
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                    "Accept": "text/javascript" // Вкажемо, що очікуємо JavaScript відповідь
                }
            })
                .then(response => {
                    if (!response.ok) throw new Error("Network response was not ok.");
                    return response.text();
                })
                .then(js => eval(js)) // Виконуємо JavaScript відповідь на клієнті
                .catch(error => console.error("Помилка при оновленні кількості товару:", error));
        });
    });

    // Функція для відображення повідомлення
    function showAlert(message, type = "success", timeout = 3000) {
        const alertContainer = document.getElementById("alert-container");
        const alertDiv = document.createElement("div");
        alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
        alertDiv.role = "alert";
        alertDiv.innerHTML = `${message} <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>`;
        alertContainer.appendChild(alertDiv);

        setTimeout(() => {
            alertDiv.classList.remove("show");
            alertDiv.classList.add("hide");
            alertDiv.addEventListener("transitionend", () => alertDiv.remove());
        }, timeout);
    }
});
