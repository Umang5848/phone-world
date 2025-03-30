-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: sql12.freesqldatabase.com
-- Generation Time: Mar 30, 2025 at 03:42 AM
-- Server version: 5.5.62-0ubuntu0.14.04.1
-- PHP Version: 7.0.33-0ubuntu0.16.04.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sql12768683`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  `created_at` timestamp NULL DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `username`, `total_amount`, `status`, `payment_method`, `transaction_id`, `created_at`, `order_date`) VALUES
(17, 26, 'um', '51999.00', 'verified', 'upi', '122334455667', '2025-02-28 04:08:58', '2025-03-06 17:57:12'),
(18, 26, 'um', '51999.00', 'pending', 'upi', 'NOT NEEDED', '2025-02-28 04:23:46', '2025-03-06 17:57:12'),
(19, 26, 'um', '51999.00', 'verified', 'upi', '111111111111', '2025-03-01 16:24:44', '2025-03-06 17:57:12'),
(20, 26, 'um', '51999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:26:57', '2025-03-06 17:57:12'),
(21, 26, 'um', '0.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:27:02', '2025-03-06 17:57:12'),
(22, 26, 'um', '0.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:27:33', '2025-03-06 17:57:12'),
(23, 26, 'um', '64900.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:30:05', '2025-03-06 17:57:12'),
(24, 26, 'um', '51999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:43:56', '2025-03-06 17:57:12'),
(25, 26, 'um', '51999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:44:59', '2025-03-06 17:57:12'),
(26, 26, 'um', '51999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-01 16:46:10', '2025-03-06 17:57:12'),
(27, 26, 'um', '64900.00', 'verified', 'cod', 'NOT NEEDED', '2025-03-01 16:54:21', '2025-03-06 17:57:12'),
(28, 26, 'um', '20999.00', 'verified', 'cod', 'NOT NEEDED', '2025-03-01 16:59:50', '2025-03-06 17:57:12'),
(29, 26, 'um', '20999.00', 'verified', 'upi', '1223344556566', '2025-03-02 06:11:28', '2025-03-06 17:57:12'),
(30, 26, 'um', '64900.00', 'verified', 'upi', 'ERTYAQRTGAWEG', '2025-03-02 06:12:24', '2025-03-06 17:57:12'),
(31, 26, 'um', '99999.00', 'verified', 'upi', '111111111111', '2025-03-02 06:21:01', '2025-03-06 17:57:12'),
(32, 26, 'um', '64900.00', 'verified', 'upi', 'Ehehegegeg', '2025-03-02 06:33:57', '2025-03-06 17:57:12'),
(33, 26, 'um', '129800.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-06 15:03:06', '2025-03-06 17:57:12'),
(34, 26, 'um', '51999.00', 'verified', 'upi', '1122334455', '2025-03-06 17:35:47', '2025-03-06 17:57:12'),
(35, 26, 'um', '13.00', 'verified', 'upi', '1234567878', '2025-03-06 19:07:47', '2025-03-06 19:07:47'),
(36, 26, 'um', '64900.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 04:20:16', '2025-03-07 04:20:16'),
(37, 26, 'um', '34999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 18:19:01', '2025-03-07 18:19:01'),
(38, 26, 'um', '20999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 18:24:08', '2025-03-07 18:24:08'),
(39, 26, 'um', '69999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 18:25:07', '2025-03-07 18:25:07'),
(40, 26, 'um', '64900.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 18:28:59', '2025-03-07 18:28:59'),
(41, 26, 'um', '64900.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 18:46:58', '2025-03-07 18:46:58'),
(42, 26, 'um', '64900.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 18:57:10', '2025-03-07 18:57:10'),
(43, 26, 'um', '64900.00', 'verified', 'upi', 'SDAASDASDSCs', '2025-03-07 19:37:58', '2025-03-07 19:37:58'),
(44, 26, 'um', '64900.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-07 20:45:06', '2025-03-07 20:45:06'),
(45, 42, 'um', '64900.00', 'verified', 'upi', '1231323123', '2025-03-07 21:01:03', '2025-03-07 21:01:03'),
(46, 43, 'user1', '64900.00', 'verified', 'upi', '12121212121', '2025-03-08 04:51:20', '2025-03-08 04:51:20'),
(47, 43, 'user1', '20999.00', 'verified', 'cod', 'NOT NEEDED', '2025-03-08 04:54:14', '2025-03-08 04:54:14'),
(48, 42, 'um', '64900.00', 'pending_verification', 'upi', '12', '2025-03-09 17:31:19', '2025-03-09 17:31:19'),
(49, 42, 'um', '34999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-09 18:07:01', '2025-03-09 18:07:01'),
(50, 42, 'um', '20999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-12 05:29:48', '2025-03-12 05:29:48'),
(51, 45, 'tirth', '321998.00', 'verified', 'upi', '656346456456', '2025-03-12 14:36:31', '2025-03-12 14:36:31'),
(52, 42, 'um', '368898.00', 'pending_verification', 'upi', '423423424', '2025-03-20 16:15:42', '0000-00-00 00:00:00'),
(53, 42, 'um', '85899.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-21 11:32:20', '0000-00-00 00:00:00'),
(54, 42, 'um', '20999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-21 11:32:54', '0000-00-00 00:00:00'),
(55, 42, 'um', '20999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-21 11:35:32', '0000-00-00 00:00:00'),
(56, 42, 'um', '20999.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-21 11:37:05', '0000-00-00 00:00:00'),
(57, 47, 'user6', '64900.00', 'pending', 'upi', 'NOT NEEDED', '2025-03-21 11:46:56', '0000-00-00 00:00:00'),
(58, 47, 'user6', '194700.00', 'verified', 'cod', 'NOT NEEDED', '2025-03-21 11:48:35', '0000-00-00 00:00:00'),
(59, 47, 'user6', '87998.00', 'pending_verification', 'upi', 'sadDDASWFASFASDF', '2025-03-21 11:50:56', '0000-00-00 00:00:00'),
(60, 47, 'user6', '20999.00', 'verified', 'upi', '111122121212121', NULL, '2025-03-21 12:07:20'),
(61, 52, 'user6', '64900.00', 'pending_verification', 'upi', '12313412342453565', NULL, '2025-03-21 12:12:22'),
(62, 52, 'user6', '64900.00', 'pending_verification', 'upi', '878', NULL, '2025-03-21 13:16:53'),
(63, 52, 'user6', '69998.00', 'pending', 'upi', 'NOT NEEDED', NULL, '2025-03-21 15:03:39'),
(64, 52, 'user6', '34999.00', 'pending', 'upi', 'NOT NEEDED', NULL, '2025-03-21 15:04:07'),
(65, 52, 'user6', '160999.00', 'pending', 'upi', 'NOT NEEDED', NULL, '2025-03-21 15:06:21'),
(66, 52, 'user6', '52999.00', 'pending', 'upi', 'NOT NEEDED', NULL, '2025-03-21 15:10:04'),
(67, 52, 'user6', '52999.00', 'pending', 'upi', 'NOT NEEDED', NULL, '2025-03-21 15:10:06'),
(68, 52, 'user6', '69999.00', 'pending_verification', 'upi', '23423', NULL, '2025-03-21 15:15:09'),
(69, 52, 'user6', '90000.00', 'pending_verification', 'upi', '324q3242', NULL, '2025-03-21 15:18:47'),
(70, 42, 'um', '29999.00', 'pending', 'upi', 'NOT NEEDED', NULL, '2025-03-22 15:30:23'),
(71, 52, 'user6', '109999.00', 'verified', 'cod', 'NOT NEEDED', NULL, '2025-03-24 04:59:45'),
(72, 52, 'user6', '109999.00', 'verified', 'upi', '345534534535', NULL, '2025-03-24 05:00:55'),
(73, 42, 'um', '64900.00', 'pending_verification', 'upi', '4234234234', NULL, '2025-03-29 15:07:11'),
(74, 42, 'um', '52999.00', 'verified', 'cod', 'NOT NEEDED', NULL, '2025-03-29 15:13:05'),
(75, 42, 'um', '109999.00', 'pending_verification', 'upi', '112121212121', NULL, '2025-03-29 15:13:40'),
(76, 42, 'um', '207899.00', 'pending_verification', 'upi', '1212sdqddsd', NULL, '2025-03-29 15:23:21'),
(77, 42, 'um', '157997.00', 'pending_verification', 'upi', '12ewdcfff', NULL, '2025-03-29 15:32:48'),
(78, 42, 'um', '216997.00', 'pending_verification', 'upi', 'qwewqewqe', NULL, '2025-03-29 15:50:55'),
(79, 42, 'um', '85899.00', 'pending_verification', 'upi', '564645', NULL, '2025-03-29 16:10:03'),
(80, 42, 'um', '20999.00', 'pending_verification', 'upi', 'dfgvzgvzsdfg', NULL, '2025-03-29 16:35:46');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 77, 3, 1, '52999.00'),
(2, 77, 12, 1, '69999.00'),
(3, 77, 13, 1, '34999.00'),
(4, 78, 11, 1, '20999.00'),
(5, 78, 13, 1, '34999.00'),
(6, 78, 19, 1, '160999.00'),
(7, 79, 6, 1, '64900.00'),
(8, 79, 11, 1, '20999.00'),
(9, 80, 11, 1, '20999.00');

-- --------------------------------------------------------

--
-- Table structure for table `otps`
--

CREATE TABLE `otps` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `expires_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `otps`
--

