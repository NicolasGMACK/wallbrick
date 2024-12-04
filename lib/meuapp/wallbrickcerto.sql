-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 04, 2024 at 02:01 PM
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
  `CLI_INT_ID` int(11) NOT NULL,
  `CLI_VAR_NOME` varchar(50) NOT NULL,
  `CLI_VAR_EMAIL` varchar(60) NOT NULL,
  `CLI_VAR_SENHA` varchar(255) NOT NULL,
  `USU_INT_COD_CAD` int(11) DEFAULT NULL,
  `CLI_DTCAD` timestamp NOT NULL DEFAULT current_timestamp(),
  `CLI_DTALT` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_INT_COD_ALT` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_cliente`
--

INSERT INTO `tbl_cliente` (`CLI_INT_ID`, `CLI_VAR_NOME`, `CLI_VAR_EMAIL`, `CLI_VAR_SENHA`, `USU_INT_COD_CAD`, `CLI_DTCAD`, `CLI_DTALT`, `USU_INT_COD_ALT`) VALUES
(2, 'Nicolas', 'nicolas@gmail.com', '$2y$10$8RaAFc6mIE7nvgzeHEbWOeW.X8KSRJ1gG2XZtP7VPwL4N0VuBq9Jq', NULL, '2024-12-04 12:53:38', '2024-12-04 12:53:38', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_fabricante`
--

CREATE TABLE `tbl_fabricante` (
  `FBR_VAR_CNPJ` varchar(30) NOT NULL,
  `FBR_VAR_NOME` varchar(50) DEFAULT NULL,
  `FBR_VAR_FONE` varchar(20) DEFAULT NULL,
  `FBR_CHAR_ATIVO` char(2) DEFAULT NULL,
  `FBR_DTCAD` timestamp NOT NULL DEFAULT current_timestamp(),
  `FBR_DTALT` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_INT_COD_CAD` int(11) DEFAULT NULL,
  `USU_INT_COD_ALT` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_fabricante`
--

INSERT INTO `tbl_fabricante` (`FBR_VAR_CNPJ`, `FBR_VAR_NOME`, `FBR_VAR_FONE`, `FBR_CHAR_ATIVO`, `FBR_DTCAD`, `FBR_DTALT`, `USU_INT_COD_CAD`, `USU_INT_COD_ALT`) VALUES
('42.591.651/0001-43', 'McDonalds', '0800 888 1955', NULL, '2024-12-04 12:54:59', '2024-12-04 12:54:59', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produto`
--

CREATE TABLE `tbl_produto` (
  `PRO_INT_COD` int(11) NOT NULL,
  `PRO_VAR_NOME` varchar(50) NOT NULL,
  `PRO_INT_QUANTIDADE` int(11) NOT NULL,
  `PRO_VAR_MEDIDA` varchar(20) NOT NULL,
  `PRO_DEC_PRECO` decimal(10,2) NOT NULL,
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
(1, 'Hambúrguer do Sirí (Edição Especial)', 45, 'unidades', 60.00, '2024-12-04 12:55:30', '2024-12-04 12:55:30', '42.591.651/0001-43', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_usuario`
--

CREATE TABLE `tbl_usuario` (
  `USU_VAR_SENHA` varchar(10) DEFAULT NULL,
  `USU_TIM_CAD` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_TIM_DTALT` timestamp NOT NULL DEFAULT current_timestamp(),
  `USU_VAR_NOME` varchar(10) DEFAULT NULL,
  `USU_VAR_ATIVO` char(2) DEFAULT NULL,
  `USU_INT_COD` int(11) NOT NULL,
  `USU_INT_COD_CAD` int(11) DEFAULT NULL,
  `USU_INT_COD_ALT` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_cliente`
--
ALTER TABLE `tbl_cliente`
  ADD PRIMARY KEY (`CLI_INT_ID`),
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
  ADD KEY `USU_INT_COD_CAD` (`USU_INT_COD_CAD`),
  ADD KEY `USU_INT_COD_ALT` (`USU_INT_COD_ALT`),
  ADD KEY `tbl_produto_ibfk_1` (`FBR_VAR_CNPJ`);

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
-- AUTO_INCREMENT for table `tbl_cliente`
--
ALTER TABLE `tbl_cliente`
  MODIFY `CLI_INT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_produto`
--
ALTER TABLE `tbl_produto`
  MODIFY `PRO_INT_COD` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_cliente`
--
ALTER TABLE `tbl_cliente`
  ADD CONSTRAINT `tbl_cliente_ibfk_1` FOREIGN KEY (`USU_INT_COD_CAD`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_cliente_ibfk_2` FOREIGN KEY (`USU_INT_COD_ALT`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_fabricante`
--
ALTER TABLE `tbl_fabricante`
  ADD CONSTRAINT `tbl_fabricante_ibfk_1` FOREIGN KEY (`USU_INT_COD_CAD`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_fabricante_ibfk_2` FOREIGN KEY (`USU_INT_COD_ALT`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_produto`
--
ALTER TABLE `tbl_produto`
  ADD CONSTRAINT `tbl_produto_ibfk_1` FOREIGN KEY (`FBR_VAR_CNPJ`) REFERENCES `tbl_fabricante` (`FBR_VAR_CNPJ`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_produto_ibfk_2` FOREIGN KEY (`USU_INT_COD_CAD`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_produto_ibfk_3` FOREIGN KEY (`USU_INT_COD_ALT`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD CONSTRAINT `tbl_usuario_ibfk_1` FOREIGN KEY (`USU_INT_COD_CAD`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_usuario_ibfk_2` FOREIGN KEY (`USU_INT_COD_ALT`) REFERENCES `tbl_usuario` (`USU_INT_COD`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
