const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const path = require('path');
const session = require('express-session');
const ejs = require('ejs');
const nodemailer = require('nodemailer');
const qrcode = require('qrcode');
const fs = require('fs');
const easyinvoice = require('easyinvoice');

require('dotenv').config({ path: '.git/.env' });


const app = express();

// ------------------------------
//    1) BASIC MIDDLEWARE
// ------------------------------
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/qrforpayments', express.static(path.join(__dirname, 'qrforpayments')));
// Serve invoices (we will force download via a dedicated route)
app.use('/invoices', express.static(path.join(__dirname, 'invoices')));
app.use(session({
  secret: 'secret',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false, maxAge: 3600000 }
}));
app.set('view engine', 'ejs');

// ------------------------------
//    2) DB CONNECTIONS
// ------------------------------
const authDB = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_AUTH_DATABASE
});

const productDB = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_PRODUCT_DATABASE
});

authDB.connect(err => {
  if (err) throw err;
  console.log('Connected to authentication database');
});

productDB.connect(err => {
  if (err) throw err;
  console.log('Connected to product database');
  console.log('This project was created by J03');
});

// ------------------------------
//    3) NODEMAILER (OTP)
// ------------------------------
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

// ------------------------------
//    4) QR CODE UTILITY
// ------------------------------
const generateQRCode = (amount, username, orderId) => {
  return new Promise((resolve, reject) => {
    const upiString = `upi://pay?pa=umangbpatel6609@okaxis&pn=Umang%20Patel&am=${amount.toFixed(2)}&cu=INR&aid=uGICAgMCC5aG0bQ`;
    const parentFolderPath = path.join(__dirname, 'qrforpayments');
    const userFolderPath = path.join(parentFolderPath, username);
    const filePath = path.join(userFolderPath, `${username}-${orderId}-qr-code.png`);

    if (!fs.existsSync(parentFolderPath)) fs.mkdirSync(parentFolderPath, { recursive: true });
    if (!fs.existsSync(userFolderPath)) fs.mkdirSync(userFolderPath);

    qrcode.toFile(filePath, upiString, {
      color: { dark: '#32BE8F', light: '#ffffff' },
      width: 200,
      margin: 2
    }, (err) => {
      if (err) reject(err);
      else resolve(filePath);
    });
  });
};

// ------------------------------
//    5) INVOICE GENERATION
//    (Using order_items table to get actual product details)
// ------------------------------
const generateInvoiceWithItems = async (orderId, username, items) => {
 
  const products = items.map(item => ({
    quantity: item.quantity,
    description: item.name,
    tax: 0,
    price: item.price
  }));

  const invoiceData = {
    documentTitle: "Invoice",
    currency: "USD",
    taxNotation: "vat",
    marginTop: 25,
    marginRight: 25,
    marginLeft: 25,
    marginBottom: 25,
    sender: {
      company: "Phone World",
      address: "KSV",
      zip: "382028",
      city: "Ghandhinagar",
      country: "India"
    },
    client: {
      company: username
    },
    invoiceNumber: orderId.toString(),
    invoiceDate: new Date().toISOString().split('T')[0],
    products,
    bottomNotice: "Thank you for your business! This Project Was Created By J03 "
  };

  const result = await easyinvoice.createInvoice(invoiceData);
  const invoiceFileName = `invoice-${orderId}.pdf`;
  const invoicesDir = path.join(__dirname, 'invoices');
  if (!fs.existsSync(invoicesDir)) fs.mkdirSync(invoicesDir);
  fs.writeFileSync(path.join(invoicesDir, invoiceFileName), result.pdf, 'base64');
  // Return a route that forces download.
  return `/download-invoice/${invoiceFileName}`;
};

// ------------------------------
//      AUTH ROUTES
// ------------------------------
app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'auth.html'));
});

app.post('/login', (req, res) => {
  const { username, password } = req.body;
  authDB.query(
    'SELECT id, username FROM users WHERE username = ? AND password = ?',
    [username, password],
    (err, results) => {
      if (err) throw err;
      if (results.length > 0) {
        req.session.userId = results[0].id;
        req.session.username = results[0].username;
        res.redirect('/homepage');
      } else {
        res.redirect('/login?message=Invalid credentials');
      }
    }
  );
});

app.get('/signup', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'auth.html'));
});

