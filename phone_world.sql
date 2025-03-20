-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 06, 2025 at 08:18 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `phone_world`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `product_id`, `quantity`) VALUES
(4, 22, 3, 1),
(5, 22, 6, 1),
(907, 31, 3, 3),
(908, 31, 10, 6),
(916, 32, 3, 3),
(919, 33, 3, 6),
(937, 35, 6, 3),
(941, 36, 3, 1),
(944, 39, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','pending_verification','verified') DEFAULT 'pending',
  `payment_method` varchar(10) NOT NULL DEFAULT 'upi',
  `transaction_id` varchar(255) NOT NULL DEFAULT 'NOT NEEDED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `order_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `username`, `total_amount`, `status`, `payment_method`, `transaction_id`, `created_at`, `order_date`) VALUES
(17, 26, 'um', 51999.00, 'verified', 'upi', '122334455667', '2025-02-28 04:08:58', '2025-03-06 17:57:12'),
(18, 26, 'um', 51999.00, 'pending', 'upi', 'NOT NEEDED', '2025-02-28 04:23:46', '2025-03-06 17:57:12'),
(19, 26, 'um', 51999.00, 'verified', 'upi', '111111111111', '2025-03-01 16:24:44', '2025-03-06 17:57:12'),
(20, 26, 'um', 51999.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:26:57', '2025-03-06 17:57:12'),
(21, 26, 'um', 0.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:27:02', '2025-03-06 17:57:12'),
(22, 26, 'um', 0.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:27:33', '2025-03-06 17:57:12'),
(23, 26, 'um', 64900.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:30:05', '2025-03-06 17:57:12'),
(24, 26, 'um', 51999.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:43:56', '2025-03-06 17:57:12'),
(25, 26, 'um', 51999.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:44:59', '2025-03-06 17:57:12'),
(26, 26, 'um', 51999.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:46:10', '2025-03-06 17:57:12'),
(27, 26, 'um', 64900.00, 'verified', 'cod', 'NOT NEEDED', '2025-03-01 16:54:21', '2025-03-06 17:57:12'),
(28, 26, 'um', 20999.00, 'verified', 'cod', 'NOT NEEDED', '2025-03-01 16:59:50', '2025-03-06 17:57:12'),
(29, 26, 'um', 20999.00, 'pending_verification', 'upi', '1223344556566', '2025-03-02 06:11:28', '2025-03-06 17:57:12'),
(30, 26, 'um', 64900.00, 'verified', 'upi', 'ERTYAQRTGAWEG', '2025-03-02 06:12:24', '2025-03-06 17:57:12'),
(31, 26, 'um', 99999.00, 'verified', 'upi', '111111111111', '2025-03-02 06:21:01', '2025-03-06 17:57:12'),
(32, 26, 'um', 64900.00, 'verified', 'upi', 'Ehehegegeg', '2025-03-02 06:33:57', '2025-03-06 17:57:12'),
(33, 26, 'um', 129800.00, 'pending', 'upi', 'NOT NEEDED', '2025-03-06 15:03:06', '2025-03-06 17:57:12'),
(34, 26, 'um', 51999.00, 'verified', 'upi', '1122334455', '2025-03-06 17:35:47', '2025-03-06 17:57:12'),
(35, 26, 'um', 13.00, 'verified', 'upi', '1234567878', '2025-03-06 19:07:47', '2025-03-06 19:07:47');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `specifications` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT 'Phone World',
  `original_price` decimal(10,2) DEFAULT NULL,
  `rating` int(11) DEFAULT 5,
  `stock` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `specifications`, `image`, `category`, `original_price`, `rating`, `stock`) VALUES
(3, 'Apple iPhone 14 (Blue, 128 GB)', 51999.00, '128 GB ROM\r\n15.49 cm (6.1 inch) Super Retina XDR Display\r\n12MP + 12MP Dual Rear Camera\r\n12MP Front Camera\r\nA15 Bionic Chip, 6-Core Processor', '/uploads/1738300544097.webp', 'Phone World', NULL, 5, 183),
(6, 'Apple iPhone 15 (128GB, Black)', 64900.00, 'Display: 6.1 inches (15.54 cm)\r\nProcessor: Apple A16 Bionic Chip\r\nCamera: 48 MP + 12 MP Dual Rear & 12 MP Front Camera\r\nUSP: Dynamic Island, IP68 Water Resistant', '/uploads/1738429961339.webp', 'Phone World', NULL, 5, 124),
(10, 'Apple iPhone 13 (128GB, Blue)', 46400.00, 'Display: 6.1 inches (15.4 cm)\r\nMemory: 128GB ROM\r\nProcessor: Apple A15 Bionic Chip, Hexa Core\r\nCamera: 12 MP + 12 MP Dual Rear \r\nBattery: 3240 mAh \r\nIP68 Water Resistant', '/uploads/1739384490335.jpg', 'Phone World', NULL, 5, 123),
(11, 'Infinix GT 20 Pro', 20999.00, '8 GB RAM | 256 GB ROM\r\n17.22 cm (6.78 inch) Full HD+ Display\r\n108MP (OIS) + 2MP + 2MP | 32MP Front Camera\r\n5000 mAh Battery\r\nDimensity 8200 Ultimate Processor', '/uploads/1739972066901.jpg', 'Phone World', NULL, 5, 98),
(12, 'Apple iPhone 16 (128GB Storage, Teal)', 69999.00, 'iOS 18 Operating System\r\nA18 chip with 5-core GPU\r\n6.1-inch all-screen OLED display \r\n48MP Main + 12MP Camera\r\n12 MP Front Camera\r\nIP68 Splash and Water Resistant', '/uploads/1739973211389.jpg', 'Phone World', NULL, 5, 133),
(13, 'Google Pixel 8a (Aloe, 128 GB)  (8 GB RAM)', 34999.00, '8 GB RAM | 128 GB ROM\r\n15.49 cm (6.1 inch) Full HD+ Display\r\n64MP + 13MP | 13MP Front Camera\r\n4404 mAh Battery\r\nTensor G3 Processor', '/uploads/1739973340516.jpg', 'Phone World', NULL, 5, 130),
(15, 'vivo T3 Ultra (Frost Green, 128 GB)  (8 GB RAM)', 29999.00, '8 GB RAM | 128 GB ROM\r\n17.22 cm (6.78 inch) Display\r\n50MP + 8MP | 50MP Front Camera\r\n5500 mAh Battery\r\nDimensity 9200+ Processor', '/uploads/1739973636888.jpg', 'Phone World', NULL, 5, 310),
(16, 'Apple iPhone 13 Pro (256GB, Sierra Blue)', 90000.00, 'Display: 6.1 inches, 120Hz Refresh Rate\r\nMemory: 256GB ROM\r\nProcessor: Apple A15 Bionic\r\nCamera: 12MP + 12MP + 12MP & 12MP Front Camera\r\nBattery: 20W Fast Charging\r\n', '/uploads/1739973730191.jpg', 'Phone World', NULL, 5, 110),
(17, 'Apple iPhone 14 Pro (128GB, Deep Purple)', 99999.00, 'Display: 6.1 inches OLED Display\r\nMemory: 128GB ROM\r\nProcessor: A16 Bionic Chip\r\nCamera: 48MP + 12MP + 12MP & 12 MP Front Camer\r\nBattery: Qi Wireless Charging Up to 7.5W\r\n', '/uploads/1739973790891.jpg', 'Phone World', NULL, 5, 121),
(19, 'Apple iPhone 16 Pro (1TB, Black Titanium)', 160999.00, 'Display: 6.3 inches, Super Retina XDR Display, 120Hz Refresh Rate\r\nProcessor: Apple A18 Pro Chip\r\nCamera: 48MP+48MP+12MP & 12MP Front Camera\r\nBattery: 25W MagSafe Wireless Charging\r\n', '/uploads/1739973919846.jpg', 'Phone World', NULL, 5, 189),
(26, 'Apple iPhone 15 Pro (128GB, Natural Titanium)', 110000.00, 'Display: 6.1 inches and Super Retina XDR Display, 120Hz Refresh Rate\r\nMemory: 128GB ROM\r\nProcessor: Apple A17 Pro Chip\r\nCamera: 48MP + 12MP + 12MP & 12MP Front Camera\r\nBattery: 15W MagSafe Wireless Charging\r\n', '/uploads/1739977784050.jpg', 'Phone World', NULL, 5, 123);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cart_item` (`user_id`,`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1013;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
