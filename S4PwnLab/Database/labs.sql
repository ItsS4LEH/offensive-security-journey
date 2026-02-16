-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 16, 2026 at 08:47 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `labs`
--
CREATE DATABASE IF NOT EXISTS `labs` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `labs`;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `phone`, `password`, `role`) VALUES
(1, 'Admin', 'admin@test.com', '+1000000001', 'admin123', 'admin'),
(2, 'SuperAdmin', 'superadmin@test.com', '+1000000002', 'super123', 'admin'),
(3, 'Omar', 'omar.admin@test.com', '+1000000003', 'Omar2026!', 'admin'),
(4, 'Sara', 'sara.admin@test.com', '+1000000004', 'iloveyou', 'admin'),
(5, 'Michael', 'michael.admin@test.com', '+1000000005', 'qwerty', 'admin'),
(6, 'Emily', 'Emily.admin@test.com', '+1000000006', 'abc123', 'admin'),
(7, 'Ahmed', 'ahmed@test.com', '+1000000007', '123456', 'user'),
(8, 'Noura', 'noura@test.com', '+1000000008', '111111', 'user'),
(9, 'Khaled', 'khaled@test.com', '+1000000009', '123123', 'user'),
(10, 'Aisha', 'aisha@test.com', '+1000000010', 'welcome', 'user'),
(11, 'Ali', 'oali@test.com', '+1000000011', 'OmarAli123', 'user'),
(12, 'Lina', 'lina@test.com', '+1000000012', '000000', 'user'),
(13, 'John', 'john@test.com', '+1000000013', 'pass123', 'user'),
(14, 'Ella', 'Ella@test.com', '+1000000014', 'password', 'user'),
(15, 'Daniel', 'daniel@test.com', '+1000000015', 'password1', 'user'),
(16, 'Charlotte', 'charlotte@test.com', '+1000000016', '12345678', 'user'),
(17, 'Ethan', 'ethan@test.com', '+1000000017', 'qwerty123', 'user'),
(18, 'Hassan', 'hassan@test.com', '+1000000018', 'abc12345', 'user'),
(19, 'Mariam', 'mariam@test.com', '+1000000019', '123qwe', 'user'),
(20, 'Isabella', 'isabella@test.com', '+1000000020', 'admin1', 'user');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