app.post('/signup', (req, res) => {
  const { username, password, email } = req.body;

  authDB.query(
    'SELECT * FROM users WHERE email = ? OR username = ?',
    [email, username],
    (err, results) => {
      if (err) throw err;
      if (results.length > 0) {
        return res.redirect('/signup?message=Username or email already exists');
      }

      const otp = Math.floor(100000 + Math.random() * 900000);
      const expiresAt = new Date(Date.now() + 5 * 60000);

      authDB.query(
        'INSERT INTO otps (email, otp, expires_at) VALUES (?, ?, ?)',
        [email, otp, expiresAt],
        (err) => {
          if (err) throw err;

          const mailOptions = {
            from: 'phoneworld.ksv@gmail.com',
            to: email,
            subject: 'PhoneWorld Verification OTP',
            html: `
            <div style="max-width: 500px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; font-family: Arial, sans-serif; background: #f9f9f9;">
              <h2 style="text-align: center; color: #003cff;">Your OTP Verification Code</h2>
              <p style="font-size: 16px; color: #333;">Hello,</p>
              <p style="font-size: 16px; color: #333;">Use the following One-Time Password (OTP) to verify your login:</p>
              <div style="text-align: center; font-size: 24px; font-weight: bold; background: #003cff; color: white; padding: 10px; border-radius: 5px;">
                ${otp}
              </div>
              <p style="font-size: 14px; color: #555;">This OTP is valid for <strong>5 minutes</strong>. Please do not share it with anyone.</p>
              <hr>
              <p style="font-size: 12px; text-align: center; color: #888;">If you did not request this, please ignore this email.</p>
            </div>
          `
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              console.error('Error sending email:', error);
              return res.redirect('/signup?message=Error sending OTP');
            }

            req.session.tempUser = { username, password, email };
            res.redirect('/verify-otp');
          });
        }
      );
    }
  );
});

app.get('/verify-otp', (req, res) => {
  if (!req.session.tempUser) return res.redirect('/signup');
  res.sendFile(path.join(__dirname, 'public', 'verify-otp.html'));
});

app.post('/verify-otp', (req, res) => {
  const { otp } = req.body;
  const { email } = req.session.tempUser;

  authDB.query(
    'SELECT * FROM otps WHERE email = ? AND otp = ? AND expires_at > NOW()',
    [email, otp],
    (err, results) => {
      if (err) throw err;

      if (results.length === 0) {
        return res.redirect('/verify-otp?message=Invalid or expired OTP');
      }

      authDB.query(
        'INSERT INTO users (username, password, email) VALUES (?, ?, ?)',
        [req.session.tempUser.username, req.session.tempUser.password, email],
        (err, result) => {
          if (err) throw err;

          authDB.query('DELETE FROM otps WHERE email = ?', [email]);
          const tempUsername = req.session.tempUser.username;
          delete req.session.tempUser;
          req.session.username = tempUsername;
          req.session.userId = result.insertId;

          res.redirect('/homepage');
        }
      );
    }
  );
});

// ------------------------------
//   PRODUCT + CART ROUTES
// ------------------------------
app.post('/add-product', (req, res) => {
  const { name, price, specifications, stock, image_url } = req.body;
  const imagePath = image_url; // Directly use the URL

  productDB.query(
    'INSERT INTO products (name, price, specifications, image, stock) VALUES (?, ?, ?, ?, ?)',
    [name, price, specifications, imagePath, stock],
    (err) => {
      if (err) throw err;
      res.redirect('/admin/manage-products.html');
    }
  );
});

// NEW UPDATE PRODUCT ROUTE
app.post('/admin/update-product/:id', (req, res) => {
  const productId = req.params.id;
  const { name, price, specifications, stock, image_url } = req.body;

  productDB.query('SELECT * FROM products WHERE id = ?', [productId], (err, results) => {
    if (err) throw err;
    if (results.length === 0) return res.status(404).json({ success: false, message: 'Product not found' });

    const currentProduct = results[0];
    const imagePath = image_url || currentProduct.image;

    productDB.query(
      `UPDATE products SET 
        name = ?, 
        price = ?, 
        specifications = ?, 
        image = ?, 
        stock = ?
      WHERE id = ?`,
      [name, price, specifications, imagePath, stock, productId],
      (err) => {
        if (err) throw err;
        res.json({ success: true });
      }
    );
  });
});

