// checkout.js

document.addEventListener('DOMContentLoaded', function () {
    // Get the cart items from localStorage
    const cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];

    // Get the cart items container
    const cartItemsContainer = document.querySelector('.cart-items');

    // Function to render cart items
    function renderCartItems() {
        // Clear existing items
        cartItemsContainer.innerHTML = '';

        // Render each item in the cart
        cartItems.forEach((item, index) => {
            const cartItemElement = document.createElement('div');
            cartItemElement.classList.add('cart-item');

            cartItemElement.innerHTML = `
                <p>${item.name} - $${item.price.toFixed(2)}</p>
            `;

            cartItemsContainer.appendChild(cartItemElement);
        });
    }

    // Render cart items when the page loads
    renderCartItems();
});
