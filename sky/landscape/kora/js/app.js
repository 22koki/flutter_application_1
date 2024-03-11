// Define checkoutModal globally
let checkoutModal;

document.addEventListener("DOMContentLoaded", function () {
  const addToCartButtons = document.querySelectorAll('.btn-primary');
  const cartOverlay = document.querySelector('.cart-overlay');
  const cartContainer = document.querySelector('.cart-content');
  const closeModalButton = document.querySelector('.close');

  let totalPrice = 0;

  addToCartButtons.forEach(button => {
    button.addEventListener('click', () => {
      // ... (unchanged)

      // Add logic to handle adding items to the cart
      alert('Item added to cart!');
    });
  });

  function updateTotalPrice() {
    const totalElement = document.getElementById('total-price');
    totalElement.innerText = `Total: $${totalPrice.toFixed(2)}`;
  }

  // Checkout function
  checkoutModal = document.getElementById('checkout-modal');  // Assign checkoutModal globally

  function checkout() {
    // Display the checkout modal
    checkoutModal.style.display = 'block';

    // Close the modal after 2 seconds
    setTimeout(() => {
      checkoutModal.style.display = 'none';
      resetCart();
    }, 2000);
  }

  // Function to reset the cart
  function resetCart() {
    const totalElement = document.getElementById('total-price');
    const cartContainer = document.querySelector('.cart-content');

    if (totalElement && cartContainer) {
      cartContainer.innerHTML = '';
      totalPrice = 0;
      updateTotalPrice();
    }
  }

  // Make checkout globally accessible
  window.checkout = checkout;

  // You can add more logic to show/hide the cart, handle payment, etc.
});