app.get('/products', (req, res) => {
  productDB.query('SELECT * FROM products', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

app.get('/admin/products', (req, res) => {
  productDB.query('SELECT * FROM products', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

app.delete('/admin/delete-product/:id', (req, res) => {
  const productId = req.params.id;

  productDB.query('DELETE FROM products WHERE id = ?', [productId], (err) => {
    if (err) throw err;
    res.json({ success: true });
  });
});

// ------------------------------
//       CART
// ------------------------------
app.post('/add-to-cart', (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Please login first' });

  const { productId, quantity } = req.body;

  productDB.query(
    'SELECT stock FROM products WHERE id = ?',
    [productId],
    (err, results) => {
      if (err) throw err;

      if (results.length === 0) {
        return res.status(404).json({ message: 'Product not found' });
      }

      const availableStock = results[0].stock;

      if (availableStock < quantity) {
        return res.status(400).json({
          message: `Only ${availableStock} items available in stock`
        });
      }

      productDB.query(
        `INSERT INTO cart (user_id, product_id, quantity)
         VALUES (?, ?, ?)
         ON DUPLICATE KEY UPDATE quantity = VALUES(quantity)`,
        [req.session.userId, productId, quantity],
        (err) => {
          if (err) throw err;
          res.json({ message: 'Cart updated successfully' });
        }
      );
    }
  );
});

app.get('/cart', (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Please login first' });

  productDB.query(
    `SELECT p.id, p.name, p.price, p.image, p.stock, c.quantity
     FROM cart c
     JOIN products p ON c.product_id = p.id
     WHERE c.user_id = ?
     ORDER BY p.id ASC`,
    [req.session.userId],
    (err, results) => {
      if (err) throw err;
      res.json(results);
    }
  );
});

app.post('/remove-from-cart', (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Please login first' });

  const { productId } = req.body;

  productDB.query(
    'DELETE FROM cart WHERE user_id = ? AND product_id = ?',
    [req.session.userId, productId],
    (err) => {
      if (err) throw err;
      res.json({ message: 'Item removed from cart' });
    }
  );
});

// ------------------------------
//    CHECKOUT ROUTES
// ------------------------------
app.post('/checkout', async (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Please login first' });

  try {
    const { paymentMethod } = req.body;

    // 1) Get cart items
    const cartItems = await new Promise((resolve, reject) => {
      productDB.query(
        `SELECT p.id, p.name, p.price, p.stock, c.quantity
         FROM cart c
         JOIN products p ON c.product_id = p.id
         WHERE c.user_id = ?`,
        [req.session.userId],
        (err, results) => err ? reject(err) : resolve(results)
      );
    });

    if (cartItems.length === 0) {
      return res.status(400).json({ message: 'Cart is empty' });
    }

    // 2) Check stock for each item
    for (const item of cartItems) {
      if (item.quantity > item.stock) {
        return res.status(400).json({
          message: `Only ${item.stock} items available for ${item.name}`
        });
      }
    }

    // 3) Calculate total amount
    const total = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const orderStatus = paymentMethod === 'cod' ? 'verified' : 'pending';

    // 4) Insert order into orders table
    const orderResult = await new Promise((resolve, reject) => {
      productDB.query(
        `INSERT INTO orders (user_id, username, total_amount, status, payment_method)
         VALUES (?, ?, ?, ?, ?)`,
        [req.session.userId, req.session.username, total, orderStatus, paymentMethod],
        (err, result) => err ? reject(err) : resolve(result)
      );
    });
    const orderId = orderResult.insertId;

    // 5) Insert each cart item into order_items table
    for (const item of cartItems) {
      await new Promise((resolve, reject) => {
        productDB.query(
          `INSERT INTO order_items (order_id, product_id, quantity, price)
           VALUES (?, ?, ?, ?)`,
          [orderId, item.id, item.quantity, item.price],
          (err) => err ? reject(err) : resolve()
        );
      });
    }

    // 6) Update product stock
    for (const item of cartItems) {
      await new Promise((resolve, reject) => {
        productDB.query(
          'UPDATE products SET stock = stock - ? WHERE id = ?',
          [item.quantity, item.id],
          (err) => err ? reject(err) : resolve()
        );
      });
    }

    // 7) Clear the user's cart
    await new Promise((resolve, reject) => {
      productDB.query(
        'DELETE FROM cart WHERE user_id = ?',
        [req.session.userId],
        (err) => err ? reject(err) : resolve()
      );
    });

    // 8) For UPI payments, generate a QR code
    if (paymentMethod === 'upi') {
      await generateQRCode(total, req.session.username, orderId);
    }

    // 9) Return order info (invoice will be generated later on transaction submission)
    res.json({
      success: true,
      orderId,
      username: req.session.username,
      paymentMethod
    });

  } catch (err) {
    console.error('Checkout error:', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// ------------------------------
//    TRANSACTION ROUTES
// ------------------------------
app.post('/submit-transaction', (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Please login first' });

  const { orderId, transactionId } = req.body;
  if (!orderId || !transactionId) {
    return res.status(400).json({ success: false, message: 'Missing orderId or transactionId' });
  }

  productDB.query(
    'UPDATE orders SET transaction_id = ?, status = "pending_verification" WHERE id = ? AND user_id = ?',
    [transactionId, orderId, req.session.userId],
    (err, result) => {
      if (err) {
        console.error('Error updating transaction:', err);
        return res.status(500).json({ success: false, message: 'Internal server error' });
      }
      if (result.affectedRows === 0) {
        return res.json({ success: false, message: 'Order not found or not authorized' });
      }
      // Retrieve order items from order_items to generate invoice
      productDB.query(
        `SELECT p.name, oi.quantity, oi.price
         FROM order_items oi
         JOIN products p ON oi.product_id = p.id
         WHERE oi.order_id = ?`,
        [orderId],
        async (err, items) => {
          if (err) {
            console.error('Error fetching order items:', err);
            return res.status(500).json({ success: false, message: 'Internal server error' });
          }
          if (items.length === 0) {
            return res.json({ success: true, invoiceUrl: "" });
          }
          try {
            const invoiceUrl = await generateInvoiceWithItems(orderId, req.session.username, items);
            res.json({ success: true, invoiceUrl });
          } catch (err) {
            console.error("Invoice generation error:", err);
            res.json({ success: true, invoiceUrl: "" });
          }
        }
      );
    }
  );
});

// ------------------------------
//    ADMIN ROUTES
// ------------------------------
app.get('/admin/orders', (req, res) => {
  productDB.query(
    'SELECT * FROM orders WHERE status = "pending_verification"',
    (err, results) => {
      if (err) throw err;
      res.json(results);
    }
  );
});

app.post('/admin/verify-order/:orderId', (req, res) => {
  const orderId = req.params.orderId;
  productDB.query(
    'UPDATE orders SET status = "verified" WHERE id = ?',
    [orderId],
    (err) => {
      if (err) throw err;
      res.json({ success: true });
    }
  );
});

// ------------------------------
//    PROTECTED ROUTES
// ------------------------------
app.get('/homepage', (req, res) => {
  res.render('homepage', { username: req.session.username });
});

app.get('/admin', (req, res) => {
  res.redirect('/admin/manage-products.html');
});

// ------------------------------
//    STATIC ROUTES
// ------------------------------
app.get('/products-page', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'products.html'));
});

app.get('/cart-page', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'cart.html'));
});

app.get('/payment/:orderId', (req, res) => {
  if (!req.session.userId) return res.redirect('/login');
  res.sendFile(path.join(__dirname, 'public', 'payment.html'));
});

// ------------------------------
//      DOWNLOAD INVOICE ROUTE
// ------------------------------
app.get('/download-invoice/:filename', (req, res) => {
  const filename = req.params.filename;
  const filePath = path.join(__dirname, 'invoices', filename);
  res.download(filePath, filename, (err) => {
    if (err) {
      console.error('Error sending file:', err);
      res.status(500).send('Error downloading file.');
    }
  });
});

// ------------------------------
//      LOGOUT
// ------------------------------
app.get('/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/login');
});

// ------------------------------
//    ADMIN ORDER HISTORY
// ------------------------------
app.get('/admin/order-history', (req, res) => {
  productDB.query(
    'SELECT * FROM orders ORDER BY order_date DESC',
    (err, results) => {
      if (err) throw err;
      res.json(results);
    }
  );
});

// ------------------------------
//   USER ORDERS
// ------------------------------
app.get('/api/orders', (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Please login first' });

  productDB.query(
    'SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC',
    [req.session.userId],
    (err, orders) => {
      if (err) return res.status(500).json({ message: 'Internal Server Error' });

      if (orders.length === 0) return res.json([]);

      let processedCount = 0;
      orders.forEach((order, index) => {
        productDB.query(
          `SELECT p.name, p.image, oi.quantity, oi.price 
           FROM order_items oi 
           JOIN products p ON oi.product_id = p.id 
           WHERE oi.order_id = ?`,
          [order.id],
          (err, items) => {
            if (err) {
              console.error(`Error fetching items for order ${order.id}:`, err);
              orders[index].items = [];
            } else {
              orders[index].items = items;
            }
            processedCount++;
            if (processedCount === orders.length) {
              res.json(orders);
            }
          }
        );
      });
    }
  );
});

// ------------------------------
//      START SERVER
// ------------------------------
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

app.get('/', (req, res) => {
 
  res.redirect('/homepage');
});
