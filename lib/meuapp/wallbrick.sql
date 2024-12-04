-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 04, 2024 at 01:37 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wallbrick`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_cliente`
--

CREATE TABLE `tbl_cliente` (
  `CLI_INT_CPF` int(11) NOT NULL,
  `CLI_VAR_NOME` varchar(10) DEFAULT NULL,
  `CLI_VAR_FONE` varchar(10) DEFAULT NULL,
  `USU_INT_COD_CAD` int(11) DEFAULT NULL,
  `CLI_DTCAD` timestamp NOT NULL DEFAULT current_timestamp(),
  `CLI_DTALT` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_INT_COD_ALT` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_fabricante`
--

CREATE TABLE `tbl_fabricante` (
  `FBR_VAR_CNPJ` varchar(30) NOT NULL,
  `FBR_VAR_NOME` varchar(75) DEFAULT NULL,
  `FBR_VAR_FONE` varchar(20) DEFAULT NULL,
  `FBR_CHAR_ATIVO` varchar(10) DEFAULT NULL,
  `FBR_DTCAD` timestamp NOT NULL DEFAULT current_timestamp(),
  `FBR_DTALT` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_INT_COD_CAD` int(11) DEFAULT NULL,
  `USU_INT_COD_ALT` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_fabricante`
--

INSERT INTO `tbl_fabricante` (`FBR_VAR_CNPJ`, `FBR_VAR_NOME`, `FBR_VAR_FONE`, `FBR_CHAR_ATIVO`, `FBR_DTCAD`, `FBR_DTALT`, `USU_INT_COD_CAD`, `USU_INT_COD_ALT`) VALUES
('2', 'oba', '121212', NULL, '2024-12-04 01:17:55', '2024-12-04 01:17:55', NULL, NULL),
('333333', 'MCDONALDS', '129964', NULL, '2024-12-03 23:57:01', '2024-12-03 23:57:01', NULL, NULL),
('555555555555', 'hhhhhhhhhhhhhhhhh', '534534', NULL, '2024-12-04 01:06:28', '2024-12-04 01:06:28', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produto`
--

CREATE TABLE `tbl_produto` (
  `PRO_INT_COD` int(11) NOT NULL,
  `PRO_VAR_NOME` varchar(50) DEFAULT NULL,
  `PRO_INT_QUANTIDADE` int(11) NOT NULL,
  `PRO_VAR_MEDIDA` varchar(50) NOT NULL,
  `PRO_DEC_PRECO` decimal(10,2) DEFAULT NULL,
  `PRO_DTCAD` timestamp NOT NULL DEFAULT current_timestamp(),
  `PRO_DTALT` timestamp NOT NULL DEFAULT current_timestamp(),
  `FBR_VAR_CNPJ` varchar(30) NOT NULL,
  `USU_INT_COD_CAD` int(11) DEFAULT NULL,
  `USU_INT_COD_ALT` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_produto`
--

INSERT INTO `tbl_produto` (`PRO_INT_COD`, `PRO_VAR_NOME`, `PRO_INT_QUANTIDADE`, `PRO_VAR_MEDIDA`, `PRO_DEC_PRECO`, `PRO_DTCAD`, `PRO_DTALT`, `FBR_VAR_CNPJ`, `USU_INT_COD_CAD`, `USU_INT_COD_ALT`) VALUES
(17, 'aa', 1, 'a', 11.00, '2024-12-03 20:40:50', '2024-12-03 20:40:50', '', NULL, NULL),
(22, 'aaaaaaa', 1, 'a', 1.00, '2024-12-04 01:18:11', '2024-12-04 01:18:11', '2', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_usuario`
--

CREATE TABLE `tbl_usuario` (
  `USU_VAR_SENHA` varchar(100) DEFAULT NULL,
  `USU_TIM_CAD` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_TIM_DTALT` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_VAR_NOME` varchar(10) DEFAULT NULL,
  `USU_VAR_NIVEL` varchar(10) DEFAULT NULL,
  `USU_INT_COD` int(11) NOT NULL,
  `USU_INT_COD_CAD` int(11) DEFAULT NULL,
  `USU_INT_COD_ALT` int(11) DEFAULT NULL,
  `USU_VAR_EMAIL` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_usuario`
--

INSERT INTO `tbl_usuario` (`USU_VAR_SENHA`, `USU_TIM_CAD`, `USU_TIM_DTALT`, `USU_VAR_NOME`, `USU_VAR_NIVEL`, `USU_INT_COD`, `USU_INT_COD_CAD`, `USU_INT_COD_ALT`, `USU_VAR_EMAIL`) VALUES
('$2y$10$I5H', '2024-12-02 22:39:57', '2024-12-02 22:39:57', 'a', 'a', 1, NULL, NULL, ''),
('$2y$10$yBs', '2024-12-02 22:47:43', '2024-12-02 22:47:43', 'a', 'a', 2, NULL, NULL, ''),
('$2y$10$FyJ', '2024-12-02 22:47:45', '2024-12-02 22:47:45', 'aw', 'a', 3, NULL, NULL, ''),
('$2y$10$uNV', '2024-12-02 22:47:48', '2024-12-02 22:47:48', 'aw', 'a', 4, NULL, NULL, ''),
('$2y$10$A7z', '2024-12-02 22:48:51', '2024-12-02 22:48:51', 'awww', 'a', 5, NULL, NULL, ''),
('$2y$10$N8/', '2024-12-02 22:52:48', '2024-12-02 22:52:48', 'awww', 'a', 6, NULL, NULL, ''),
('$2y$10$fUF', '2024-12-02 23:09:29', '2024-12-02 23:09:29', 'w', 'w', 7, NULL, NULL, ''),
('$2y$10$OVb', '2024-12-02 23:09:32', '2024-12-02 23:09:32', 'w', 'w', 8, NULL, NULL, ''),
('$2y$10$NB.', '2024-12-03 00:18:50', '2024-12-03 00:18:50', 'Nicolas', NULL, 9, NULL, NULL, 'nicolas@gmail.com'),
('$2y$10$miL', '2024-12-03 00:20:52', '2024-12-03 00:20:52', 'ss', NULL, 10, NULL, NULL, 's@gmail.com'),
('$2y$10$nar', '2024-12-03 00:23:10', '2024-12-03 00:23:10', 'a', NULL, 11, NULL, NULL, 'a'),
('$2y$10$186to89zAKYuQJkNjmPmmeNkhZjdW8ATCEPKxzA9dmQuihgjJbje6', '2024-12-03 00:28:10', '2024-12-03 00:28:10', 'Zezao', NULL, 12, NULL, NULL, 'z'),
('$2y$10$I6JXkwfKZQXlqiH15bPlfeZyxbA56BIRWEupQ8MHrMvE4g4vh/bJS', '2024-12-03 11:59:14', '2024-12-03 11:59:14', 'n', NULL, 13, NULL, NULL, 'n'),
('$2y$10$XUvXjHL2reRnqShbE/OHVeTQqEYkvhbMR1Y0M50n5PMZ6aTWgSB9W', '2024-12-03 12:32:15', '2024-12-03 12:32:15', 'a', NULL, 14, NULL, NULL, 'w'),
('$2y$10$KVNgBjDun6FUwPuwEfD3v.4OjT1RIS1EsYF7PsBsdJo7DNRR9GcDu', '2024-12-03 12:35:13', '2024-12-03 12:35:13', 'a', NULL, 15, NULL, NULL, 'a'),
('$2y$10$D5vXIgY/R1l8ev56km.Pm.prQjI40FQ8WM8o49oh7yW1muS2U8GKu', '2024-12-03 12:51:02', '2024-12-03 12:51:02', 'Nicolas', NULL, 16, NULL, NULL, 'nicolas'),
('$2y$10$lce1BR5ZviTRxVT2RNfgnu6hQ8BPNmmEsMb10l0f4khP75SY7eh8u', '2024-12-03 12:59:03', '2024-12-03 12:59:03', 'Sara', NULL, 17, NULL, NULL, 'sara@gmail.com'),
('$2y$10$QyXQ8wy6MHYAK/oJ96tJZufc6CqfAK1pvABca4659bxwLJJN1fZXu', '2024-12-03 16:17:16', '2024-12-03 16:17:16', 'Nicolas', NULL, 19, NULL, NULL, 'nicolasgmack@gmail.com'),
('$2y$10$S5f8drTm279mEGDxHSilIeYo4SLIANTDdvNC0oPr7f6phh3Z4TD8y', '2024-12-03 18:43:26', '2024-12-03 18:43:26', 'Nick', NULL, 20, NULL, NULL, 'nick@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_cliente`
--
ALTER TABLE `tbl_cliente`
  ADD PRIMARY KEY (`CLI_INT_CPF`),
  ADD KEY `USU_INT_COD_CAD` (`USU_INT_COD_CAD`),
  ADD KEY `USU_INT_COD_ALT` (`USU_INT_COD_ALT`);

--
-- Indexes for table `tbl_fabricante`
--
ALTER TABLE `tbl_fabricante`
  ADD PRIMARY KEY (`FBR_VAR_CNPJ`),
  ADD KEY `USU_INT_COD_CAD` (`USU_INT_COD_CAD`),
  ADD KEY `USU_INT_COD_ALT` (`USU_INT_COD_ALT`);

--
-- Indexes for table `tbl_produto`
--
ALTER TABLE `tbl_produto`
  ADD PRIMARY KEY (`PRO_INT_COD`),
  ADD KEY `FBR_INT_CNPJ` (`FBR_VAR_CNPJ`),
  ADD KEY `USU_INT_COD_CAD` (`USU_INT_COD_CAD`),
  ADD KEY `USU_INT_COD_ALT` (`USU_INT_COD_ALT`);

--
-- Indexes for table `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD PRIMARY KEY (`USU_INT_COD`),
  ADD KEY `USU_INT_COD_CAD` (`USU_INT_COD_CAD`),
  ADD KEY `USU_INT_COD_ALT` (`USU_INT_COD_ALT`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_produto`
--
ALTER TABLE `tbl_produto`
  MODIFY `PRO_INT_COD` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  MODIFY `USU_INT_COD` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_produto`
--
ALTER TABLE `tbl_produto`
  ADD CONSTRAINT `tbl_produto_ibfk_1` FOREIGN KEY (`FBR_VAR_CNPJ`) REFERENCES `tbl_fabricante` (`FBR_VAR_CNPJ`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD CONSTRAINT `tbl_usuario_ibfk_1` FOREIGN KEY (`USU_INT_COD_ALT`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
