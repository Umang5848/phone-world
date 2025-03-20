const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const path = require('path');
const session = require('express-session');
const ejs = require('ejs');
const multer = require('multer');
const fs = require('fs');
const nodemailer = require('nodemailer');
const qrcode = require('qrcode');

const app = express();

// ------------------------------
//    1) BASIC MIDDLEWARE
// ------------------------------
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/qrforpayments', express.static(path.join(__dirname, 'qrforpayments')));
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
  host: 'sql12.freesqldatabase.com',
  user: 'sql12768683',
  password: 'N3JQHGB7ZM',
  database: 'sql12768683'
});

const productDB = mysql.createConnection({
  host: 'sql12.freesqldatabase.com',
  user: 'sql12768683',
  password: 'N3JQHGB7ZM',
  database: 'sql12768683'
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
    user: 'phoneworld.ksv@gmail.com',
    pass: 'skdh qimq splg yzhc'
  }
});

// ------------------------------
//    4) MULTER SETUP
// ------------------------------
const storage = multer.diskStorage({
  destination: './uploads/',
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage });

// ------------------------------
//    5) QR CODE UTILITY
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

// ======================
//      AUTH ROUTES
// ======================

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

// ======================
//   PRODUCT + CART ROUTES
// ======================

app.post('/add-product', upload.single('image'), (req, res) => {
  const { name, price, specifications, stock } = req.body;
  const imagePath = `/uploads/${req.file.filename}`;

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
app.post('/admin/update-product/:id', upload.single('image'), (req, res) => {
  const productId = req.params.id;
  const { name, price, specifications, stock } = req.body;
  
  productDB.query('SELECT * FROM products WHERE id = ?', [productId], (err, results) => {
    if (err) throw err;
    if (results.length === 0) return res.status(404).json({ success: false, message: 'Product not found' });

    const currentProduct = results[0];
    const imagePath = req.file ? `/uploads/${req.file.filename}` : currentProduct.image;

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

// ======================
//       CART
// ======================
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

// ======================
//    CHECKOUT ROUTES
// ======================
app.post('/checkout', async (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Please login first' });

  try {
    const { paymentMethod } = req.body;

    const cartItems = await new Promise((resolve, reject) => {
      productDB.query(`SELECT p.id, p.price, c.quantity, p.stock, p.name
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

    for (const item of cartItems) {
      if (item.quantity > item.stock) {
        return res.status(400).json({
          message: `Only ${item.stock} items available for ${item.name}`
        });
      }
    }

    const total = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const orderStatus = paymentMethod === 'cod' ? 'verified' : 'pending';

    const orderResult = await new Promise((resolve, reject) => {
      productDB.query(`INSERT INTO orders (user_id, username, total_amount, status, payment_method) 
        VALUES (?, ?, ?, ?, ?)`,
        [req.session.userId, req.session.username, total, orderStatus, paymentMethod],
        (err, result) => err ? reject(err) : resolve(result)
      );
    });

    for (const item of cartItems) {
      await new Promise((resolve, reject) => {
        productDB.query(
          'UPDATE products SET stock = stock - ? WHERE id = ?',
          [item.quantity, item.id],
          (err) => err ? reject(err) : resolve()
        );
      });
    }

    await new Promise((resolve, reject) => {
      productDB.query(
        'DELETE FROM cart WHERE user_id = ?',
        [req.session.userId],
        (err) => err ? reject(err) : resolve()
      );
    });

    const orderId = orderResult.insertId;
    if (paymentMethod === 'upi') {
      await generateQRCode(total, req.session.username, orderId);
    }

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

// ======================
//    TRANSACTION ROUTES
// ======================
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
      res.json({ success: true });
    }
  );
});

// ======================
//    ADMIN ROUTES
// ======================
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

// ======================
//    PROTECTED ROUTES
// ======================
app.get('/homepage', (req, res) => {
  res.render('homepage', { username: req.session.username });
});

app.get('/admin', (req, res) => {
  res.redirect('/admin/manage-products.html');
});

// ======================
//    STATIC ROUTES
// ======================
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

// ======================
//      LOGOUT
// ======================
app.get('/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/login');
});


// ======================
//    ADMIN ORDER HISTORY
// ======================
app.get('/admin/order-history', (req, res) => {
  productDB.query(
    'SELECT * FROM orders ORDER BY order_date DESC',
    (err, results) => {
      if (err) throw err;
      res.json(results);
    }
  );
});


// ======================
//    START SERVER
// ======================
app.listen(3000, () => {
  console.log('Server running on port 3000');
});













app.get('/', (req, res) => {
  res.send('Welcome to Phone World! Ngrok is working.');
});
