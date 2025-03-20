// Product Management
let currentEditProduct = null;

// Initialize Admin Panel
const initializeAdmin = () => {
  closeEditModal();
  setupImagePreview();
  
  const path = window.location.pathname;
  if (path.includes('manage-products')) {
    fetchProducts();
  }
  if (path.includes('orders')) {
    fetchOrders();
  }
};

// Product Functions
const fetchProducts = () => {
  fetch('/admin/products')
    .then(response => {
      if (!response.ok) throw new Error('Failed to fetch products');
      return response.json();
    })
    .then(products => {
      const productList = document.getElementById('productList');
      productList.innerHTML = products.map(product => `
        <div class="product-item">
          <img src="${product.image}" alt="${product.name}">
          <div class="product-details">
            <p><strong>${product.name}</strong> - ₹${product.price}</p>
            <p>${product.specifications}</p>
            <p>Stock: ${product.stock}</p>
            <div>
              <button onclick="deleteProduct(${product.id})" class="btn-danger">Delete</button>
              <button onclick="openEditModal('${encodeURIComponent(JSON.stringify(product))}')" 
                class="btn-primary">Edit</button>
            </div>
          </div>
        </div>
      `).join('');
    })
    .catch(error => {
      console.error('Product fetch error:', error);
      alert('Failed to load products. Check console for details.');
    });
};

const deleteProduct = (productId) => {
  if (confirm('Permanently delete this product?')) {
    fetch(`/admin/delete-product/${productId}`, { method: 'DELETE' })
      .then(response => {
        if (!response.ok) throw new Error('Delete failed');
        fetchProducts();
      })
      .catch(error => {
        console.error('Delete error:', error);
        alert('Failed to delete product. Check console for details.');
      });
  }
};

// Order Management
const fetchOrders = () => {
  fetch('/admin/orders')
    .then(response => {
      if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
      return response.json();
    })
    .then(orders => {
      const orderList = document.getElementById('orderList');
      orderList.innerHTML = orders.length > 0 ? 
        orders.map(order => `
          <div class="order-item" data-order-id="${order.id}">
            <div class="order-header">
              <span class="order-id">Order #${order.id}</span>
              <span class="order-date">${order.order_date}</span>
            </div>
            <div class="order-body">
              <p><span class="label">User:</span> ${order.username} (ID: ${order.user_id})</p>
              <p><span class="label">Amount:</span> ₹${order.total_amount}</p>
              <p><span class="label">Payment Method:</span> ${order.payment_method}</p>
              <p><span class="label">Transaction ID:</span> ${order.transaction_id || 'Pending'}</p>
            </div>
            <button onclick="verifyOrder(${order.id})" class="btn-danger">
              <i class="fas fa-check-circle"></i> Verify Payment
            </button>
          </div>
        `).join('') : 
        `<div class="no-orders">
          
          <h3>No pending payments to verify</h3>
        </div>`;
    })
    .catch(error => {
      console.error('Order fetch error:', error);
      const orderList = document.getElementById('orderList');
      orderList.innerHTML = `
        <div class="error-alert">
          <i class="fas fa-exclamation-triangle"></i>
          <h3>Failed to load orders</h3>
          <p>${error.message}</p>
          <button onclick="fetchOrders()" class="btn-primary">Retry</button>
        </div>
      `;
    });
};

const verifyOrder = (orderId) => {
  if (confirm('Confirm payment verification for this order?')) {
    fetch(`/admin/verify-order/${orderId}`, { 
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(response => {
      if (!response.ok) throw new Error('Verification failed');
      return response.json();
    })
    .then(data => {
      if (data.success) {
        // Remove verified order from list
        const verifiedOrder = document.querySelector(`[data-order-id="${orderId}"]`);
        if (verifiedOrder) verifiedOrder.remove();
        
        // Show success feedback
        const successAlert = document.createElement('div');
        successAlert.className = 'success-alert';
        successAlert.innerHTML = `
          <i class="fas fa-check-circle"></i>
          Order #${orderId} verified successfully!
        `;
        document.body.appendChild(successAlert);
        
        // Remove alert after 3 seconds
        setTimeout(() => successAlert.remove(), 3000);
        
        // Refresh list if empty
        if (!document.querySelector('.order-item')) fetchOrders();
      }
    })
    .catch(error => {
      console.error('Verification error:', error);
      alert(`Verification failed: ${error.message}`);
    });
  }
};

// Edit Modal Functions
const openEditModal = (encodedProduct) => {
  try {
    const productJSON = decodeURIComponent(encodedProduct);
    currentEditProduct = JSON.parse(productJSON);
    document.getElementById('editName').value = currentEditProduct.name;
    document.getElementById('editPrice').value = currentEditProduct.price;
    document.getElementById('editSpecs').value = currentEditProduct.specifications;
    document.getElementById('editStock').value = currentEditProduct.stock;
    document.getElementById('editImagePreview').src = currentEditProduct.image;
    document.getElementById('editModal').classList.remove('hidden');
  } catch (error) {
    console.error('Edit modal error:', error);
    alert('Failed to load product data. Please try again.');
  }
};

const closeEditModal = () => {
  document.getElementById('editModal').classList.add('hidden');
  currentEditProduct = null;
  document.getElementById('editImage').value = '';
};

const submitUpdate = () => {
  const formData = new FormData();
  formData.append('name', document.getElementById('editName').value);
  formData.append('price', document.getElementById('editPrice').value);
  formData.append('specifications', document.getElementById('editSpecs').value);
  formData.append('stock', document.getElementById('editStock').value);
  
  const imageInput = document.getElementById('editImage');
  if (imageInput.files[0]) formData.append('image', imageInput.files[0]);

  fetch(`/admin/update-product/${currentEditProduct.id}`, {
    method: 'POST',
    body: formData
  })
  .then(response => {
    if (!response.ok) throw new Error('Update failed');
    alert('Product updated successfully!');
    closeEditModal();
    fetchProducts();
  })
  .catch(error => {
    console.error('Update error:', error);
    alert('Failed to update product. Check console for details.');
  });
};

// Image Preview
const setupImagePreview = () => {
  const editImageInput = document.getElementById('editImage');
  if (editImageInput) {
    editImageInput.addEventListener('change', function() {
      if (this.files?.[0]) {
        const reader = new FileReader();
        reader.onload = (e) => {
          document.getElementById('editImagePreview').src = e.target.result;
        };
        reader.readAsDataURL(this.files[0]);
      }
    });
  }
};

// Initialize
document.addEventListener('DOMContentLoaded', initializeAdmin);