-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 06-11-2020 a las 01:19:05
-- Versión del servidor: 5.6.41-84.1
-- Versión de PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ramseifw_miloficios`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id` int(11) NOT NULL,
  `idClienteUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id`, `idClienteUsuario`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 7),
(7, 9),
(8, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favorito`
--

CREATE TABLE `favorito` (
  `id` int(11) NOT NULL,
  `idUsuarioFav` int(11) NOT NULL,
  `idServicioFav` int(11) NOT NULL,
  `idServicioProfesionalFav` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `favorito`
--

INSERT INTO `favorito` (`id`, `idUsuarioFav`, `idServicioFav`, `idServicioProfesionalFav`) VALUES
(1, 6, 1, 1),
(6, 1, 1, 1),
(7, 5, 2, 2),
(8, 5, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesional`
--

CREATE TABLE `profesional` (
  `id` int(11) NOT NULL,
  `puntuacion` int(11) NOT NULL DEFAULT '0',
  `recibo` text COLLATE utf8_unicode_ci NOT NULL,
  `dni` text COLLATE utf8_unicode_ci NOT NULL,
  `verificado` int(11) NOT NULL DEFAULT '0',
  `cuentaBancaria` text COLLATE utf8_unicode_ci NOT NULL,
  `online` text COLLATE utf8_unicode_ci NOT NULL,
  `idProfesionalUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `profesional`
--

INSERT INTO `profesional` (`id`, `puntuacion`, `recibo`, `dni`, `verificado`, `cuentaBancaria`, `online`, `idProfesionalUsuario`) VALUES
(1, 0, 'archivos/SIS-201-G1 AVANCE.pdf', 'archivos/1604081858.pdf', 1, '123456789102', 'SI', 6),
(2, 0, 'archivos/1604104624.pdf', 'archivos/1604104631.pdf', 1, '0', 'NO', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `id` int(11) NOT NULL,
  `categoria` text COLLATE utf8_unicode_ci NOT NULL,
  `subcategoria` text COLLATE utf8_unicode_ci NOT NULL,
  `direccion` text COLLATE utf8_unicode_ci NOT NULL,
  `opcionA` text COLLATE utf8_unicode_ci NOT NULL,
  `opcionB` text COLLATE utf8_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8_unicode_ci NOT NULL,
  `precio` text COLLATE utf8_unicode_ci NOT NULL,
  `cantidad` text COLLATE utf8_unicode_ci NOT NULL,
  `porcentaje` text COLLATE utf8_unicode_ci NOT NULL,
  `fechaCad` text COLLATE utf8_unicode_ci NOT NULL,
  `archivo` text COLLATE utf8_unicode_ci NOT NULL,
  `certificado` int(11) NOT NULL DEFAULT '0',
  `galeria1` text COLLATE utf8_unicode_ci NOT NULL,
  `galeria2` text COLLATE utf8_unicode_ci NOT NULL,
  `galeria3` text COLLATE utf8_unicode_ci NOT NULL,
  `recomendar` text COLLATE utf8_unicode_ci NOT NULL,
  `fechaInicio` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaFin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `latitud` text COLLATE utf8_unicode_ci NOT NULL,
  `longitud` text COLLATE utf8_unicode_ci NOT NULL,
  `dias` text COLLATE utf8_unicode_ci NOT NULL,
  `horario` text COLLATE utf8_unicode_ci NOT NULL,
  `idServicioProfesional` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `servicio`
--

INSERT INTO `servicio` (`id`, `categoria`, `subcategoria`, `direccion`, `opcionA`, `opcionB`, `descripcion`, `precio`, `cantidad`, `porcentaje`, `fechaCad`, `archivo`, `certificado`, `galeria1`, `galeria2`, `galeria3`, `recomendar`, `fechaInicio`, `fechaFin`, `latitud`, `longitud`, `dias`, `horario`, `idServicioProfesional`) VALUES
(1, 'CLASES PARTICULARES', 'Matematica', 'chorrillos', '0', 'En mi domicilio', 'clases particulares en domicilio, docente con experiencia en el campo laboral de las matemáticas con años de experiencia', '80', '0', '15', '2020-11-17 00:00:00.000', '', 0, '0', '0', '0', '0', '2020-10-30 06:54:02', '2020-10-30 06:54:02', '-12.195126153097762', '-77.001144066453', '0', '0', 1),
(2, 'TECNOLOGIA', 'Técnico en computación', 'al costado de óvalo granda', 'Voy a domicilio', '0', 'Soy técnico con experiencia', '50', '0', '15', '2020-11-16 00:00:00.000', 'certificadoServicio/1604105634.docx', 0, 'galeria/image_picker5696854488641527466.jpg', '0', '0', '0', '2020-10-31 00:44:22', '2020-10-31 00:44:22', '-12.05148871110743', '-77.03551791608334', '0', '0', 2),
(3, 'TECNOLOGIA', 'Tecnico en televisores', 'mzh4', 'Voy a domicilio', '0', 'técnico con larga experiencia en arreglar equipos técnicos ', '50', '0', '0', '', '', 0, '0', '0', '0', '0', '2020-10-31 04:05:00', '2020-10-31 04:05:00', '0', '0', '0', '0', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nombre` text COLLATE utf8_unicode_ci NOT NULL,
  `apellido` text COLLATE utf8_unicode_ci NOT NULL,
  `email` text COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `token` text COLLATE utf8_unicode_ci NOT NULL,
  `direccion` text COLLATE utf8_unicode_ci NOT NULL,
  `telefono` text COLLATE utf8_unicode_ci NOT NULL,
  `foto` text COLLATE utf8_unicode_ci NOT NULL,
  `tipo` text COLLATE utf8_unicode_ci NOT NULL,
  `confirmado` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `nombre`, `apellido`, `email`, `password`, `token`, `direccion`, `telefono`, `foto`, `tipo`, `confirmado`) VALUES
(1, 'geerson', 'pizarro', 'gerson970707620@gmail.com', '$2y$10$iurOF5OPLNAazrs5cH.mkeChPB7NJliLawMrwy9poAi7GGuEXdNPC', 'e1quyxq4RRuS7WYZTbZwHI:APA91bEu4ztCp1iYaIFj4C30ZcP9sETctrXpUGplL-vqBVNfu9h02XaqJYu5iEu6vct_FwXlnNBpbnua7rBFIvn8-HjT_LSlHBZ_pD2_NTsY_ZGqUVBGDSphbG7ooGxawU62pLyGKLjD', 'MZH4 Lt1A las delicias de villa', '960604148', 'images/image_picker7961167538728084433.jpg', 'c', '1'),
(2, 'David', 'Morales', 'david.m.130294@gmail.com', '$2y$10$OeFY5VvK5.pp2wmnaZ3QtOjaGCy9xEQuvbwJV5jmmfXTyS4g9rnSy', 'fwFHLbxaQE-JEdaZ1Khm_a:APA91bHEMR6izL3PNRV-IOxEIwz_zP8Jzw5Uu0EPHo736IMVwGRXReNIKgSXUBqAyKZwTgfc3PoXxE9Of_snGCfnUavIDYYlIuUWltiO8yx9pg7z9L0QwgAtQ1BtbtlmT9tzxp3hi1lJ', 'ate', '+51956735466', 'images/image_picker7024014583098401894.jpg', 'c', '1'),
(3, 'David', 'Olaguivel', 'david_olaguivel@hotmsil.com', '$2y$10$ngnW7dbKDhV7ukLt2Q6JBueMeyTu3XqxnTFPFCXClKHyPojZeGYPO', 'c2kIG-fNT8Gk5iDhrjC8xT:APA91bEIebSBA_4ZPBArMfomKqPHfOFThnqRvT143W6bh42W5ItGzgLI_V9N2uk7zdhOII3GloVfvUe3DnGRFoD_2mEI5CD_KvqpG90cyRHfA0a-sHJLGT6g05OLZIZusm6IWVyzhrUh', 'calle fray mz h2 lite 17 Rimac', '+51957362781', 'images/image_picker5610863158867386106.jpg', 'c', '0'),
(4, 'Alexander ', 'Rojas Rk', 'alex1998u@hotmail.com', '$2y$10$I3DYEVVljljYTIITKO8AyupHpqj4EMlitRyypWAgqCNpffWFrARva', 'fAj6VIynQiK4LBT1tyXk4t:APA91bHCE_wkWI2he08kPPq6lrUxbgbRzWWacuP879lhlW0Wtfo6VIbo_r3_DN3TwbnfS2qmprY85rnLQ8Y7OAvo3fkd5jSPntyBIjxuzXloVjkGQ2BArI-w8izFqUcRm9Y7DiRyvvl1', 'jr los rubíes 3454', '+51959215425', 'images/image_picker5311100286340033650.jpg', 'c', '1'),
(5, 'David', 'Olaguivel', 'david_olaguivel@hotmail.com', '$2y$10$dkYl3F1GgxOViorsPS.v.eYiOA0ld.dZ4.Wn2Z4u8dM0ccXYGtSQC', 'cjRgpAzKTg27sQSFx7JVaP:APA91bGM5n2OxsK06PoHBjROuyyV4_gsu08l-jAair17ZtkjsYWxDu_2ic1WKMLt8E46qLWOBrRJmqy9UHLEIWNp7xL5MHu5NAieIximt9yuCmqqNXK9gmEan4VhS1vUY5VIw3TOF__E', 'calle fray mz h2 lite 17 Rimac', '+51957362781', 'images/image_picker5610863158867386106.jpg', 'c', '1'),
(6, 'Hugo', 'Pizarro Mendivil', 'geerson.pizarro@unmsm.edu.pe', '$2y$10$iXq8ueUqmmxbDOIIZRWuO.W1riYj3VFjb1eawJJlK972NyWnvuPzi', 'e6fW3rNAQA6HA7wwTL8qJF:APA91bG1_NplgzFkVPH6jaHqeQCRuRP5T3Th0X6VHGiZgZdPpaXq21KUb-IQWOkjSsv3v4JltZBxpZ9cfyQofRC9yEPezOGWlDsQGYCQZ4dlIswuCAYbJr845MHIh9LfFOGbuiLGo5xT', 'Mzh4 Lt1A las delicias de villa', '960604148', 'images/image_picker5993966499964754883.jpg', 'p', '1'),
(7, 'david	', 'olaguivel	', 'david.olaguivel.durand@gmail.com	', '$2y$10$qd6m7JmZgveVzvk6yNbDR.JWT89gTCQjquNBaiSg8kkch8vXGRbAu', 'eFt28czzQrOmGGVZRNBQOr:APA91bFmA95CCFL2ro6wNVfUVpPZOQ_hROtEVFxpEluVm4vTEevTS5afB_PyKq7UCajL8XnCB9Oa1k2GiAZ-Gf3Jl3nGyQAUUFZwSZdmQNGgd0NJVgxyPPpx7PmyGcoKThBeqOTg-8iF', 'Jiron Pasco 542 - Lima	', '+51957362781', 'images/image_picker44413510.jpg', 'c', '1'),
(8, 'kayn', 'flores mendez', 'kayn.g4@gmail.com', '$2y$10$goQLAHW/yU9vCTHOFeFjo.DlG2nIjKKdHuflqFsMZK717/QKNHlfG', 'eVqJPIBsRAajqls-6eGMEt:APA91bHqdgfoz6O1zu1zu5kjWEEGY6dqA7fkj4XwUJePNxoY6CyKXFwUyM8Vxtj_iD3FhKxim71dt2EG0swX4nB-j-enjENfJvbm5tfNeJyh4wrYK-1-aFfG4cVA6huTTWpguj6nS1Se', 'mzh4 Lt1A', '998996995', 'images/6ce8d102-17e4-4e6f-8d34-a54a20a4774d4464440476235752665.jpg', 'p', '1'),
(9, 'Renato', 'Mercado', 'renatomercadoluna@hotmail.com', '$2y$10$zNyGB7VoOBe9GR/VdFd8CODtFg8gmgY7/FIwgtX0ssaj1MSl6z..6', 'dvj5uNcyRf-Mtp79LO5ccU:APA91bHcpG9eiklHps_W2PAEHGG6YUIDCfZb3In8O9s1-5Y1uOS_4-6O7MkooWoAkeTykQfwzLxrchWA8Ediuqx80tCbIdPH5xsaVCHXmqDcCk7z7kecjDM3CexXo9SHszGcpdH3ZZl5', 'gjfjd', '972983014', 'images/efdbfee8-e8eb-476e-b493-993727a54a2c1711292140.jpg', 'c', '1'),
(10, 'Jakeline', 'Capitan Chaname', 'capitan1234diana@gmail.com', '$2y$10$eDn0eaz7jGPo3yQGKX1uHeBtBlk.DjdOOU3/PrKR1gw80zMslQvKa', 'dTUaR-TQRgq9nY_w48EKIG:APA91bEpbXdnhjvQuzA-BeD1wwBTpu3VWShDAEVs7wLPo-3K0jVRqhOtNK2Re9Raoc-rOtoW2n7-ylHZ_6OfP3OLLDOxK2Q5X-UIrq0wVqOazGOvMI_SFw7kbxeVo1wFixDTvw2kTW0G', 'A.V Chiclayo n°123', '925980998', 'images/image_picker1500084679.jpg', 'c', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `id` int(11) NOT NULL,
  `idUsuario` int(11) NOT NULL,
  `idServicio` int(11) NOT NULL,
  `idUsuarioProfesional` int(11) NOT NULL,
  `dia` text COLLATE utf8_unicode_ci NOT NULL,
  `calificar` text COLLATE utf8_unicode_ci NOT NULL,
  `recomendar` text COLLATE utf8_unicode_ci NOT NULL,
  `estado` text COLLATE utf8_unicode_ci NOT NULL,
  `pago` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`id`, `idUsuario`, `idServicio`, `idUsuarioProfesional`, `dia`, `calificar`, `recomendar`, `estado`, `pago`) VALUES
(1, 5, 1, 6, '2020-10-30 09:14:49.816658', '5.0', '1', '', '68.0'),
(2, 1, 1, 6, '2020-10-30 15:59:06.606271', '0', '0', '0', '68.0'),
(3, 5, 2, 8, '2020-10-30 19:47:24.339703', '3.5', '1', '0', '42.5'),
(4, 5, 2, 8, '2020-10-30 19:48:37.104351', '0', '1', '0', '42.5'),
(5, 6, 1, 6, '2020-11-01 01:32:22.051124', '0', '1', '0', '68.0'),
(6, 6, 1, 6, '2020-11-01 01:54:17.936013', '0', '1', '0', '68.0'),
(7, 5, 1, 6, '2020-11-01 10:37:46.817444', '0', '1', '0', '68.0'),
(8, 5, 1, 6, '2020-11-05 17:18:36.011406', '0', '0', '0', '68.0'),
(9, 5, 1, 6, '2020-11-05 17:20:14.500135', '5.0', '0', '0', '68.0'),
(10, 1, 2, 8, '2020-11-05 18:38:12.170122', '0', '0', '0', '42.5');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_clienteusuario` (`idClienteUsuario`);

--
-- Indices de la tabla `favorito`
--
ALTER TABLE `favorito`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_usuariofavorito` (`idUsuarioFav`);

--
-- Indices de la tabla `profesional`
--
ALTER TABLE `profesional`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_profesionalusuario` (`idProfesionalUsuario`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_servicioprofesional` (`idServicioProfesional`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ventaservicio` (`idServicio`),
  ADD KEY `fk_ventausuario` (`idUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `favorito`
--
ALTER TABLE `favorito`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `profesional`
--
ALTER TABLE `profesional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `servicio`
--
ALTER TABLE `servicio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `fk_clienteusuario` FOREIGN KEY (`idClienteUsuario`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `favorito`
--
ALTER TABLE `favorito`
  ADD CONSTRAINT `fk_usuariofavorito` FOREIGN KEY (`idUsuarioFav`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `profesional`
--
ALTER TABLE `profesional`
  ADD CONSTRAINT `fk_profesionalusuario` FOREIGN KEY (`idProfesionalUsuario`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD CONSTRAINT `fk_servicioprofesional` FOREIGN KEY (`idServicioProfesional`) REFERENCES `profesional` (`id`);

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `fk_ventaservicio` FOREIGN KEY (`idServicio`) REFERENCES `servicio` (`id`),
  ADD CONSTRAINT `fk_ventausuario` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