INSERT INTO `otps` (`id`, `email`, `otp`, `expires_at`) VALUES
(1, 'umangp852@gmail.com', '365242', '2025-02-16 16:48:41'),
(2, 'umangp852@gmail.com', '121168', '2025-02-16 17:02:01'),
(3, 'umangp852@gmail.com', '302923', '2025-02-16 17:06:42'),
(4, 'ASDasd@FASDF', '129361', '2025-02-16 17:07:33'),
(5, 'umangp852@gmail.com', '480482', '2025-02-16 17:37:50'),
(6, 'umangp852@gmail.com', '789842', '2025-02-16 17:38:51'),
(7, 'umangp852@gmail.com', '117042', '2025-02-16 17:39:26'),
(8, 'umangpsddfildf@sasfd', '347632', '2025-02-16 17:40:06'),
(22, 'vihoy39229@crodity.com', '369023', '2025-02-19 21:42:21'),
(24, 'sonewasd26882@matmayer.com', '118665', '2025-03-07 10:26:32'),
(25, 'sonewasd26882@matmayer.com', '562358', '2025-03-07 10:26:33'),
(26, 'sonewasd26882@matmayer.com', '431422', '2025-03-07 10:26:33'),
(27, 'sonewasd26882@matmayer.com', '497547', '2025-03-07 10:26:34'),
(28, 'sonewasd26882@matmayer.com', '309457', '2025-03-07 10:26:34'),
(30, 'geferec636xcvsdvv@oziere.com', '807299', '2025-03-08 02:33:18'),
(31, 'geferec636xcvsdvv@oziere.com', '664117', '2025-03-08 02:33:19'),
(32, 'geferec636xcvsdvv@oziere.com', '353836', '2025-03-08 02:33:19'),
(33, 'geferec636xcvsdvv@oziere.com', '356254', '2025-03-08 02:33:19'),
(34, 'geferec636xcvsdvv@oziere.com', '590986', '2025-03-08 02:33:19'),
(35, 'geferec636xcvsdvv@oziere.com', '992830', '2025-03-08 02:33:19'),
(36, 'geferec636xcvsdvv@oziere.com', '352385', '2025-03-08 02:33:20'),
(37, 'vihoy000939229@crodity.com', '316281', '2025-03-08 02:34:05'),
(41, 'umangp852@gmail.com', '675752', '2025-03-08 11:22:47'),
(42, 'umangp852@gmail.com', '428890', '2025-03-08 11:29:11'),
(43, 'Umang2098@gmail.com', '659911', '2025-03-08 11:31:58'),
(44, 'tirth7359@gmail.com', '813790', '2025-03-12 20:09:40');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `specifications` text,
  `image` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT 'Phone World',
  `original_price` decimal(10,2) DEFAULT NULL,
  `rating` int(11) DEFAULT '5',
  `stock` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `specifications`, `image`, `category`, `original_price`, `rating`, `stock`) VALUES
(3, 'Apple iPhone 14 (Blue, 128 GB)', '52999.00', '128 GB ROM\n15.49 cm (6.1 inch) Super Retina XDR Display\n12MP + 12MP Dual Rear Camera\n12MP Front Camera\nA15 Bionic Chip, 6-Core Processor', 'https://i.postimg.cc/sxKRP9Fs/Apple-i-Phone-14-Blue-128-GB.webp', 'Phone World', NULL, 5, 114),
(6, 'Apple iPhone 15 (128GB, Black)', '64900.00', 'Display: 6.1 inches (15.54 cm)\nProcessor: Apple A16 Bionic Chip\nCamera: 48 MP + 12 MP Dual Rear & 12 MP Front Camera\nUSP: Dynamic Island, IP68 Water Resistant', 'https://i.postimg.cc/8kY4cff6/Apple-i-Phone-15-128-GB-Black.webp', 'Phone World', NULL, 5, 104),
(10, 'Apple iPhone 13 (128GB, Blue)', '46400.00', 'Display: 6.1 inches (15.4 cm)\nMemory: 128GB ROM\nProcessor: Apple A15 Bionic Chip, Hexa Core\nCamera: 12 MP + 12 MP Dual Rear \nBattery: 3240 mAh \nIP68 Water Resistant', 'https://i.postimg.cc/Wz9J0XBm/Apple-i-Phone-13.jpg', 'Phone World', NULL, 5, 123),
(11, 'Infinix GT 20 Pro', '20999.00', '8 GB RAM | 256 GB ROM\r\n17.22 cm (6.78 inch) Full HD+ Display\r\n108MP (OIS) + 2MP + 2MP | 32MP Front Camera\r\n5000 mAh Battery\r\nDimensity 8200 Ultimate Processor', 'https://i.postimg.cc/13K1B2CZ/Infinix-GT-20-Pro-Mecha-Blue-256-GB-8-GB-RAM.webp', 'Phone World', NULL, 5, 87),
(12, 'Apple iPhone 16 (128GB Storage, Teal)', '69999.00', 'iOS 18 Operating System\nA18 chip with 5-core GPU\n6.1-inch OLED display \n48MP Main + 12MP Camera\n12 MP Front Camera\nIP68 Splash and Water Resistant', ' https://i.postimg.cc/NfMXQvXd/Apple-i-Phone-16-128-GB-Storage-Teal.jpg', 'Phone World', NULL, 5, 131),
(13, 'Google Pixel 8a (Aloe, 128 GB)  (8 GB RAM)', '34999.00', '8 GB RAM | 128 GB ROM\n15.49 cm (6.1 inch) Full HD+ Display\n64MP + 13MP | 13MP Front Camera\n4404 mAh Battery\nTensor G3 Processor', 'https://i.postimg.cc/L611JByP/Google-Pixel-8a-Bay-128-GB-8-GB-RAM.webp', 'Phone World', NULL, 5, 122),
(15, 'vivo T3 Ultra (Frost Green, 128 GB)  (8 GB RAM)', '29999.00', '8 GB RAM | 128 GB ROM\n17.22 cm (6.78 inch) Display\n50MP + 8MP | 50MP Front Camera\n5500 mAh Battery\nDimensity 9200+ Processor', 'https://i.postimg.cc/cCNrYPk8/vivo-T3-Ultra-Frost-Green-128-GB-8-GB-RAM.jpg', 'Phone World', NULL, 5, 309),
(16, 'Apple iPhone 13 Pro (256GB, Sierra Blue)', '90000.00', 'Display: 6.1 inches, 120Hz Refresh Rate\nMemory: 256GB ROM\nProcessor: Apple A15 Bionic\nCamera: 12MP + 12MP + 12MP & 12MP Front Camera\nBattery: 20W Fast Charging\n', 'https://i.postimg.cc/htQzZr8P/Apple-i-Phone-13-Pro-256-GB-Sierra-Blue.jpg', 'Phone World', NULL, 5, 107),
(17, 'Apple iPhone 14 Pro (128GB, Deep Purple)', '99999.00', 'Display: 6.1 inches OLED Display\nMemory: 128GB ROM\nProcessor: A16 Bionic Chip\nCamera: 48MP + 12MP + 12MP & 12 MP Front Camer\nBattery: Qi Wireless Charging Up to 7.5W\n', 'https://i.postimg.cc/B6Sv3cFF/Apple-i-Phone-14-Pro-128-GB-Deep-Purple.jpg', 'Phone World', NULL, 5, 121),
(19, 'Apple iPhone 16 Pro (1TB, Black Titanium)', '160999.00', 'Display: 6.3 inches, Super Retina XDR Display, 120Hz Refresh Rate\nProcessor: Apple A18 Pro Chip\nCamera: 48MP+48MP+12MP & 12MP Front Camera\nBattery: 25W MagSafe Wireless Charging\n', 'https://i.postimg.cc/ZKTXLsSp/Apple-i-Phone-16-Pro-1-TB-Black-Titanium.jpg', 'Phone World', NULL, 5, 184),
(35, 'Xiaomi Black Shark 4', '29999.00', 'Performance: Octa core Snapdragon 870, 6 GB RAM\r\nDisplay: 6.67 inches FHD+, Super AMOLED144 Hz Refresh Rate\r\nCamera: 48MP + 8MP + 5MP CamerasLED Flash20 MP Front Camera\r\nBattery: 4500 mAhFast ChargingUSB Type-C Port', 'https://i.postimg.cc/2yBy9jv9/Black-Shark-4.jpg', 'Phone World', NULL, 5, 212),
(36, ' Xiaomi Black Shark 4S Pro', '49999.00', 'Performance: Octa core Snapdragon 888 Plus12 GB RAM\r\nDisplay: 6.67 inches (16.94 cm)FHD+, Super AMOLED144 Hz Refresh Rate\r\nCamera: 64MP + 8MP + 5MP CamerasLED Flash20 MP Front Camera\r\nBattery: 4500 mAhFast ChargingUSB Type-C Port', 'https://i.postimg.cc/MTJtsHhX/Black-Shark-4-S-Pro.jpg', 'Phone World', NULL, 5, 125),
(37, 'Xiaomi Black Shark 5', '45000.00', 'Performance: Octa core Snapdragon 870 8GB RAM\nDisplay: 6.67inches FHD+, AMOLED144 Hz Refresh Rate\nCamera: 64MP + 13MP + 2MP CamerasLED Flash16 MP Front Camera\nBattery: 4650 mAhFast ChargingUSB Type-C Port', 'https://i.postimg.cc/kGz2c6pp/Black-Shark-5.jpg', 'Phone World', NULL, 5, 238),
(38, 'Xiaomi Black Shark 5 Pro', '51999.00', 'Performance: Octa core Snapdragon 8 Gen 18 GB RAM\r\nDisplay: 6.67 inches FHD+, AMOLED144 Hz Refresh Rate\r\nCamera: 108MP + 13MP + 5MP CamerasLED Flash16MP Front Camera\r\nBattery: 4650 mAhFast ChargingUSB Type-C Port', 'https://i.postimg.cc/F1X9zjqN/Xiaomi-Black-Shark-5-Pro.jpg', 'Phone World', NULL, 5, 256),
(39, 'Apple iPhone 15 Pro (128GB, Natural Titanium)', '110000.00', 'Display: 6.1 inches and Super Retina XDR Display, 120Hz Refresh Rate\r\nMemory: 128GB ROM\r\nProcessor: Apple A17 Pro Chip\r\nCamera: 48MP + 12MP + 12MP & 12MP Front Camera\r\nBattery: 15W MagSafe Wireless Charging', 'https://i.postimg.cc/bwY8sNrX/Apple-i-Phone-15-Pro-128-GB-Natural-Titanium.jpg', 'Phone World', NULL, 5, 149),
(40, 'Google Pixel 9 Pro', '109999.00', 'Display: 6.3 inches, LTPO OLED\r\nMemory: 16GB RAM, 256GB ROM\r\nProcessor: Google Tensor G4, Octa Core\r\nCamera: 50MP + 48MP + 48MP Triple Rear & 42MP Front Camera\r\nBattery: 4700 mAh with 45W Fast Charging\r\nUSP: Multi-layer Hardware Security, Gemini Built-in AI Assistant, IP68 Dust & Water Resistant', 'https://i.postimg.cc/zvhtz7X7/Google-Pixel-9-Pro-5-G-16-GB-RAM-256-GB-Hazel.jpg', 'Phone World', NULL, 5, 229),
(41, 'Vivo X200 Pro 5G (Cosmos Black)', '94999.00', 'Display: 6.78 inches, AMOLED, 12Hz Refresh Rate\nMemory: 16GB RAM, 512GB ROM\nProcessor: MediaTek Dimensity 9400, Octa Core, 3.626 GHz\nCamera: 200MP + 50MP + 50MP Triple Rear & 32MP Front Camera\nBattery: 6000mAh with 90W FlashCharge\nUSP: Circle to Search with Google, 3D Ultrasonic Single-point Fingerprint Sensor, Enable AI Call Translation', 'https://i.postimg.cc/V63yW4GQ/vivo-X200-Pro-5-G-16-GB-RAM-512-GB-Titanium-Gray.jpg', 'Phone World', NULL, 5, 231);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`) VALUES
(42, 'um', '12', 'geferec636@oziere.com'),
(43, 'user1', '12', 'lamisin901@oziere.com'),
(44, 'Umang1', '12', 'up223158@gmail.com'),
(45, 'tirth', '12', 'tirth735969@gmail.com'),
(46, 'user5', '12', 'vosijav213@excederm.com'),
(52, 'user6', '12', 'yipeve2191@hikuhu.com');

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
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `otps`
--
ALTER TABLE `otps`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1119;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;
--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;
--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
