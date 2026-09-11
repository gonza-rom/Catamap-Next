-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-09-2026 a las 02:32:16
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `catamap`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `nombre`, `descripcion`, `icono`) VALUES
(1, 'Iglesia', NULL, '⛪'),
(2, 'Montaña', NULL, '🏔️'),
(3, 'Río', NULL, '🌊'),
(4, 'Museo', NULL, '🏛️'),
(5, 'Dique', NULL, '💧'),
(6, 'Pueblo', NULL, '🏘️'),
(7, 'Minas', NULL, '⛏️'),
(8, 'Termas', NULL, '♨️'),
(9, 'Cascada', NULL, '💦'),
(10, 'Mirador', NULL, '👀'),
(11, 'Parque Natural', NULL, '🌳'),
(12, 'Ruta Escénica', NULL, '🛣️'),
(13, 'Reserva', NULL, '🦜'),
(14, 'Cerro', NULL, '⛰️'),
(15, 'Laguna', NULL, '🏞️'),
(16, 'Cueva', NULL, '🕳️'),
(17, 'Fiesta/Evento', NULL, '🎉'),
(18, 'Cultura/Arqueología', NULL, '🏺'),
(19, 'Observatorio', NULL, '🔭'),
(20, 'Gastronomía Local', NULL, '🍲'),
(21, 'Desierto', NULL, '🏜️'),
(22, 'Hotel', NULL, '🏨'),
(23, 'Motel', NULL, '🚗'),
(24, 'Camping', NULL, '🏕️'),
(25, 'Información Turística', NULL, 'ℹ️'),
(26, 'Hito Fronterizo', NULL, '📍'),
(27, 'Cabaña', 'sadasd', '?'),
(28, 'Refugio', NULL, '🏚️'),
(29, 'Plaza', NULL, '🌿'),
(99, 'Otros', NULL, '❓');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE `comentarios` (
  `id` int(11) NOT NULL,
  `id_lugar` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `calificacion` tinyint(4) NOT NULL CHECK (`calificacion` between 1 and 5),
  `comentario` text NOT NULL,
  `estado` enum('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
  `aprobado` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_modificacion` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `comentarios`
--

INSERT INTO `comentarios` (`id`, `id_lugar`, `id_usuario`, `calificacion`, `comentario`, `estado`, `aprobado`, `fecha_creacion`, `fecha_modificacion`) VALUES
(8, 12, 3, 4, 'Muy lindo el museo !', 'aprobado', 1, '2025-10-29 08:51:43', '2025-12-17 14:59:12'),
(9, 1007, 4, 2, 'Falta foto !', 'aprobado', 1, '2025-10-29 08:53:57', '2025-12-17 14:59:11'),
(10, 1006, 3, 2, 'sin foto del luigar', 'aprobado', 1, '2025-11-03 22:59:35', '2025-12-17 14:59:10'),
(13, 620, 1, 3, 'Falta foto al lugar y informacion', 'aprobado', 1, '2025-12-17 14:59:23', '2025-12-17 16:19:53'),
(14, 620, 3, 2, 'Falta fotoooo', 'aprobado', 1, '2025-12-17 16:21:03', '2025-12-17 16:24:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion_privacidad`
--

CREATE TABLE `configuracion_privacidad` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `perfil_publico` tinyint(1) DEFAULT 1,
  `favoritos_publicos` tinyint(1) DEFAULT 1,
  `comentarios_publicos` tinyint(1) DEFAULT 1,
  `mostrar_estadisticas` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `configuracion_privacidad`
--

INSERT INTO `configuracion_privacidad` (`id`, `id_usuario`, `perfil_publico`, `favoritos_publicos`, `comentarios_publicos`, `mostrar_estadisticas`) VALUES
(2, 3, 1, 1, 1, 1),
(3, 4, 1, 1, 1, 1),
(4, 5, 1, 1, 1, 1),
(5, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE `departamentos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`id`, `nombre`) VALUES
(4, 'AMBATO'),
(17, 'ANCASTI'),
(2, 'ANDALGALA'),
(3, 'ANTOFAGASTA DE LA SIERRA'),
(5, 'BELEN'),
(6, 'CAPAYAN'),
(1, 'CAPITAL'),
(16, 'DESCONOCIDO'),
(9, 'EL ALTO'),
(7, 'FRAY MAMERTO ESQUIU'),
(8, 'LA PAZ'),
(10, 'PACLIN'),
(11, 'POMAN'),
(13, 'SANTA MARIA'),
(12, 'SANTA ROSA'),
(14, 'TINOGASTA'),
(15, 'VALLE VIEJO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favoritos`
--

CREATE TABLE `favoritos` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_lugar` int(11) NOT NULL,
  `fecha_agregado` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `favoritos`
--

INSERT INTO `favoritos` (`id`, `id_usuario`, `id_lugar`, `fecha_agregado`) VALUES
(29, 4, 16, '2025-10-29 08:59:15'),
(30, 4, 22, '2025-10-29 08:59:17'),
(31, 4, 30, '2025-10-29 08:59:20'),
(32, 4, 33, '2025-10-29 08:59:21'),
(33, 4, 17, '2025-10-29 08:59:32'),
(34, 4, 14, '2025-10-29 08:59:33'),
(36, 3, 1, '2025-11-04 00:59:30'),
(37, 3, 2, '2025-11-04 00:59:32'),
(38, 3, 4, '2025-11-04 00:59:33'),
(39, 3, 26, '2025-11-04 01:03:39'),
(46, 1, 1, '2025-12-17 16:10:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insignias`
--

CREATE TABLE `insignias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL,
  `criterio` varchar(255) DEFAULT NULL,
  `puntos_requeridos` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `insignias`
--

INSERT INTO `insignias` (`id`, `nombre`, `descripcion`, `icono`, `criterio`, `puntos_requeridos`) VALUES
(1, 'Explorador Novato', 'Has agregado tu primer lugar favorito', 'bi-star', 'favoritos', 1),
(2, 'Crítico', 'Has dejado tu primera opinión', 'bi-chat-dots', 'comentarios', 1),
(3, 'Contribuyente', 'Has sugerido tu primer lugar', 'bi-plus-circle', 'sugerencias', 1),
(4, 'Explorador Experto', 'Tienes 10 lugares favoritos', 'bi-star-fill', 'favoritos', 10),
(5, 'Guía Local', 'Has dejado 10 opiniones', 'bi-chat-dots-fill', 'comentarios', 10),
(6, 'Colaborador Activo', 'Has sugerido 5 lugares aprobados', 'bi-award', 'sugerencias', 5),
(7, 'Leyenda de Catamarca', 'Has completado todos los logros', 'bi-trophy-fill', 'todos', 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lugares_sugeridos`
--

CREATE TABLE `lugares_sugeridos` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `lat` decimal(10,8) NOT NULL,
  `lng` decimal(11,8) NOT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_departamento` int(11) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `estado` enum('pendiente','aprobado','rechazado') DEFAULT 'pendiente',
  `motivo_rechazo` text DEFAULT NULL,
  `fecha_sugerido` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_revision` timestamp NULL DEFAULT NULL,
  `revisado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `lugares_sugeridos`
--

INSERT INTO `lugares_sugeridos` (`id`, `id_usuario`, `nombre`, `descripcion`, `direccion`, `lat`, `lng`, `id_categoria`, `id_departamento`, `imagen`, `estado`, `motivo_rechazo`, `fecha_sugerido`, `fecha_revision`, `revisado_por`) VALUES
(1, 3, 'Area natural sierra de belen', 'Area natural sierra de belenArea natural sierra de belenArea natural sierra de belenArea natural sierra de belenArea natural sierra de belenArea natural sierra de belenArea natural sierra de belenArea natural sierra de belenArea natural sierra de belenArea natural sierra de belen', 'Area natural sierra de belen', -27.61340961, -67.26448059, 25, 4, 'sugerencia_3_1761721482.jpg', 'rechazado', NULL, '2025-10-29 07:04:42', NULL, NULL),
(4, 3, 'assssssssss', 'sassssssssssssssssssssssssssssssssssssssssssssssasas', 'assssssssss', -28.54776600, -65.81282600, 1, 12, 'sugerencia_3_1762216914.jpg', 'rechazado', NULL, '2025-11-04 00:41:54', NULL, NULL),
(5, 3, 'asdaaaaaaa', 'asssssssssssssssssssssssssssssssssssssssssssssssssssss', 'asdaasdassad', -28.48106600, -65.78119800, 10, 13, 'sugerencia_3_1762217246.jpg', 'rechazado', NULL, '2025-11-04 00:47:26', NULL, NULL),
(6, 1, 'Virgencita', 'asdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadasasdasdadas', 'Gruta', -28.41865400, -65.79931000, 18, 1, 'sugerencia_1_1765933261.jpg', 'aprobado', NULL, '2025-12-17 01:01:01', NULL, NULL),
(7, 1, 'asdas', 'asdasdadadsaasdasdadadsaasdasdadadsaasdasdadadsaasdasdadadsaasdasdadadsaasdasdadadsaasdasdadadsa', 'Luis De Medina 1385', -28.63282200, -65.79986600, 15, 13, 'sugerencia_1_1765993238.png', 'rechazado', NULL, '2025-12-17 17:40:38', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lugares_turisticos`
--

CREATE TABLE `lugares_turisticos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `lat` decimal(18,15) DEFAULT NULL,
  `lng` decimal(18,15) DEFAULT NULL,
  `imagen` varchar(200) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_departamento` int(11) DEFAULT NULL,
  `estado` enum('pendiente','aprobado','rechazado') DEFAULT 'aprobado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lugares_turisticos`
--

INSERT INTO `lugares_turisticos` (`id`, `nombre`, `descripcion`, `direccion`, `lat`, `lng`, `imagen`, `id_categoria`, `id_departamento`, `estado`) VALUES
(1, 'Catedral Basílica de Nuestra Señora del Valle', 'Templo histórico y centro religioso más importante de Catamarca.', 'San Fernando del Valle de Catamarca', -28.468987690383823, -65.779972760213370, '../img-catamarca/catedral-basilica.webp', 1, 1, 'aprobado'),
(2, 'Dique El Jumeal', 'Espejo de agua rodeado de cerros, ideal para paseos y deportes.', 'Av. Virgen del Valle', -28.456581377641687, -65.809333809876830, '../img-catamarca/dique-el-jumeal.webp', 5, 1, 'aprobado'),
(3, 'La Cuesta del Portezuelo', 'Mirador icónico con vista panorámica a los valles.', 'Ruta Provincial 42', -28.494009246166126, -65.617820519354300, '../img-catamarca/portezuelo.jpg', 2, 15, 'aprobado'),
(4, 'Dique Las Pirquitas', 'Dique rodeado de naturaleza, ideal para paseos y deportes acuáticos.', 'Camino a Pirquitas', -28.270973099918244, -65.738861421609130, '../img-catamarca/pirquitas.jpeg', 5, 7, 'aprobado'),
(5, 'Minas Capillitas', 'Zona minera con paisajes únicos y posibilidad de recorrer senderos.', 'Ruta hacia Huillapima', -27.344498253924090, -66.377074933348850, '../img-catamarca/capillitas.webp', 7, 2, 'aprobado'),
(6, 'Ruinas de Shincal de Quimivil', 'Ruinas arqueológicas de gran importancia histórica y cultural.', 'Ruta Nacional 40', -27.687614480522996, -67.180918949838710, '../img-catamarca/ruinas-de-el-shincal.jpg', 18, 5, 'aprobado'),
(7, 'La Puerta', 'Talleres de artesanías y productos típicos de la región.', 'Centro de Belén', -28.159111624382273, -65.791973085973070, '../img-catamarca/rodeo.jpg', 6, 4, 'aprobado'),
(8, 'Parque Adán Quiroga', 'Espacio verde con juegos, senderos y áreas de recreación.', 'Av. Virgen del Valle', -28.448207180134400, -65.769357314999650, '../img-catamarca/Parque-adan-quiroga.jpeg', 11, 1, 'aprobado'),
(9, 'Termas de Fiambala', 'Complejo termal con aguas calientes naturales.', 'Camino a Fiambalá', -27.742729890122735, -67.551228735220730, '../img-catamarca/termas-de-fiambala.jpg', 8, 14, 'aprobado'),
(11, 'Cerro Ancasti', 'Cerro emblemático con vistas panorámicas de los valles.', 'Camino al Cerro Ancasti', -28.789698982770790, -65.658598311556100, '../img-catamarca/cerro-ancasti.jpg', 14, 17, 'aprobado'),
(12, 'Museo Arqueológico Adán Quiroga', 'Exhibe piezas arqueológicas precolombinas.', 'Calle Sarmiento 345', -28.466157563639875, -65.779345630318060, '../img-catamarca/Museo-Arqueológico-Adán Quiroga.jpg', 4, 1, 'aprobado'),
(13, 'Las Juntas', 'Pequeño dique ideal para pesca y paseo familiar.', 'Ruta Provincial 42', -28.110465973068393, -65.896113289927600, '../img-catamarca/juntas.jpg', 6, 4, 'aprobado'),
(14, 'Dunas de Taton', 'Dunas ubicadas en Fiambalá, ideales para deportes y fotografía.', 'Ubicadas en Fiambalá', -27.350346790573187, -67.582785318918100, '../img-catamarca/dunas-taton.jpg', 21, 14, 'aprobado'),
(15, 'Reserva Natural Laguna Blanca', 'Laguna con diversidad de aves y fauna local.', 'Camino Laguna Blanca', -26.434296638357434, -66.873724617823090, '../img-catamarca/laguna-blanca.png', 13, 5, 'aprobado'),
(16, 'Iglesia San Francisco', 'Iglesia histórica con arquitectura colonial.', 'Calle San Martín 123', -28.466740225274116, -65.778962176062500, '../img-catamarca/iglesia_sanfrancisco4.jpg', 1, 1, 'aprobado'),
(17, 'Sendero de Los Seismiles', 'Un espectacular recorrido por los volcanes más altos del mundo, muchos de ellos por encima de los 6.000 metros de altura. El camino permite vistas impresionantes de la cordillera de los Andes.', 'Ruta Provincial 43', -27.644468932215865, -68.163987460112310, '../img-catamarca/ruta-de-los-seismiles.jpg', 2, 14, 'aprobado'),
(18, 'Cerro Negro', 'Cerro con formaciones rocosas y senderos para caminatas.', 'Camino Cerro Negro', -28.259629223336432, -67.137325553277530, '../img-catamarca/Cerro_Negro_Catamarca.jpg', 2, 14, 'aprobado'),
(19, 'Fiesta Nacional del Poncho', 'Evento cultural con artesanías y música folclórica.', 'Predio Ferial', -28.447966010235210, -65.756717998681200, '../img-catamarca/poncho.jpeg', 17, 1, 'aprobado'),
(21, 'Mirador del Portezuelo', 'Vistas panorámicas de los valles de Catamarca.', 'Ruta Provincial 42', -28.469914827767830, -65.635569016790900, '../img-catamarca/mirador-cuesta-del-portezuelo.jpg', 19, 15, 'aprobado'),
(22, 'Paseo General Navarro “La Alameda\"', 'Cerro emblemático con senderos y vistas panorámicas de los valles.', 'Ruta a Cerro Ambato', -28.469521291786990, -65.787443135582240, '../img-catamarca/paseo-navarro.jpg', 29, 1, 'aprobado'),
(23, 'Museo Arqueológico Condor Huasi', 'Museo que muestra la historia de la región.', 'Calle Belgrano 50', -27.650579412609627, -67.025887497261820, '../img-catamarca/cultura-condor-huasi.jpg', 4, 5, 'aprobado'),
(24, 'Tuneles de la Merced', 'Pequeña cascada ideal para picnic y caminatas.', 'Camino Saladillo', -28.118113324437214, -65.642052922088810, '../img-catamarca/tuneles-merced.JPG', 12, 10, 'aprobado'),
(25, 'Dique La Cañada', 'Espacio recreativo con posibilidad de pesca y paseos.', 'Ruta Provincial 42', -28.168572724577004, -65.527489629204130, '../img-catamarca/dique-la-canada-alijilan.jpg', 5, 12, 'aprobado'),
(26, 'Plaza 25 de Mayo', 'Plaza histórica de la ciudad, con espacios verdes y lugar de encuentro cultural.', 'Ruta Cerro Ambato', -28.468733333553853, -65.778963676062520, '../img-catamarca/Plaza_25_de_Mayo.jpeg', 29, 1, 'aprobado'),
(27, 'El Rodeo', 'Área de talleres artesanales y productos locales, con espacios recreativos.', 'Calle San Martín', -28.213068992939256, -65.875382815243040, '../img-catamarca/rodeo.jpg', 6, 4, 'aprobado'),
(28, 'Mirador del Valle', 'Área protegida con flora y fauna autóctona.', 'Ruta Provincial 42', -28.497348794317546, -65.611517198958340, '../img-catamarca/mirador-cuesta-del-valle.jpg', 10, 15, 'aprobado'),
(29, 'Iglesia de Nuestra Señora del Rosario de Hualfín', 'Iglesia histórica con arquitectura colonial.', 'Calle Independencia 25', -27.218212352665326, -66.832627786811370, '../img-catamarca/iglesiabelen.jpg', 1, 5, 'aprobado'),
(30, 'Mirador del Dique El Jumeal', 'Vistas al dique y al valle circundante.', 'Av. Dique El Jumeal', -28.458501930186358, -65.808416116136040, '../img-catamarca/Mirador-Jumeal.jpg', 10, 1, 'aprobado'),
(31, 'El Salton', 'Es una formación de cascadas y piletas naturales ubicada en el departamento de Paclín, en la provincia de Catamarca, Argentina, entre las localidades de Las Lajas y Villa Balcozna', 'El Salton', -27.866141089486260, -65.725151598888870, '../img-catamarca/salton-balcozna.JPG', 3, 10, 'aprobado'),
(32, 'Mirador de las Lajas', 'Es un punto panorámico para disfrutar del paisaje de la yunga catamarqueña.', 'Mirador de las lajas', -27.866188091168640, -65.728706434495780, '../img-catamarca/mirador-lajas.jpg', 10, 10, 'aprobado'),
(33, 'Gruta de la Virgen del Valle', 'Santuario religioso muy visitado.', 'Gruta de la Virgen del Valle', -28.418478552875820, -65.799314162569090, '../img-catamarca/gruta-vigen-del-valle.jpg', 1, 1, 'aprobado'),
(34, 'Alto Del Solar Centro De Compras', 'Centro comercial popular en la ciudad.', 'Alto Del Solar Centro De Compras', -28.464537504449876, -65.801246749075660, '../img-catamarca/alto-de-solar.jpg', 20, 1, 'aprobado'),
(35, 'Casa Natal De Fray Mamerto Esquiú', 'Lugar histórico de nacimiento de Fray Mamerto Esquiú.', 'Casa Natal De Fray Mamerto Esquiú', -28.394116704393050, -65.703726349075650, '../img-catamarca/Casa-Esquiu.jpg', 18, 7, 'aprobado'),
(36, 'Cuesta La Chilca', 'Ruta escénica con vistas panorámicas.', 'Cuesta La Chilca', -27.636486014354670, -66.184346630036200, '../img-catamarca/cuesta-la-chilca.jpg', 12, 2, 'aprobado'),
(37, 'Dique de Collagasta', 'Dique y zona de recreación.', 'Dique de Collagasta', -28.335423973172265, -65.301546661273100, '../img-catamarca/dique-collagasta.jpg', 5, 9, 'aprobado'),
(38, 'Embalse El Jumeal', '', '', -28.458597700000000, -65.811892100000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(39, 'Plaza Altos de Choya', '', '', -28.444050600000000, -65.776772400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(40, 'Plazoleta Italia', '', '', -28.463942900000000, -65.773958200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(41, 'Iglesia y Convento de San Francisco', '', '', -28.466857000000000, -65.779379800000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(42, 'Parque de los Niños', '', '', -28.461441000000000, -65.766692400000000, '../img-catamarca/default.jpg', 11, 1, 'aprobado'),
(43, 'Plaza Juan Pablo II', '', '', -28.450093100000000, -65.788827100000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(44, 'Catedral Basilica de Nuestra Señora del Valle', '', '', -28.468931800000000, -65.780185200000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(45, 'Iglesia del Corazón de Maria', '', '', -28.468955400000000, -65.784397200000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(46, 'Camping Municipal de La Quebrada', '', '', -28.463634800000000, -65.832938900000000, '../img-catamarca/default.jpg', 24, 1, 'aprobado'),
(47, 'Dique Sumampa', '', '', -28.065319400000000, -65.580259200000000, '../img-catamarca/default.jpg', 5, 10, 'aprobado'),
(48, 'Plaza Jorge Bermúdez', '', '', -28.464743000000000, -65.769174300000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(49, 'Rotonda General Güemes', '', '', -28.460631900000000, -65.788523400000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(50, 'Plazoleta Ramón Garriga', '', '', -28.455459400000000, -65.743736800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(51, 'Plaza El Ombú', '', '', -28.463455800000000, -65.795558900000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(52, 'Camping Municipal La Puerta', '', '', -28.154719200000000, -65.795106000000000, '../img-catamarca/default.jpg', 24, 4, 'aprobado'),
(53, 'Rotonda del Inmigrante Italiano', '', '', -28.460701600000000, -65.762704700000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(54, 'Camping Los Viscotes', '', '', -28.173313700000000, -65.791574300000000, '../img-catamarca/default.jpg', 24, 4, 'aprobado'),
(55, 'Camping La Carrera', '', '', -28.355501700000000, -65.710614700000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(56, 'Camping Pirquitas', '', '', -28.282611500000000, -65.733063700000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(57, 'Plazoleta', '', '', -28.467466600000000, -65.770733900000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(58, 'Plazoleta Alto Parana', '', '', -28.462674700000000, -65.774227700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(59, 'Plaza Heroes de Malvinas', '', '', -28.457859300000000, -65.796200800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(60, 'Laguna Azul', '', '', -27.567391000000000, -68.536558000000000, '../img-catamarca/default.jpg', 15, 14, 'aprobado'),
(61, 'Plaza Fray Mamerto Esquiú', '', '', -27.692165100000000, -67.618923800000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(62, 'Plaza de Tinogasta', '', '', -28.065513500000000, -67.564446300000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(63, 'Plaza de las Américas', '', '', -28.442352900000000, -65.768694600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(64, 'Dique de Minera Alumbrera', '', '', -27.330244000000000, -66.562466000000000, '../img-catamarca/default.jpg', 5, 16, 'aprobado'),
(65, 'Laguna Escondida', '', '', -26.356813000000000, -66.807649300000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(66, 'Laguna Baya', '', '', -26.241146500000000, -66.978300500000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(67, 'Laguna Grande', '', '', -26.240933300000000, -67.063297000000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(68, 'Laguna', '', '', -26.215915800000000, -67.080457600000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(69, 'Laguna', '', '', -26.107824500000000, -66.733533300000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(70, 'Laguna Aguada Alumbrera', '', '', -26.902180200000000, -67.728399000000000, '../img-catamarca/default.jpg', 15, 14, 'aprobado'),
(71, 'Laguna de Antofagasta', '', '', -26.109682600000000, -67.396857000000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(72, 'Plaza Tinkunaku', '', '', -28.485989500000000, -65.794009200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(73, 'Paseo del Milenio', '', '', -28.458531800000000, -65.789187200000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(74, 'Plaza del Combatiente de Incendios Forestales', '', '', -28.457983200000000, -65.808617400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(75, 'Plaza 5 de Julio', '', '', -28.463807500000000, -65.763821800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(76, 'Plazoleta Del Sur', '', '', -28.482977600000000, -65.777475800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(77, 'Plaza de Los Ángeles', '', '', -28.507927300000000, -65.954052100000000, '../img-catamarca/default.jpg', 29, 6, 'aprobado'),
(78, 'Plaza Felix Nazar', '', '', -28.467319900000000, -65.763599900000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(79, 'Plaza Luis Varela Lezana', '', '', -28.459549100000000, -65.769568100000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(80, 'Pueblo Perdido de la Quebrada', '', '', -28.467014100000000, -65.832221900000000, '../img-catamarca/default.jpg', 6, 1, 'aprobado'),
(81, 'El Calvario', '', '', -28.459909700000000, -65.842186200000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(82, 'Lago El Molino', '', '', -27.698959300000000, -67.165286100000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(83, 'Estanque', '', '', -28.059580700000000, -66.189760800000000, '../img-catamarca/default.jpg', 99, 11, 'aprobado'),
(84, 'Cabañas Los Alpinos', '', '', -28.191471600000000, -65.785209600000000, '../img-catamarca/default.jpg', 27, 4, 'aprobado'),
(85, 'Grillos', '', '', -27.159680500000000, -68.633826400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(86, 'Co. Arrieros', '', '', -27.150814000000000, -68.637431300000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(87, 'Hito XV-11 A', '', '', -27.146291600000000, -68.816830500000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(88, 'Hito XVI-5 A', '', '', -25.427669500000000, -68.586478400000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(89, 'Cerro Puntiagudo y Lamas', '', '', -27.152634200000000, -68.806970700000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(90, 'Arrieros / Chullo Bayo', '', '', -27.136462600000000, -68.655112400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(91, 'Pedregoso', '', '', -27.103758400000000, -68.668673700000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(92, 'Cerro Tridente', '', '', -26.287103300000000, -68.557535800000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(93, 'Cerro Atalaya', '', '', -25.298506900000000, -68.545774700000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(94, 'Cumbre de la Línea', '', '', -26.813873000000000, -68.347945500000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(95, 'Sierra Nevada de Lagunas Bravas', '', '', -26.492935600000000, -68.587335900000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(96, 'Los Varela', '', '', -27.931474400000000, -65.871973700000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(97, 'Plaza 25 de Mayo', '', '', -29.278739000000000, -65.058684100000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(98, 'Dique Motegasta', '', '', -29.037445700000000, -65.368891100000000, '../img-catamarca/default.jpg', 5, 8, 'aprobado'),
(99, 'Plaza Bella Vista', '', '', -28.473490900000000, -65.765103600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(100, 'Plazoleta de la Ermita de Nuestra Señora del Valle', '', '', -28.457086500000000, -65.727484000000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(101, 'Plazoleta Gastón', '', '', -29.273975700000000, -65.063029800000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(102, 'Plazoleta Barrio Policial', '', '', -28.479434600000000, -65.798685200000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(103, 'Apumayta', '', '', -28.466729600000000, -65.805441800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(104, 'Wayta', '', '', -28.466875000000000, -65.807482000000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(105, 'Illawara', '', '', -28.465542400000000, -65.807592700000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(106, 'Inti', '', '', -28.465404500000000, -65.805542800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(107, 'Museo de la Virgen del Valle', '', '', -28.468681600000000, -65.780598700000000, '../img-catamarca/default.jpg', 4, 1, 'aprobado'),
(108, 'Hotel Arenales', '', '', -28.467578600000000, -65.779619700000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(109, 'Hotel Ancasti', '', '', -28.467413400000000, -65.779418000000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(110, 'Plaza Raúl Alfonsín', '', '', -28.477593900000000, -65.786713200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(111, 'Parroquia San Jose Obrero', '', '', -28.481439100000000, -65.784526400000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(112, 'Grand Hotel', '', '', -28.468708200000000, -65.787362700000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(113, 'Hotel Suma Huasi', '', '', -28.467585200000000, -65.780219800000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(114, 'Iglesia de Santa Rosa de Lima', '', '', -28.464780900000000, -65.786723700000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(115, 'Iglesia Universal', '', '', -28.467611700000000, -65.773830500000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(116, 'Coral Hotel', '', '', -28.475609800000000, -65.775421600000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(117, 'Amerian Catamarca Park Hotel', '', '', -28.468785300000000, -65.781986600000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(118, 'Plazoleta La Carreta', '', '', -28.477518100000000, -65.799694300000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(119, 'Plazoleta Sagrada Familia', '', '', -28.478499200000000, -65.799625500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(120, 'Plaza San Jose Obrero', '', '', -28.455251800000000, -65.777775100000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(121, 'Plazoleta \"Los Aviadores\"', '', '', -28.451845000000000, -65.782660700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(122, 'Plaza 20 de Junio', '', '', -28.481302900000000, -65.797291900000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(123, 'Plaza General Manuel Belgrano', '', '', -26.694566500000000, -66.048093200000000, '../img-catamarca/default.jpg', 29, 13, 'aprobado'),
(124, 'Circuito de la Vida Achachay', '', '', -28.474701200000000, -65.804660300000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(125, 'Laguna de Caro', '', '', -25.560643200000000, -67.292417700000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(126, 'Shincal de Quimivil', '', '', -27.688329200000000, -67.180179600000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(127, 'FB Meditazen', '', '', -28.645519300000000, -65.893464500000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(128, 'Estanque INTA', '', '', -28.464984700000000, -65.728786600000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(129, 'Plazoleta Virgen del Valle', '', '', -29.272523700000000, -65.061153000000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(130, 'Parroquia San Nicolás de Bari', '', '', -28.486019200000000, -65.780441500000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(131, 'Plaza de Chaquiago', '', '', -27.547724500000000, -66.326653600000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(132, 'Salón del Bicentenario', '', '', -29.279621600000000, -65.062196500000000, '../img-catamarca/default.jpg', 3, 8, 'aprobado'),
(133, 'Plazoleta Puqui Gonzales', '', '', -29.272792000000000, -65.060603500000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(134, 'Parroquia San Roque', '', '', -29.277747900000000, -65.055045900000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(135, 'Plazoleta de Los Niños', '', '', -29.278026700000000, -65.056612000000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(136, 'Camping Municipal La Colonia', '', '', -29.286970100000000, -65.062351300000000, '../img-catamarca/default.jpg', 24, 8, 'aprobado'),
(137, 'Hotel Tula', '', '', -29.276313400000000, -65.060985000000000, '../img-catamarca/default.jpg', 22, 8, 'aprobado'),
(138, 'Hotel Sarmiento', '', '', -29.277666000000000, -65.057803200000000, '../img-catamarca/default.jpg', 22, 8, 'aprobado'),
(139, 'Hotel Rivadavia', '', '', -29.275513100000000, -65.058988700000000, '../img-catamarca/default.jpg', 22, 8, 'aprobado'),
(140, 'Casa de La Cultura', '', '', -29.276079000000000, -65.057809800000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(141, 'Cristo Redentor', '', '', -29.275369900000000, -65.052417300000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(142, 'Capilla San Cayetano', '', '', -29.270532300000000, -65.057363000000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(143, 'Capilla', '', '', -29.284369700000000, -65.055057400000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(144, 'Capilla San José', '', '', -29.276005800000000, -65.061885300000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(145, 'Integrador Carlos Perdiguero', '', '', -29.278733400000000, -65.056172800000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(146, 'Plazoleta de la Madre', '', '', -29.278949700000000, -65.057628400000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(147, 'Tu Recreo', '', '', -29.271699400000000, -65.055770300000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(148, 'Camping Municipal La Aguada', '', '', -27.553407500000000, -66.302013300000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(149, 'Camping Municipal Chaquiago', '', '', -27.546357800000000, -66.324609600000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(150, 'Plaza Juan Cayetano Bianchi', '', '', -28.173762700000000, -66.211398300000000, '../img-catamarca/default.jpg', 29, 11, 'aprobado'),
(151, 'Estanque municipal', '', '', -28.178711700000000, -66.201287700000000, '../img-catamarca/default.jpg', 99, 11, 'aprobado'),
(152, 'Camping Municpal Thermas los Nascimentos', '', '', -27.156824100000000, -66.756425900000000, '../img-catamarca/default.jpg', 24, 5, 'aprobado'),
(153, 'Plaza Jesús de Nazaret', '', '', -28.176469000000000, -67.488159200000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(154, 'Plaza Ramón S. Castillo', '', '', -28.812599900000000, -65.500678900000000, '../img-catamarca/default.jpg', 29, 17, 'aprobado'),
(155, 'Plaza Los Morteros', '', '', -28.469094300000000, -65.811328500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(156, 'Plaza La Cruz Negra', '', '', -28.452699300000000, -65.744707500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(157, 'Plaza Luis \"Quique\" Sánchez Vera', '', '', -28.453482600000000, -65.756662800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(158, 'Plaza Raul Contreras', '', '', -28.493428900000000, -65.792424700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(159, 'Plaza El Agricultor', '', '', -28.464429100000000, -65.766253400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(160, 'Plaza 29 de Abril', '', '', -28.499492300000000, -65.789739000000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(161, 'Plazoleta Manuel de Reyes Sinchicay', '', '', -27.521189600000000, -66.383543900000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(162, 'Plazoleta del Niño', '', '', -28.473739000000000, -65.724041500000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(163, 'Laguna Colorada', '', '', -26.034514200000000, -67.452841900000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(164, 'Chancho Blanco', '', '', -25.303006300000000, -67.777010000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(165, 'Laguna Patos', '', '', -25.538544700000000, -68.136947300000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(166, 'Laguna Cajeros', '', '', -25.664063500000000, -68.131276700000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(167, 'Paseo de la Vida', '', '', -27.473929200000000, -66.014088900000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(168, 'Plaza de los niños', '', '', -27.505091600000000, -66.020127700000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(169, 'Plazoleta La Ilusión', '', '', -28.470494900000000, -65.767714400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(170, 'Plaza Romis Raiden', '', '', -28.503665900000000, -65.804535400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(171, 'Laguna Grande', '', '', -26.389163500000000, -66.480863400000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(172, 'Laguna Huasito', '', '', -26.372876700000000, -66.472517200000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(173, 'Ex Cementerio', '', '', -28.174494400000000, -65.793169600000000, '../img-catamarca/default.jpg', 3, 4, 'aprobado'),
(174, 'Monumento a la Mujer Aborigen', '', '', -28.464290200000000, -65.818166400000000, '../img-catamarca/default.jpg', 18, 1, 'aprobado'),
(175, 'Laguna Pedernal', '', '', -25.688180300000000, -67.146118300000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(176, 'Paseo del Mirador', '', '', -28.745492600000000, -65.547881400000000, '../img-catamarca/default.jpg', 10, 17, 'aprobado'),
(177, 'Plaza Del Nido', '', '', -28.432370000000000, -65.774452600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(178, 'Laguna Amarga', '', '', -26.649100400000000, -68.178431300000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(179, 'Laguna del Peinado', '', '', -26.504446400000000, -68.098442400000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(180, 'Iglesia Nuestra Señora de la Candelaria', '', '', -26.694431400000000, -66.049039800000000, '../img-catamarca/default.jpg', 1, 13, 'aprobado'),
(181, 'Cabañas Samay', '', '', -28.477857500000000, -65.805617000000000, '../img-catamarca/default.jpg', 27, 1, 'aprobado'),
(182, 'Balneario municipal de Saujil', '', '', -28.178992200000000, -66.199105000000000, '../img-catamarca/default.jpg', 3, 11, 'aprobado'),
(183, 'Parque de la Estación', '', '', -28.174757700000000, -66.215730400000000, '../img-catamarca/default.jpg', 11, 11, 'aprobado'),
(184, 'Camping Municipal', '', '', -26.696135200000000, -66.041091600000000, '../img-catamarca/default.jpg', 24, 13, 'aprobado'),
(185, 'Albergue Municipal', '', '', -26.695811600000000, -66.041766100000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(186, 'Parroquia Inmaculada Concepción', '', '', -28.812488600000000, -65.501351600000000, '../img-catamarca/default.jpg', 1, 17, 'aprobado'),
(187, 'El Aguila', '', '', -28.757594400000000, -65.544168600000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(188, 'Plazoleta', '', '', -28.136985500000000, -66.201493200000000, '../img-catamarca/default.jpg', 29, 11, 'aprobado'),
(189, 'Plazoleta', '', '', -28.142596600000000, -66.195419000000000, '../img-catamarca/default.jpg', 29, 11, 'aprobado'),
(190, 'El Paso del Indio', '', '', -28.816975800000000, -65.497966100000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(191, 'Plaza España', '', '', -28.488726500000000, -65.779472700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(192, 'Laguna', '', '', -26.160532400000000, -66.808755300000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(193, 'San Antonio María Claret', '', '', -28.464479100000000, -65.808085100000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(194, 'Hotel Cielo del Oeste', '', '', -26.694082100000000, -66.045159000000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(195, 'Hotel Complejo Caasama', '', '', -26.704359800000000, -66.051057800000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(196, 'Plaza Las Americas', '', '', -26.702965400000000, -66.048141400000000, '../img-catamarca/default.jpg', 29, 13, 'aprobado'),
(197, 'Plazoleta', '', '', -28.493635000000000, -65.797445000000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(198, 'Plaza Santa Rosa', '', '', -28.040703100000000, -67.585666700000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(199, 'Parque Arqueologico provincial La Tunita', '', '', -28.900395700000000, -65.427901200000000, '../img-catamarca/default.jpg', 11, 17, 'aprobado'),
(200, 'Laguna de las Tunas', '', '', -27.754275100000000, -68.460611800000000, '../img-catamarca/default.jpg', 15, 14, 'aprobado'),
(201, 'Hosteria Cortaderas', '', '', -27.561154500000000, -68.147217000000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(202, 'Refugio Nº 4 Las Losas', '', '', -27.243128300000000, -68.115490200000000, '../img-catamarca/default.jpg', 28, 14, 'aprobado'),
(203, 'Laguna Amarga', '', '', -27.555499200000000, -68.362543400000000, '../img-catamarca/default.jpg', 15, 14, 'aprobado'),
(204, 'Laguna Frias', '', '', -27.518073400000000, -68.355845800000000, '../img-catamarca/default.jpg', 15, 14, 'aprobado'),
(205, 'Refugio N° 3 Cazadera Grande', '', '', -27.420163400000000, -68.130962400000000, '../img-catamarca/default.jpg', 28, 14, 'aprobado'),
(206, 'Refugio N° 5 Las Pelades', '', '', -26.975260200000000, -68.056328900000000, '../img-catamarca/default.jpg', 28, 14, 'aprobado'),
(207, 'Refugio N° 6', '', '', -26.873300500000000, -68.298962400000000, '../img-catamarca/default.jpg', 28, 16, 'aprobado'),
(208, 'Refugio N° 2 Valle de chaschuil', '', '', -27.770226700000000, -68.115879800000000, '../img-catamarca/default.jpg', 28, 14, 'aprobado'),
(209, 'Guanchin', '', '', -27.552175400000000, -68.146105200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(210, 'Aguas Calientes', '', '', -25.569876000000000, -68.411530700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(211, 'Laguna Las Lagunitas', '', '', -25.349319700000000, -67.729558300000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(212, 'Laguna Las Lagunitas', '', '', -25.350677000000000, -67.733903600000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(213, 'Laguna del Conito', '', '', -25.362543900000000, -67.726956600000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(214, 'Laguna Ratones', '', '', -26.170920400000000, -67.750177100000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(215, 'Mina Incahuasi', '', '', -25.430268600000000, -67.184073500000000, '../img-catamarca/default.jpg', 7, 3, 'aprobado'),
(216, 'Mina Incahuasi', '', '', -25.425717000000000, -67.185171100000000, '../img-catamarca/default.jpg', 7, 3, 'aprobado'),
(217, 'Laguna Verde', '', '', -25.419516600000000, -66.809147700000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(218, 'Laguna', '', '', -25.339860600000000, -66.838126000000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(219, 'Laguna Verde', '', '', -25.418315500000000, -66.822276800000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(220, 'Laguna', '', '', -25.337003900000000, -66.798332700000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(221, 'Cerro Archibarca', '', '', -25.237685000000000, -67.864494000000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(222, 'Laguna', '', '', -25.591238000000000, -67.177128500000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(223, 'Laguna Diamante', '', '', -26.009988600000000, -67.045675400000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(224, 'Laguna', '', '', -26.136234300000000, -66.718136300000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(225, 'Laguna Del Salitre', '', '', -26.257151000000000, -66.902974000000000, '../img-catamarca/default.jpg', 15, 5, 'aprobado'),
(226, 'Laguna Espejo', '', '', -26.294394100000000, -67.088455000000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(227, 'Ojos del Campo', '', '', -25.613002500000000, -67.672916000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(228, 'Ojos del Campo', '', '', -25.613495900000000, -67.672376200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(229, 'Ojos del Campo', '', '', -25.612658400000000, -67.672686000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(230, 'Ojos del Campo', '', '', -25.613908300000000, -67.672161600000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(231, 'Pucará de La Alumbrera', '', '', -26.115122200000000, -67.419079100000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(232, 'Plaza de la Democracia', '', '', -28.484643800000000, -65.797720200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(233, 'Camping Los Sauces', '', '', -28.153140900000000, -65.793485800000000, '../img-catamarca/default.jpg', 24, 4, 'aprobado'),
(234, 'Gruta de la Virgen', '', '', -28.169868000000000, -65.788120900000000, '../img-catamarca/default.jpg', 1, 4, 'aprobado'),
(235, 'Parroquia Nuestra Sra. del Rosario', '', '', -28.169910400000000, -65.791567000000000, '../img-catamarca/default.jpg', 3, 4, 'aprobado'),
(236, 'Hostería Cuesta El Portezuelo', '', '', -28.489362600000000, -65.606290100000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(237, 'Hotel Colonial', '', '', -28.467834300000000, -65.775282800000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(238, 'Hotel Shincal', '', '', -28.474851900000000, -65.773550300000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(239, 'Residencial Menem', '', '', -28.476071900000000, -65.775445100000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(240, 'Hotel Casino Catamarca', '', '', -28.467623000000000, -65.785000800000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(241, 'Predio Mama Llama', '', '', -26.720883800000000, -66.051474400000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(242, 'Capilla Virgen de Fátima', '', '', -28.458185900000000, -65.795854600000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(243, 'Información Turística', '', '', -28.193468700000000, -65.770949100000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(244, 'Parroquia de San José', '', '', -28.394849000000000, -65.702456400000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(245, 'Casa Natal de Fray Mamerto Esquiu', '', '', -28.394221900000000, -65.703870700000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(246, 'Nuestra Señora de las Mercedes', '', '', -28.444479200000000, -65.721614400000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(247, 'Santa Rosa de Lima', '', '', -28.443833400000000, -65.702845900000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(248, 'Museo y Centro de Interpretación Sitio El Shincal', '', '', -27.689662500000000, -67.183458600000000, '../img-catamarca/default.jpg', 4, 5, 'aprobado'),
(249, 'Kallanka', '', '', -27.687163700000000, -67.179020900000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(250, 'Ushnu', '', '', -27.686555500000000, -67.178582600000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(251, 'Sinchiwasi', '', '', -27.687765500000000, -67.178248200000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(252, 'Residencia del Jefe', '', '', -27.684475000000000, -67.189771300000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(253, 'Predio Ferial Campo las Heras', '', '', -28.448729400000000, -65.757230600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(254, 'Monumento a la Coronación', '', '', -28.469635900000000, -65.787243500000000, '../img-catamarca/default.jpg', 18, 1, 'aprobado'),
(255, 'Santuario del Señor de los Milagros', '', '', -28.370243000000000, -65.701917600000000, '../img-catamarca/default.jpg', 3, 16, 'aprobado'),
(256, 'Casa de la Puna', '', '', -28.453477400000000, -65.757541600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(257, 'Antigua Iglesia de Santa Rosa de Lima', '', '', -28.443653400000000, -65.702822600000000, '../img-catamarca/default.jpg', 1, 15, 'aprobado'),
(258, 'Antigua Residencia Gubernamental', '', '', -28.271365500000000, -65.733344100000000, '../img-catamarca/default.jpg', 99, 7, 'aprobado'),
(259, 'plazoleta rosa', '', '', -28.028928400000000, -67.596094100000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(260, 'Plaza 9 de Julio', '', '', -27.583014700000000, -66.315473000000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(261, 'Rotonda Andalgalá', '', '', -28.454539500000000, -65.795840800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(262, 'Plaza Soles', '', '', -28.427496600000000, -65.771522800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(263, 'Plaza 20 de Marzo', '', '', -28.503590600000000, -65.787688800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(264, 'Plaza Eva Perón', '', '', -28.463679100000000, -65.699283100000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(265, 'Capilla Nuestra Señora del Rosario', '', '', -28.394542400000000, -65.717354200000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(266, 'Nuestra Señora del Valle', '', '', -28.279539300000000, -65.732036400000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(267, 'Hosteria Pirquitas', '', '', -28.278996400000000, -65.732457500000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(268, 'Iglesia', '', '', -28.304515800000000, -65.732122800000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(269, 'Hito XVI-4 A', '', '', -25.579355100000000, -68.529323200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(270, 'Cerro Agua de La Falda', '', '', -25.574439100000000, -68.514951000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(271, 'Loma La Falda', '', '', -25.543789400000000, -68.537301400000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(272, 'Cerro Aguas Blancas', '', '', -25.708099500000000, -68.478916900000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(273, 'Cerro Bayo', '', '', -25.414405000000000, -68.589953200000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(274, 'Plazoleta', '', '', -28.316196700000000, -66.149386700000000, '../img-catamarca/default.jpg', 29, 11, 'aprobado'),
(275, 'Camping Las Pircas', '', '', -28.174209200000000, -65.792174800000000, '../img-catamarca/default.jpg', 24, 4, 'aprobado'),
(276, 'Camping El Portezuelo', '', '', -28.464038400000000, -65.633153100000000, '../img-catamarca/default.jpg', 24, 15, 'aprobado'),
(277, 'Capilla', '', '', -28.154450500000000, -65.660265000000000, '../img-catamarca/default.jpg', 1, 10, 'aprobado'),
(278, 'Hosteria', '', '', -27.864736200000000, -65.726960000000000, '../img-catamarca/default.jpg', 22, 10, 'aprobado'),
(279, 'Camping', '', '', -27.884239500000000, -65.728670500000000, '../img-catamarca/default.jpg', 24, 10, 'aprobado'),
(280, 'Plaza Octavio Gutierrez', '', '', -27.524813500000000, -66.017191400000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(281, 'Los Olivos', '', '', -28.039036000000000, -67.587523200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(282, 'Hotel Inti Huasi', '', '', -28.468723400000000, -65.782845800000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(283, 'Salvador Apart Hotel', '', '', -28.459373800000000, -65.781099500000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(284, 'Residencial Tucumán', '', '', -28.473802000000000, -65.775453500000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(285, 'Residencial Delgado', '', '', -28.469201000000000, -65.775726300000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(286, 'Hotel Sol', '', '', -28.475247500000000, -65.776622600000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(287, 'Hosteria El Rodeo', '', '', -28.223848500000000, -65.876090400000000, '../img-catamarca/default.jpg', 22, 4, 'aprobado'),
(288, 'Iglesia Ntra Señora de la Candelaria', '', '', -28.209730500000000, -65.877673600000000, '../img-catamarca/default.jpg', 1, 4, 'aprobado'),
(289, 'Iglesia Vieja (Pura y Limpia Concepcion)', '', '', -28.204702800000000, -65.876819200000000, '../img-catamarca/default.jpg', 1, 4, 'aprobado'),
(290, 'Hosteria La Merced', '', '', -28.157326800000000, -65.656806200000000, '../img-catamarca/default.jpg', 22, 10, 'aprobado'),
(291, 'Cabañas del Dique', '', '', -28.068983900000000, -65.572817800000000, '../img-catamarca/default.jpg', 5, 10, 'aprobado'),
(292, 'Seminario Diocesano', '', '', -28.468964700000000, -65.773229400000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(293, 'Capilla de San Rafael', '', '', -28.466066500000000, -65.775656400000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(294, 'Parroquia San Antonio de Padua', '', '', -28.462719500000000, -65.775853300000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(295, 'Parroquia Jesús Niño', '', '', -28.474128800000000, -65.770121000000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(296, 'Iglesia San José Obrero', '', '', -28.457722900000000, -65.778249900000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(297, 'Hospedaje El Peregrino', '', '', -28.469417200000000, -65.780372800000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(298, 'Plaza \"La Chacarita\"', '', '', -28.459955000000000, -65.752473800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(299, 'El Calvario', '', '', -28.459970900000000, -65.842521600000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(300, 'Plaza 2 de Abril', '', '', -28.460433000000000, -65.770115400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(301, 'Museo Arqueológico Jorge Saravia', '', '', -27.224876500000000, -66.835195300000000, '../img-catamarca/default.jpg', 4, 5, 'aprobado'),
(302, 'Termas de la quebrada', '', '', -27.213386100000000, -66.865885000000000, '../img-catamarca/default.jpg', 8, 5, 'aprobado'),
(303, 'Por aqui pasó Dakar2009', '', '', -27.692203100000000, -67.608119800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(304, 'Termas de Fiambalá', '', '', -27.742376600000000, -67.550670100000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(305, 'Refugio N° 1 Gallina Muerte', '', '', -27.767880900000000, -68.011853500000000, '../img-catamarca/default.jpg', 28, 14, 'aprobado'),
(306, 'Zona de Picnic', '', '', -28.183780400000000, -65.791722000000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(307, 'Yapura - Habitacion con baño para alquilar', '', '', -28.162380300000000, -65.792988300000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(308, 'Residencial Doña Pocha', '', '', -27.679665500000000, -67.617077900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(309, 'Zona de Espectadores - Dakar 2010', '', '', -27.689580100000000, -67.612015100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(310, 'Plaza del Aborigen', '', '', -28.449535200000000, -65.720073800000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(311, 'Plaza Ramón Castillo', '', '', -28.448135500000000, -65.722706000000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(312, 'Plaza de Santa Rosa', '', '', -28.446516700000000, -65.705942800000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(313, 'Plaza Constitución / Juan Pablo II', '', '', -28.439027200000000, -65.710870500000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(314, 'Plaza San Martín', '', '', -28.457812300000000, -65.724983200000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(315, 'Rotonda de los Ciclistas', '', '', -28.468226300000000, -65.733611500000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(316, 'Plazoleta Islas Malvinas', '', '', -28.467596200000000, -65.734879300000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(317, 'Albergue Municipal', '', '', -27.093197600000000, -66.823382300000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(318, 'Hostería Municipal', '', '', -27.093324200000000, -66.823190500000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(319, 'Plaza Victoriano Toloza', '', '', -28.423757800000000, -65.705028200000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(320, 'Parque Chacarero', '', '', -28.423658400000000, -65.710062000000000, '../img-catamarca/default.jpg', 11, 16, 'aprobado'),
(321, 'Plaza Fray Mamerto Esquiu', '', '', -28.394781000000000, -65.703107000000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(322, 'Refugio del Chacho', '', '', -28.155339400000000, -65.794918400000000, '../img-catamarca/default.jpg', 28, 4, 'aprobado'),
(323, 'Plaza de Armas', '', '', -28.459195100000000, -65.765748700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(324, 'Cristo - Via Crusis', '', '', -28.188701400000000, -65.796052800000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(325, 'Salon La Casona y otros eventos', '', '', -28.170695200000000, -65.790317100000000, '../img-catamarca/default.jpg', 17, 4, 'aprobado'),
(326, 'Parque terminal', '', '', -27.651618900000000, -67.028366800000000, '../img-catamarca/default.jpg', 7, 5, 'aprobado'),
(327, 'Camping EL SOL', '', '', -26.676361700000000, -66.046093500000000, '../img-catamarca/default.jpg', 24, 13, 'aprobado'),
(328, 'Del Bajo', '', '', -27.702420800000000, -66.008740500000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(329, 'Pucará del Aconquija 2', '', '', -27.701077900000000, -66.001166000000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(330, 'Pucará del Aconquija', '', '', -27.708278500000000, -65.998243700000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(331, 'Plazoleta La Copa', '', '', -27.488251100000000, -66.019121500000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(332, 'Paseo Lineal', '', '', -27.497015900000000, -66.024018000000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(333, 'Hostería La Pome', '', '', -26.478529800000000, -67.261213500000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(334, 'Represa', '', '', -28.197829800000000, -65.113877500000000, '../img-catamarca/default.jpg', 99, 12, 'aprobado'),
(335, 'Cristo de La Cruz Negra', '', '', -28.448968200000000, -65.749313600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(336, 'Hosteria Alijilan', '', '', -28.170545700000000, -65.491232900000000, '../img-catamarca/default.jpg', 22, 12, 'aprobado'),
(337, 'Plaza Los Australes', '', '', -28.502857100000000, -65.803836800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(338, 'Plaza Sueños de Niños', '', '', -28.430835800000000, -65.713230400000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(339, 'Hosteria Concepción', '', '', -28.682636900000000, -66.066229300000000, '../img-catamarca/default.jpg', 22, 6, 'aprobado'),
(340, 'Plazoleta Alan Cordero', '', '', -28.446922800000000, -65.699999200000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(341, 'Plaza De la Tradición', '', '', -27.138039200000000, -66.944141300000000, '../img-catamarca/default.jpg', 29, 5, 'aprobado'),
(342, 'Plaza El Angel', '', '', -28.462586300000000, -65.791079000000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(343, 'Plaza Panamericana', '', '', -28.463139100000000, -65.791050700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(344, 'PLaza La Esperanza', '', '', -28.463232700000000, -65.756533000000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(345, 'Monumento del Aborigen', '', '', -28.449754500000000, -65.721241900000000, '../img-catamarca/default.jpg', 18, 15, 'aprobado'),
(346, 'Termas La Aguadita', '', '', -28.030563300000000, -67.666530600000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(347, 'Centro Recreativo Guayamba', '', '', -28.345990800000000, -65.401506500000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(348, 'Pasto verde', '', '', -28.344037400000000, -65.389759700000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(349, 'Parroquia Sagrada Familia', '', '', -28.472211500000000, -65.790812900000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(350, 'Iglesia', '', '', -28.507741200000000, -65.954288800000000, '../img-catamarca/default.jpg', 1, 6, 'aprobado'),
(351, 'Parador', '', '', -28.481216800000000, -65.950141800000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(352, 'Plaza San Ramón', '', '', -28.479219800000000, -65.793114700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(353, 'Plaza Los Penisetum', '', '', -28.435911000000000, -65.778912500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(354, 'plaza de la mujer', '', '', -28.382132300000000, -65.702945700000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(355, 'plaza Fray Mamerto Esquiú', '', '', -28.380310700000000, -65.701285800000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(356, 'parque el paisano', '', '', -28.052583600000000, -67.571893000000000, '../img-catamarca/default.jpg', 11, 14, 'aprobado'),
(357, 'parque el fly', '', '', -28.053161200000000, -67.572729900000000, '../img-catamarca/default.jpg', 11, 14, 'aprobado'),
(358, 'plazoleta', '', '', -28.060206100000000, -67.554871100000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(359, 'la gruta', '', '', -28.068194100000000, -67.560861900000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(360, 'plaza comodoro rivadavia', '', '', -28.055484300000000, -67.565479500000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(361, 'plaza 14 de agosto', '', '', -28.057452700000000, -67.569872500000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(362, 'Dique La Cañada', '', '', -28.171159000000000, -65.532563400000000, '../img-catamarca/default.jpg', 5, 12, 'aprobado'),
(363, 'Camping Vialidad', '', '', -28.391892300000000, -65.700422700000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(364, 'Mastil. Final del murallón', '', '', -28.066802600000000, -65.575141500000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado');
INSERT INTO `lugares_turisticos` (`id`, `nombre`, `descripcion`, `direccion`, `lat`, `lng`, `imagen`, `id_categoria`, `id_departamento`, `estado`) VALUES
(365, 'Vertedero', '', '', -28.065953300000000, -65.575322200000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(366, 'Plaza San Martin', '', '', -28.456312300000000, -65.751298700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(367, 'Plazoleta', '', '', -28.456355300000000, -65.750626200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(368, 'Virgen de Guadalupe', '', '', -28.509633600000000, -65.818184300000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(369, 'Iglesia San Pio X', '', '', -28.485845900000000, -65.794458900000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(370, 'Plazoleta El Vecinista', '', '', -28.506319400000000, -65.802284400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(371, 'Iglesia San Ramón Nonato', '', '', -28.478484500000000, -65.793482100000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(372, 'Plaza Las Acacias', '', '', -28.432948100000000, -65.776450400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(373, 'Plaza del Ajedrez', '', '', -28.485532300000000, -65.789043500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(374, 'Plaza Luciérnaga Curiosa', '', '', -28.436594800000000, -65.764734200000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(375, 'Parroquia San Jorge', '', '', -28.490375100000000, -65.788990500000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(376, 'Plazoleta Niño Jesus', '', '', -28.438822800000000, -65.777234800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(377, 'Iglesia El Milagro', '', '', -28.449828600000000, -65.789839100000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(378, 'Plaza del Maestro', '', '', -28.460308800000000, -65.787768800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(379, 'Cristo', '', '', -28.168902600000000, -65.788008700000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(380, 'Gruta de la Virgen del Valle', '', '', -28.418603600000000, -65.799190200000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(381, 'Beato Mamerto Esquiú', '', '', -28.397458300000000, -65.701434000000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(382, 'Hotel de Turismo Santa Rita', '', '', -27.583208400000000, -66.310193300000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(383, 'Iglesia San Francisco de Asis', '', '', -27.582964500000000, -66.316159700000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(384, 'Camping La Cañada', '', '', -27.587029700000000, -66.295835900000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(385, 'Hotel Aquasol', '', '', -27.575070500000000, -66.312759700000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(386, 'Balneario El Molino', '', '', -27.698888500000000, -67.167581800000000, '../img-catamarca/default.jpg', 3, 5, 'aprobado'),
(387, 'Balneario Concepcion', '', '', -28.677121800000000, -66.054588900000000, '../img-catamarca/default.jpg', 3, 6, 'aprobado'),
(388, 'Iglesia Concepción', '', '', -28.686645300000000, -66.066335300000000, '../img-catamarca/default.jpg', 1, 6, 'aprobado'),
(389, 'Bajada al rio', '', '', -28.163835900000000, -65.792783700000000, '../img-catamarca/default.jpg', 3, 4, 'aprobado'),
(390, 'Balneario', '', '', -28.745639100000000, -65.551578000000000, '../img-catamarca/default.jpg', 3, 17, 'aprobado'),
(391, 'Camping', '', '', -28.749116300000000, -65.546907900000000, '../img-catamarca/default.jpg', 24, 17, 'aprobado'),
(392, 'Hostal de Anquincila', '', '', -28.752775700000000, -65.547149900000000, '../img-catamarca/default.jpg', 22, 17, 'aprobado'),
(393, 'Capilla de San José', '', '', -28.746778000000000, -65.545936500000000, '../img-catamarca/default.jpg', 1, 17, 'aprobado'),
(394, 'Gruta Virgen', '', '', -28.748479500000000, -65.545900900000000, '../img-catamarca/default.jpg', 1, 17, 'aprobado'),
(395, 'Cabaña \"Don Hermete\"', '', '', -28.749275400000000, -65.547401800000000, '../img-catamarca/default.jpg', 27, 17, 'aprobado'),
(396, 'Asadores y Mesitas', '', '', -28.467328400000000, -65.716194500000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(397, 'Estanque para riego', '', '', -27.576393500000000, -67.617779000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(398, 'Estanque para riego', '', '', -27.576538500000000, -67.617756100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(399, 'Estanque para riego', '', '', -27.576297800000000, -67.617878500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(400, 'Agua del Mikilo', '', '', -27.627270400000000, -67.696057100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(401, 'Plaza de la Reforma', '', '', -28.459385900000000, -65.783142300000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(402, 'Plazoleta de los Indigenas', '', '', -26.696798800000000, -66.049213300000000, '../img-catamarca/default.jpg', 29, 13, 'aprobado'),
(403, 'Plazoleta Güemes', '', '', -26.687538000000000, -66.047797500000000, '../img-catamarca/default.jpg', 29, 13, 'aprobado'),
(404, 'Balneario', '', '', -28.061570600000000, -66.193321400000000, '../img-catamarca/default.jpg', 3, 11, 'aprobado'),
(405, 'Plaza de Valle Chico', '', '', -28.507207400000000, -65.819476900000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(406, 'Plaza San Jorge', '', '', -28.491131300000000, -65.788942600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(407, 'Balneario Rincon', '', '', -28.220831700000000, -66.142400900000000, '../img-catamarca/default.jpg', 3, 11, 'aprobado'),
(408, 'Plaza Saujil', '', '', -27.567032700000000, -67.615316100000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(409, 'Plaza 25 de Agosto', '', '', -28.476614400000000, -65.777353400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(410, 'FC Belgrano', '', '', -28.109124500000000, -65.616157400000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(411, 'FC Belgrano', '', '', -28.108394300000000, -65.614759300000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(412, 'FC Belgrano', '', '', -28.106991400000000, -65.613324700000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(413, 'FC Belgrano', '', '', -28.109817500000000, -65.617420800000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(414, 'FC Belgrano', '', '', -28.110885800000000, -65.618077300000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(415, 'FC Belgrano', '', '', -28.111723600000000, -65.618339000000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(416, 'FC Belgrano', '', '', -28.112545800000000, -65.619158700000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(417, 'FC Belgrano', '', '', -28.112929000000000, -65.620109500000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(418, 'FC Belgrano', '', '', -28.115294000000000, -65.630307100000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(419, 'Plaza 1 de Agosto', '', '', -26.584815300000000, -66.942162400000000, '../img-catamarca/default.jpg', 29, 5, 'aprobado'),
(420, 'plaza', '', '', -26.585166500000000, -66.942517200000000, '../img-catamarca/default.jpg', 29, 5, 'aprobado'),
(421, 'coquena', '', '', -26.585870200000000, -66.943199100000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(422, 'coquena', '', '', -26.585904500000000, -66.943053900000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(423, 'Embalse Las Tunas', '', '', -28.244149200000000, -65.376473600000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(424, 'Plaza Don Francisco', '', '', -28.465708300000000, -65.729055500000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(425, 'Plaza Crisanto Gómez', '', '', -28.467715900000000, -65.769088300000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(426, 'Plazoleta Congresal Centeno', '', '', -28.464699200000000, -65.784638000000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(427, 'Plazoleta Lucía Inés Favore', '', '', -28.432318500000000, -65.716077000000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(428, 'Paseo Las Moras', '', '', -28.279795600000000, -65.732732300000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(429, 'Plaza Virgen del Valle', '', '', -28.461297600000000, -65.783763800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(430, 'Plazoleta Brenda Micaela Gordillo', '', '', -28.427978100000000, -65.719122000000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(431, 'Messi, Maradona y la Copa del Mundo', '', '', -28.426271100000000, -65.724126600000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(432, 'Plaza Nuestros Niños', '', '', -28.495844400000000, -65.801646700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(433, 'Parque de los Vientos', '', '', -28.462049800000000, -65.812745300000000, '../img-catamarca/default.jpg', 11, 1, 'aprobado'),
(434, 'Portal Turistico Los Varela', '', '', -28.038177500000000, -65.824544800000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(435, 'Plaza Las Teleras', '', '', -27.149458800000000, -66.945920800000000, '../img-catamarca/default.jpg', 29, 5, 'aprobado'),
(436, 'Plaza Siro Libanesa', '', '', -28.463197400000000, -65.799805500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(437, 'Plaza', '', '', -28.282580600000000, -67.339666200000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(438, 'Plaza', '', '', -28.173059800000000, -67.464624400000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(439, 'Plaza', '', '', -28.282305200000000, -67.283948800000000, '../img-catamarca/default.jpg', 29, 14, 'aprobado'),
(440, 'Parroquia de San Isidro Labrador', '', '', -28.458498600000000, -65.725109700000000, '../img-catamarca/default.jpg', 1, 15, 'aprobado'),
(441, 'Oratorio del Niño Jesús', '', '', -28.436607500000000, -65.719802000000000, '../img-catamarca/default.jpg', 3, 15, 'aprobado'),
(442, 'parque de Asís', '', '', -28.394095400000000, -65.704245700000000, '../img-catamarca/default.jpg', 11, 16, 'aprobado'),
(443, 'plaza CCI', '', '', -28.385790500000000, -65.703049200000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(444, 'Plazoleta del Niño', '', '', -28.475505400000000, -65.787227900000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(445, 'Hotel Don Oresttes', '', '', -28.365537200000000, -65.707754800000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(446, 'Casa de la Cultura', '', '', -28.469882600000000, -65.779183800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(447, 'Cabañas Valle Hermoso', '', '', -27.388148000000000, -65.982217200000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(448, 'Casa del Coronel Daza', '', '', -28.448211000000000, -65.733085100000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(449, 'Parroquia Santuario de San Roque', '', '', -28.460510900000000, -65.752546600000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(450, 'Chullpas', '', '', -27.121185000000000, -68.663352100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(451, 'WP 3', '', '', -27.209765900000000, -68.574603200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(452, 'Pabellón del Arenal', '', '', -27.141351000000000, -68.445857200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(453, 'WP 2', '', '', -27.214616400000000, -68.563290400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(454, 'Olmedo', '', '', -27.207225900000000, -68.525917500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(455, 'Walter Penck', '', '', -27.195872500000000, -68.561042000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(456, 'WP4', '', '', -27.236013600000000, -68.578208100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(457, 'Pabellón Sur', '', '', -27.154945700000000, -68.446715500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(458, 'Cerro Bonete', '', '', -27.638686400000000, -69.030887700000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(459, 'Cerro Salado o del Rio Salado', '', '', -27.263051600000000, -68.749373100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(460, 'Cerro Dos Hermanas (cumbre Norte)', '', '', -27.525579900000000, -68.987523000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(461, 'Morro Rasguido o Aguas Calientes', '', '', -27.247008300000000, -68.304248900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(462, 'Violado', '', '', -27.760875700000000, -68.976818100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(463, 'Cerro Ojo de Las Lozas', '', '', -27.107458700000000, -68.275505300000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(464, 'Sosa', '', '', -27.199382500000000, -68.356605600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(465, 'Dos Conos Oeste', '', '', -26.809219600000000, -68.303562200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(466, 'Cerro Laguna Escondida', '', '', -26.603511800000000, -68.479815000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(467, 'Cerro Dos Conos', '', '', -26.803640300000000, -68.277440800000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(468, 'Cerro Manantiales', '', '', -26.440733200000000, -68.361862200000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(469, 'Cerro Plegado', '', '', -25.981446700000000, -68.324344400000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(470, 'Alto Quebrada Honda', '', '', -25.632133900000000, -68.240493800000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(471, 'Cabañas Valle del Labrador', '', '', -28.455476500000000, -65.711005000000000, '../img-catamarca/default.jpg', 27, 15, 'aprobado'),
(472, 'Hosteria Valle Viejo', '', '', -28.452335300000000, -65.716503000000000, '../img-catamarca/default.jpg', 22, 15, 'aprobado'),
(473, 'Cabañas Valle Hermoso', '', '', -28.461036900000000, -65.702034800000000, '../img-catamarca/default.jpg', 27, 15, 'aprobado'),
(474, 'Cabañas Quinta Las Ruedas', '', '', -28.458118400000000, -65.704100200000000, '../img-catamarca/default.jpg', 27, 15, 'aprobado'),
(475, 'Hostería Nuestra Tierra', '', '', -28.460240700000000, -65.703333000000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(476, 'Finca El Recuerdo', '', '', -28.433742100000000, -65.721619800000000, '../img-catamarca/default.jpg', 27, 15, 'aprobado'),
(477, 'Cabañas El Aquí', '', '', -28.500937100000000, -65.662735400000000, '../img-catamarca/default.jpg', 27, 15, 'aprobado'),
(478, 'Cabañas Las Catalinas', '', '', -28.430444300000000, -65.712282300000000, '../img-catamarca/default.jpg', 27, 15, 'aprobado'),
(479, 'Hotel Pucará', '', '', -28.467717400000000, -65.786028900000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(480, 'Iglesia del Carmen y San José', '', '', -28.469943000000000, -65.782908800000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(481, 'Laguna', '', '', -28.408236800000000, -65.989954700000000, '../img-catamarca/default.jpg', 15, 6, 'aprobado'),
(482, 'Laguna pluvial 1', '', '', -28.481040200000000, -66.015869900000000, '../img-catamarca/default.jpg', 15, 6, 'aprobado'),
(483, 'Laguna pluvial 2', '', '', -28.481563300000000, -66.016180800000000, '../img-catamarca/default.jpg', 15, 6, 'aprobado'),
(484, 'Destino', '', '', -28.465700500000000, -65.778495500000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(485, 'Plaza', '', '', -27.093522400000000, -66.822051700000000, '../img-catamarca/default.jpg', 29, 5, 'aprobado'),
(486, 'Plazoleta Virgen del Valle', '', '', -27.712622400000000, -67.116297900000000, '../img-catamarca/default.jpg', 29, 5, 'aprobado'),
(487, 'Plazoleta San Jorge', '', '', -28.488127000000000, -65.782719100000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(488, 'Messi con la Copa del Mundo', '', '', -28.460711700000000, -65.762060300000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(489, 'Parque Lineal', '', '', -28.462697300000000, -65.772473500000000, '../img-catamarca/default.jpg', 11, 1, 'aprobado'),
(490, 'Plaza Los Ceibos', '', '', -28.431304700000000, -65.782129600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(491, 'Plaza Honduras', '', '', -28.468580000000000, -65.794694600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(492, 'Capilla Maria Auxiliadora', '', '', -28.467078300000000, -65.794103400000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(493, 'Plazoleta', '', '', -28.461988300000000, -65.798638000000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(494, 'Plaza José Ber Gelbard', '', '', -28.468915600000000, -65.812216800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(495, 'Plaza Crisólogo Larralde', '', '', -28.459393200000000, -65.797504300000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(496, 'Plazoleta Heroes de Malvinas', '', '', -26.703585400000000, -66.051289800000000, '../img-catamarca/default.jpg', 29, 13, 'aprobado'),
(497, 'Plazoleta Barrio San Agustin', '', '', -26.705055700000000, -66.051635700000000, '../img-catamarca/default.jpg', 3, 13, 'aprobado'),
(498, 'Plaza de Villa Cubas', '', '', -28.472949800000000, -65.790729500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(499, 'Plazoleta del Espíritu Santo', '', '', -28.480559200000000, -65.799510200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(500, 'Plazoleta 22 de Agosto', '', '', -28.477488100000000, -65.798758200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(501, 'Capilla Nuestra Señora de Lujan', '', '', -28.482569800000000, -65.799673800000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(502, 'Plaza Doctor Dermidio Herrera', '', '', -28.659291700000000, -65.785027000000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(503, 'Mirador Pampa de los Bayos', '', '', -26.224319200000000, -68.271622300000000, '../img-catamarca/default.jpg', 10, 3, 'aprobado'),
(504, 'Vega', '', '', -28.415603000000000, -66.040494400000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(505, 'Vega', '', '', -28.429799800000000, -66.036925700000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(506, 'Vega', '', '', -28.406813700000000, -66.040605200000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(507, 'Vega', '', '', -28.421226900000000, -66.045966400000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(508, 'Vega', '', '', -28.433742000000000, -66.039312400000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(509, 'Vega', '', '', -28.441747900000000, -66.040380100000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(510, 'Vega', '', '', -28.442105800000000, -66.033174700000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(511, 'Vega', '', '', -28.447469300000000, -66.037470500000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(512, 'Vega', '', '', -28.453873300000000, -66.033776200000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(513, 'Vega', '', '', -28.454553100000000, -66.029634300000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(514, 'Vega', '', '', -28.454156000000000, -66.027493000000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(515, 'Vega', '', '', -28.454743500000000, -66.031676500000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(516, 'Vega', '', '', -28.457710200000000, -66.031092700000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(517, 'Vega', '', '', -28.457354400000000, -66.032871200000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(518, 'Ciénaga', '', '', -28.486839500000000, -66.005680000000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(519, 'Ciénaga', '', '', -28.487527000000000, -66.005674700000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(520, 'Plaza de la Enfermera', '', '', -28.483027200000000, -65.791800200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(521, 'Plaza La Amistad', '', '', -28.483052600000000, -65.790214800000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(522, 'Plaza 25 de Mayo', '', '', -29.195779900000000, -65.437261200000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(523, 'Plaza Maestro Manuel Gerardo Cajal', '', '', -29.158087500000000, -65.400588100000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(524, 'Plaza', '', '', -29.109315300000000, -65.361171700000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(525, 'Plaza', '', '', -29.042816100000000, -65.352232500000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(526, 'Plaza Fray Esquiu', '', '', -28.915168900000000, -65.335592600000000, '../img-catamarca/default.jpg', 29, 8, 'aprobado'),
(527, 'Plaza San Cayetano', '', '', -28.702430300000000, -65.600745200000000, '../img-catamarca/default.jpg', 29, 17, 'aprobado'),
(528, 'Plaza', '', '', -27.688571400000000, -65.923828700000000, '../img-catamarca/default.jpg', 29, 4, 'aprobado'),
(529, 'Plazoleta', '', '', -27.587024500000000, -65.988374800000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(530, 'Plaza Angelini', '', '', -28.460248800000000, -65.802475300000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(531, 'Plaza Ojo de Agua', '', '', -28.482979500000000, -65.803765500000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(532, 'Plaza Eva Perón', '', '', -28.450334400000000, -65.774667100000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(533, 'Parque Adán Quiroga', '', '', -28.452392200000000, -65.769692900000000, '../img-catamarca/default.jpg', 11, 1, 'aprobado'),
(534, 'Lagunita', '', '', -27.823758900000000, -65.726969700000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(535, 'Laguna del meandro', '', '', -27.857542800000000, -65.721154400000000, '../img-catamarca/default.jpg', 15, 10, 'aprobado'),
(536, 'Plaza General Manuel Belgrano', '', '', -28.457993300000000, -65.790336700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(537, 'Plaza Vida', '', '', -28.436238600000000, -65.764454600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(538, 'Plaza Nuestro Algarrobo', '', '', -28.435308000000000, -65.767176200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(539, 'Parroquía del Espíritu Santo', '', '', -28.434577100000000, -65.779527200000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(540, 'Residencial Comodoro', '', '', -28.468024200000000, -65.774598600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(541, 'Plaza Las Esquinas', '', '', -28.711808000000000, -65.766679600000000, '../img-catamarca/default.jpg', 29, 15, 'aprobado'),
(542, 'Plaza República de Chile', '', '', -28.453818200000000, -65.741352400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(543, 'Granja Educativa Municipal', '', '', -28.467807900000000, -65.746501500000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(544, 'Granja Educativa La Soñada', '', '', -28.494914100000000, -65.668019700000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(545, 'Iglesia Evangélica', '', '', -27.140645800000000, -66.943105500000000, '../img-catamarca/default.jpg', 1, 5, 'aprobado'),
(546, 'MUSEO MUNICIPAL', '', '', -27.142223900000000, -66.945363600000000, '../img-catamarca/default.jpg', 4, 5, 'aprobado'),
(547, 'HOSTERIA MUNICIPAL', '', '', -27.144293600000000, -66.944729600000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(548, 'VIRGEN DEL VALLE', '', '', -27.145793700000000, -66.944398400000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(549, 'VIRGEN DE LOS REMEDIOS', '', '', -27.150172400000000, -66.945966600000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(550, 'Plaza Hipólito Yrigoyen', '', '', -28.479493600000000, -65.783063100000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(551, 'Plazoleta Mario Dardo Aguirre', '', '', -28.483735000000000, -65.787526600000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(552, 'Hosteria El Bolson', '', '', -27.902277800000000, -65.879786100000000, '../img-catamarca/default.jpg', 22, 4, 'aprobado'),
(553, 'El Jumeal', '', '', -28.458389300000000, -65.808157200000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(554, 'Plazoleta Portal', '', '', -28.467142300000000, -65.822587400000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(555, 'Plaza Huayra Tawa', '', '', -28.467828400000000, -65.803965600000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(556, 'Plazoleta Cacique Chelemín', '', '', -28.475258200000000, -65.813174300000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(557, 'La Alameda', '', '', -28.469635700000000, -65.787272500000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(558, 'Plaza Villa Bosch', '', '', -28.455939900000000, -65.791174200000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(559, 'Plazoleta Divino Niño Jesús', '', '', -28.455532700000000, -65.793806000000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(560, 'Plaza Fray Mamerto Esquiú', '', '', -28.468428600000000, -65.819528900000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(561, 'Parque Guallatahuasí', '', '', -28.919904800000000, -65.327150900000000, '../img-catamarca/default.jpg', 11, 8, 'aprobado'),
(562, 'Plazoleta Simón Bolivar', '', '', -28.441733600000000, -65.763877700000000, '../img-catamarca/default.jpg', 29, 1, 'aprobado'),
(563, 'Cabañas VIP', '', '', -27.742391400000000, -67.550109100000000, '../img-catamarca/default.jpg', 27, 14, 'aprobado'),
(564, 'Bodega Artesanal', '', '', -28.055637300000000, -67.568338700000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(565, 'Hosteria Novel', '', '', -28.054068400000000, -67.568616200000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(566, 'Hostal Casagrande', '', '', -28.067016900000000, -67.567804000000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(567, 'Termas La Aguadita', '', '', -28.030601100000000, -67.665925700000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(568, 'Cerro de la Salamanca', '', '', -28.011202800000000, -68.413911800000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(569, 'Morro Amarillo', '', '', -28.173435300000000, -67.928972000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(570, 'Morro Grande', '', '', -28.234280700000000, -67.903574500000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(571, 'Camarín de la Virgen del Valle', '', '', -28.469031700000000, -65.780454600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(572, 'Antofalla Norte', '', '', -25.552686600000000, -67.917128900000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(573, 'Antofalla Sur', '', '', -25.574910300000000, -67.907248400000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(574, 'Monumento estilo precolombino', '', '', -28.461250900000000, -65.810540700000000, '../img-catamarca/default.jpg', 18, 1, 'aprobado'),
(575, 'El Mastil', '', '', -28.213389700000000, -65.872500000000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(576, 'Cerro Alto de Rumiarco', '', '', -26.744241800000000, -65.847307700000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(577, 'Morro Ñuñorco', '', '', -26.840233900000000, -65.902437100000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(578, 'Mini Camping Amanecer', '', '', -28.457456200000000, -65.843564300000000, '../img-catamarca/default.jpg', 24, 1, 'aprobado'),
(579, 'Cerro del Bolsón', '', '', -27.213103300000000, -66.093813200000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(580, 'Parroquia San Juan Bautista', '', '', -28.065696300000000, -67.565265000000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(581, 'Capilla Nuestra Señora de Andacollo', '', '', -27.942176800000000, -67.646606500000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(582, 'Oratorio de los Orquera', '', '', -27.957732700000000, -67.631266900000000, '../img-catamarca/default.jpg', 3, 14, 'aprobado'),
(583, 'Mayorazgo de Anillaco', '', '', -27.911353000000000, -67.614952400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(584, 'Capilla Nuestra Señora del Rosario', '', '', -27.911751400000000, -67.615208500000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(585, 'La Casa de Graciela', '', '', -27.690715300000000, -67.614636400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(586, 'Los Varela', '', '', -27.931480300000000, -65.872637100000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(587, 'Hotel Inti Huaico', '', '', -26.697658700000000, -66.048568300000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(588, 'Cristo Redentor', '', '', -27.529261400000000, -67.601762900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(589, 'Iglesia Nuestra Señora de la Caldelaria', '', '', -28.174133600000000, -66.211041200000000, '../img-catamarca/default.jpg', 1, 11, 'aprobado'),
(590, 'FB Administracion', '', '', -28.626632300000000, -65.911103400000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(591, 'Hospedaje San Jorge', '', '', -27.691034800000000, -67.618857000000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(592, 'Hostal Santa Rita', '', '', -27.693291100000000, -67.626704200000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(593, 'Oficina de Turismo de Fiambalá', '', '', -27.692376000000000, -67.619546200000000, '../img-catamarca/default.jpg', 25, 14, 'aprobado'),
(594, 'Museo del Hombre', '', '', -27.689201200000000, -67.616100300000000, '../img-catamarca/default.jpg', 4, 14, 'aprobado'),
(595, 'Hostal Las Dos A', '', '', -28.187273100000000, -65.792245100000000, '../img-catamarca/default.jpg', 22, 4, 'aprobado'),
(596, 'Restaurant Casa de Campo', '', '', -28.187865300000000, -65.783715400000000, '../img-catamarca/default.jpg', 20, 4, 'aprobado'),
(597, 'Inicio del Via Crucis', '', '', -28.187969900000000, -65.791095200000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(598, 'Katana (Cabañas)', '', '', -28.186150300000000, -65.786159800000000, '../img-catamarca/default.jpg', 27, 4, 'aprobado'),
(599, 'Museo Arqueológico La Puerta', '', '', -28.170263100000000, -65.791073400000000, '../img-catamarca/default.jpg', 4, 4, 'aprobado'),
(600, 'Parador', '', '', -28.076518900000000, -65.904370600000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(601, 'Museo de Bellas Artes Laureano Brizuela', '', '', -28.469680500000000, -65.782379900000000, '../img-catamarca/default.jpg', 4, 1, 'aprobado'),
(602, 'Museo Histórico', '', '', -28.471130100000000, -65.780696400000000, '../img-catamarca/default.jpg', 4, 1, 'aprobado'),
(603, 'Santuario San Roque', '', '', -26.801324500000000, -66.069224400000000, '../img-catamarca/default.jpg', 3, 13, 'aprobado'),
(604, 'Información Turística', '', '', -26.799555700000000, -66.068966400000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(605, 'Camping Municipal', '', '', -26.804910400000000, -66.073498500000000, '../img-catamarca/default.jpg', 24, 13, 'aprobado'),
(606, 'Iglesia Nuestra Señora de la Merced', '', '', -28.221436900000000, -66.143050600000000, '../img-catamarca/default.jpg', 1, 11, 'aprobado'),
(607, 'La Tunita', '', '', -28.905009200000000, -65.421085300000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(608, 'Capilla El Portezuelo', '', '', -28.469046700000000, -65.635128500000000, '../img-catamarca/default.jpg', 1, 15, 'aprobado'),
(609, 'Camping Municipal El Molino', '', '', -27.699861500000000, -67.165877900000000, '../img-catamarca/default.jpg', 24, 5, 'aprobado'),
(610, 'Cristo Redentor', '', '', -28.223292700000000, -65.867820500000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(611, 'Información Turística', '', '', -28.224483500000000, -65.875007200000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(612, 'Mirador Faldeo Cristo Redentor', '', '', -28.224038800000000, -65.870657400000000, '../img-catamarca/default.jpg', 10, 4, 'aprobado'),
(613, 'Muro de la Contemplación', '', '', -28.225552400000000, -65.874022500000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(614, 'Niquixao', '', '', -28.229550800000000, -65.874214100000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(615, 'Raices', '', '', -28.224907900000000, -65.875096500000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(616, 'Sol de Bienvenida', '', '', -28.225089300000000, -65.874850600000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(617, 'Cabañas Polideportivo Municipal', '', '', -28.230654500000000, -65.871040200000000, '../img-catamarca/default.jpg', 27, 4, 'aprobado'),
(618, 'Plaza de los niños - Mercado artesanal', '', '', -28.222700400000000, -65.875172300000000, '../img-catamarca/default.jpg', 29, 4, 'aprobado'),
(619, 'Cabeza de Piedra', '', '', -28.219179000000000, -65.874671000000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(620, '\"Pelada del Fraile\"', '', '', -28.222270800000000, -65.886943000000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(621, 'Capilla Virgen del Diable', '', '', -28.214975800000000, -65.872222300000000, '../img-catamarca/default.jpg', 1, 4, 'aprobado'),
(622, 'Hospedaje Santa Rosa', '', '', -28.215906300000000, -65.873109100000000, '../img-catamarca/default.jpg', 22, 4, 'aprobado'),
(623, 'Hostel El Rodeo Restaurant', '', '', -28.215960800000000, -65.872512100000000, '../img-catamarca/default.jpg', 20, 4, 'aprobado'),
(624, 'Mirador El Molino', '', '', -28.215353300000000, -65.872675200000000, '../img-catamarca/default.jpg', 10, 4, 'aprobado'),
(625, 'Dpto. \"Posada Juan Pablo\"', '', '', -28.212089500000000, -65.871876000000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(626, 'Seminario', '', '', -28.211601000000000, -65.869611700000000, '../img-catamarca/default.jpg', 3, 4, 'aprobado'),
(627, 'Hosteria Villafañez', '', '', -28.212041100000000, -65.872367900000000, '../img-catamarca/default.jpg', 6, 4, 'aprobado'),
(628, 'Hospedaje Casa de Elba', '', '', -28.212026100000000, -65.877273800000000, '../img-catamarca/default.jpg', 22, 4, 'aprobado'),
(629, 'Hospedaje Vidal', '', '', -28.212501200000000, -65.876912700000000, '../img-catamarca/default.jpg', 22, 4, 'aprobado'),
(630, 'a Las Mesaditas; a El Nogal Marcado', '', '', -28.217057200000000, -65.884259700000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(631, 'Dpto. \"La Casita Grande\"', '', '', -28.210329500000000, -65.877426500000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(632, 'Casa de las Franciscanas', '', '', -28.209370800000000, -65.877407700000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(633, 'Casa de Los Lurdistas', '', '', -28.208349100000000, -65.877783200000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(634, 'Obispado', '', '', -28.208614700000000, -65.878163900000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(635, 'a Las Cascaditas', '', '', -28.203566800000000, -65.883734300000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(636, 'a Los Pinos', '', '', -28.202441500000000, -65.881748000000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(637, 'Dpto. \"Bernardo Olmos\"', '', '', -28.205950100000000, -65.875521900000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(638, 'Departamentos Urbanus Suites', '', '', -28.470529800000000, -65.776913700000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(639, 'Hotel Catamarca Apart', '', '', -28.459390400000000, -65.780569500000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(640, 'Hotel Shincal II', '', '', -28.475936500000000, -65.771453700000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(641, 'Residencial Catamarca', '', '', -28.474941000000000, -65.775443700000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(642, 'Residencial Cerro', '', '', -28.474076000000000, -65.776571000000000, '../img-catamarca/default.jpg', 14, 1, 'aprobado'),
(643, 'Hostal San Martín', '', '', -28.469251400000000, -65.776398900000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(644, 'Hotel Conort', '', '', -27.583351800000000, -66.311463300000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(645, 'Residencial Galileo', '', '', -27.582761600000000, -66.314090600000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(646, 'Residencial Ayucaba', '', '', -27.581870000000000, -66.315779000000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(647, 'Cabañas El Tata', '', '', -27.583857900000000, -66.316460800000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(648, 'Cabañas Nogales del Huayco', '', '', -27.580958200000000, -66.319015300000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(649, 'Cabañas Alfonso I', '', '', -27.577368700000000, -66.314664200000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(650, 'Cabañas Aldea del Sol', '', '', -27.583315900000000, -66.312205000000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(651, 'Hostería Refugio del Minero', '', '', -27.349199800000000, -66.389485600000000, '../img-catamarca/default.jpg', 28, 16, 'aprobado'),
(652, 'Hotel Gran Pucará', '', '', -27.505621500000000, -66.021272000000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(653, 'Mirador', '', '', -26.055983200000000, -67.403476200000000, '../img-catamarca/default.jpg', 10, 3, 'aprobado'),
(654, 'Hostería Municipal Antofagasta de la Sierra', '', '', -26.062439700000000, -67.407133400000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(655, 'Museo Mineralógico', '', '', -26.062546600000000, -67.408630100000000, '../img-catamarca/default.jpg', 4, 3, 'aprobado'),
(656, 'Volcan Carluchi', '', '', -26.310151300000000, -67.393287100000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(657, 'Hotel Samay', '', '', -27.651406100000000, -67.025152000000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(658, 'Hotel Belén', '', '', -27.651413200000000, -67.024075200000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(659, 'Hotel Gomez', '', '', -27.648329700000000, -67.029660300000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(660, 'Virgen', '', '', -27.647107100000000, -67.036115000000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(661, 'Hotel Angélica', '', '', -27.653330000000000, -67.031131900000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(662, 'Condado de Huasan', '', '', -27.555439900000000, -66.322513000000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(663, 'Fabrica de aceite', '', '', -27.555286700000000, -66.322158800000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(664, 'Alojamiento Doña Pascuala', '', '', -26.060542800000000, -67.406960900000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(665, 'Via Crucis', '', '', -28.320473700000000, -66.134607800000000, '../img-catamarca/default.jpg', 99, 11, 'aprobado'),
(666, 'Termas de Fiambalá', '', '', -27.742346700000000, -67.550199700000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(667, 'Iglesia Inmaculada Concepción', '', '', -27.713152200000000, -67.152455700000000, '../img-catamarca/default.jpg', 1, 5, 'aprobado'),
(668, 'Termas de la Quebrada', '', '', -27.213203400000000, -66.865887600000000, '../img-catamarca/default.jpg', 8, 5, 'aprobado'),
(669, 'Termas los Nascimentos', '', '', -27.155651700000000, -66.759463400000000, '../img-catamarca/default.jpg', 8, 5, 'aprobado'),
(670, 'El Saltón', '', '', -27.865877500000000, -65.725777500000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(671, 'Peñón Bola', '', '', -28.628650800000000, -65.548250400000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(672, 'Hotel La Aguada', '', '', -28.542214900000000, -65.886138200000000, '../img-catamarca/default.jpg', 22, 6, 'aprobado'),
(673, 'Iglesia Jesus De La Divina Miserdicordia', '', '', -28.468652300000000, -65.760693800000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(674, 'Monumento a Felipe Varela', '', '', -28.453091500000000, -65.740750400000000, '../img-catamarca/default.jpg', 18, 1, 'aprobado'),
(675, 'Curva de los Ciclistas', '', '', -28.468202400000000, -65.734780200000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(676, 'Cabañas Municipal El Shincal', '', '', -27.699894400000000, -67.167850600000000, '../img-catamarca/default.jpg', 27, 5, 'aprobado'),
(677, 'Túneles de La Merced', '', '', -28.117647300000000, -65.640115900000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(678, 'Casa donde vivio María Soledad Morales', '', '', -28.444198400000000, -65.714776200000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(679, 'Monolito a Maria Soledad', '', '', -28.448011800000000, -65.731829800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(680, 'Museo comunitario de Barranca Larga', '', '', -26.987883200000000, -66.738064500000000, '../img-catamarca/default.jpg', 3, 5, 'aprobado'),
(681, 'Cerro Cumbre del Durazno', '', '', -28.379323000000000, -65.952154200000000, '../img-catamarca/default.jpg', 14, 6, 'aprobado'),
(682, 'Cerro Blanco', '', '', -26.782252200000000, -67.757593600000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(683, 'Difunta Correa', '', '', -25.740873600000000, -67.248141300000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(684, 'El Mirador', '', '', -28.475842800000000, -65.618903000000000, '../img-catamarca/default.jpg', 10, 15, 'aprobado'),
(685, 'Hosteria El Peñon', '', '', -26.479557100000000, -67.265126100000000, '../img-catamarca/default.jpg', 22, 3, 'aprobado'),
(686, 'Difunta Correa', '', '', -26.854675000000000, -66.746706700000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(687, 'camping municipal', '', '', -26.882902700000000, -66.102512800000000, '../img-catamarca/default.jpg', 24, 13, 'aprobado'),
(688, 'Iglesia Barrio Eva Perón', '', '', -28.449922700000000, -65.775070500000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(689, 'Iglesia San Roque Gonzalez de la Santa Cruz', '', '', -28.441087400000000, -65.768534700000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(690, 'Cerro El Manchao', '', '', -28.254992600000000, -66.035016100000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(691, 'Zona de Expectadores 1 - Dakar 2014', '', '', -27.723301000000000, -67.020897100000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(692, 'Zona de Expectadores - Dakar 2014', '', '', -27.032626000000000, -66.492703100000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(693, 'Zona de Expectadores 3 - Dakar 2014', '', '', -27.011429800000000, -66.392550200000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(694, 'Zona de Expectadores 4 - Dakar 2014', '', '', -26.987969600000000, -66.277464200000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(695, 'Curva de la Chacarita', '', '', -28.459534700000000, -65.750321600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(696, 'General José de San Martín', '', '', -28.468925900000000, -65.779014900000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(697, 'Complejo Minero Muschaca', '', '', -27.552352500000000, -66.416384300000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(698, 'La Iglesia de Jesucristo de los Santos de los Últimos Días', '', '', -28.475010400000000, -65.780316100000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(699, 'Capilla', '', '', -28.426578600000000, -65.730748400000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(700, 'Lo De Angelita', '', '', -28.207619400000000, -65.878015800000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(701, 'Ex Zoologico de San Antonio', '', '', -28.420094900000000, -65.694300300000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(702, 'Grutita', '', '', -27.880880600000000, -65.706889100000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(703, 'Cerro Aguas Dulces', '', '', -26.288333800000000, -68.204333100000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(704, 'Cerro Vallecito', '', '', -26.210396400000000, -68.317066200000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(705, 'Cruz', '', '', -28.424625500000000, -65.755199100000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(706, 'Ñokapa Muskoiqui', '', '', -26.692142000000000, -66.065058400000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(707, 'Virgencita', '', '', -28.309076100000000, -65.808880200000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(708, 'Cabañas Aire de los Andes', '', '', -27.691040900000000, -67.619839900000000, '../img-catamarca/default.jpg', 27, 14, 'aprobado'),
(709, 'Hosteria', '', '', -28.508139700000000, -65.954513700000000, '../img-catamarca/default.jpg', 22, 6, 'aprobado'),
(710, 'Cara de piedra', '', '', -28.412051800000000, -65.665295300000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(711, 'Cueva de Cubas', '', '', -28.221391700000000, -65.791141000000000, '../img-catamarca/default.jpg', 16, 4, 'aprobado'),
(712, 'Hostel \"Familia Avar Saracho\" En Construcción', '', '', -27.670349800000000, -67.033981700000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(713, 'Montículo Ceremonial', '', '', -27.686726600000000, -67.180095200000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(714, 'Montículo Ceremonial', '', '', -27.686430100000000, -67.176502900000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(715, 'La Mesadita', '', '', -28.217331000000000, -65.886833200000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(716, 'Iglesia de Fatima', '', '', -27.692104600000000, -67.618350700000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(717, 'Hostel San Pedro Fiambala', '', '', -27.689898100000000, -67.619214100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(718, 'Camping Don Chochita', '', '', -27.695389200000000, -67.627532000000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(719, 'Camping / Hostal El Faro', '', '', -28.152154000000000, -65.792857200000000, '../img-catamarca/default.jpg', 24, 4, 'aprobado'),
(720, 'Puesto La Silleta', '', '', -28.110287000000000, -65.961785500000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(721, 'Cerro Ojo Antofalla', '', '', -25.448333800000000, -68.093435300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(722, 'Cerro Conito Antofalla', '', '', -25.511470300000000, -67.812799500000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(723, 'Cerro Lila', '', '', -25.556608300000000, -68.073676300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(724, 'Cerro Bayo', '', '', -26.397696700000000, -68.262044400000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(725, 'Inicio Sendero El Benteveo', '', '', -28.956212100000000, -65.380200300000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(726, 'Cerro El Jote', '', '', -26.340277100000000, -67.366565100000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(727, 'Apart Hotel El Algarrobo', '', '', -26.695463200000000, -66.046049500000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(728, 'Información Turística', '', '', -26.695343000000000, -66.047473500000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(729, 'Museo Arqueológico Eric Boman', '', '', -26.695387700000000, -66.047622600000000, '../img-catamarca/default.jpg', 4, 13, 'aprobado'),
(730, 'Complejo Turistico Margarita Palacios', '', '', -26.697815100000000, -66.041861300000000, '../img-catamarca/default.jpg', 24, 13, 'aprobado'),
(731, 'Albergue Gimnasio', '', '', -26.692982300000000, -66.048053000000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(732, 'Hotel Amancay', '', '', -26.694530000000000, -66.047309800000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(733, 'Hotel del Valle', '', '', -26.701621500000000, -66.050728700000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(734, 'Monumento a la Pachamama', '', '', -26.682178400000000, -66.044672200000000, '../img-catamarca/default.jpg', 18, 13, 'aprobado'),
(735, 'Hostel Camping El Sol', '', '', -26.676386800000000, -66.046862100000000, '../img-catamarca/default.jpg', 24, 13, 'aprobado'),
(736, 'Salón del Reino de los Testigos de Jehová', '', '', -29.277799400000000, -65.060525800000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(737, 'Capilla Santa Rita de Cascia', '', '', -28.041660100000000, -67.585862600000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(738, 'Iglesia Santa Rosa de Lima', '', '', -28.036582200000000, -67.589210600000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(739, 'Virgen del Valle', '', '', -28.487390800000000, -65.672179400000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(740, 'Capilla', '', '', -28.085965900000000, -65.900925500000000, '../img-catamarca/default.jpg', 1, 4, 'aprobado'),
(741, 'Hospedaje Punita', '', '', -26.475274200000000, -67.264792300000000, '../img-catamarca/default.jpg', 22, 3, 'aprobado'),
(742, 'Cumbres Sierras Coloradas', '', '', -28.310202500000000, -65.888046600000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(743, 'Hosteria Cel Kay', '', '', -27.700044100000000, -67.628169200000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(744, 'Hosteria Municipal Juan Chelemin', '', '', -27.221485900000000, -66.832201700000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(745, 'Hosteria Pirucha', '', '', -26.984815500000000, -66.738837300000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(746, 'Mini Hosteria de las Termas de Fiambalá', '', '', -27.744259800000000, -67.558723400000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(747, 'Camping Los Alamitos', '', '', -27.744521800000000, -67.557079100000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(748, 'Hito XV-24', '', '', -26.065976400000000, -68.404354700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(749, 'Cabaña de montaña', '', '', -28.202046800000000, -65.879927900000000, '../img-catamarca/default.jpg', 27, 4, 'aprobado'),
(750, 'Cerro de Los Aparejos', '', '', -27.706961600000000, -68.422517100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(751, 'Lampallo Sur', '', '', -27.286790900000000, -68.194249500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado');
INSERT INTO `lugares_turisticos` (`id`, `nombre`, `descripcion`, `direccion`, `lat`, `lng`, `imagen`, `id_categoria`, `id_departamento`, `estado`) VALUES
(752, 'Quemadito o Navidad', '', '', -27.348486300000000, -68.233592100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(753, 'Cerro de Lagunas Frias', '', '', -27.511357400000000, -68.385908900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(754, 'Cerro de la Coipa', '', '', -27.625264200000000, -68.297636000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(755, 'Tramontana', '', '', -27.562307500000000, -68.067817300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(756, 'Cerro Negro de La Laguna Verde', '', '', -27.707107100000000, -68.545312400000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(757, 'Viejo Castillo', '', '', -27.694816900000000, -68.699162100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(758, 'Cerro Lampallo o Agua Caliente', '', '', -27.234687700000000, -68.175803900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(759, 'Pico Cortaderas', '', '', -27.539390100000000, -68.172530300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(760, 'Altar del Pissis', '', '', -27.752010300000000, -68.855206800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(761, 'Sierra Pintada', '', '', -27.469481700000000, -68.467439800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(762, 'Cerro de Tres Quebradas', '', '', -27.472680100000000, -68.771108800000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(763, 'Cerrito Peñas Negras', '', '', -27.892799800000000, -68.356754800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(764, 'Cerro Aguada de Quirquinchos', '', '', -27.781510700000000, -68.204038400000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(765, 'Cerro Bayo', '', '', -27.740828700000000, -68.218089100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(766, 'Cerro Blanco', '', '', -27.704985400000000, -68.267899000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(767, 'Cerro Cordero', '', '', -27.942992100000000, -68.449143200000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(768, 'Cerro Los Taros', '', '', -27.948112400000000, -68.158227900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(769, 'Cerro Toro', '', '', -27.936030700000000, -68.236762300000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(770, 'Cerro Tostado Negro', '', '', -27.867712300000000, -68.270537900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(771, 'Cerro de Los Caranchos', '', '', -27.852093900000000, -68.201657500000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(772, 'Filo de los Asadores', '', '', -27.879733100000000, -68.397325600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(773, 'Cerro El Iruchal', '', '', -27.789124500000000, -67.959667400000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(774, 'Cerro Los Mellizos', '', '', -27.985039700000000, -68.360617400000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(775, 'Cerro Los Negros de Chas Chuil', '', '', -27.870422800000000, -68.079213900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(776, 'Cerro Volcán', '', '', -27.796150600000000, -68.433762800000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(777, 'Cerro de Las Flechas', '', '', -27.817979700000000, -67.951902200000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(778, 'Cerro Ojo de Pillahuasi', '', '', -27.792741100000000, -68.348527200000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(779, 'Cerro Morocho Chico', '', '', -27.020744900000000, -68.095542900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(780, 'Cerro del Matambre', '', '', -27.558634800000000, -68.285879600000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(781, 'Cerro Colorado', '', '', -26.949896800000000, -68.093743900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(782, 'Co. Morado', '', '', -27.425837100000000, -68.315412600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(783, 'Alojamento', '', '', -25.516661300000000, -67.618647300000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(784, 'Cerro Torres', '', '', -27.606602400000000, -67.865322600000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(785, 'Gris', '', '', -27.343446300000000, -68.626613800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(786, 'Cerro Colorado', '', '', -27.413747800000000, -67.975056800000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(787, 'Cerro Ojo de San Antonio', '', '', -27.476474300000000, -68.001492700000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(788, 'Cerro Palca', '', '', -27.153419000000000, -68.004152800000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(789, 'Mesada', '', '', -26.984528700000000, -67.992780800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(790, 'Alto Blanco', '', '', -27.244929300000000, -67.966945800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(791, 'Colorado', '', '', -27.389706500000000, -68.006427900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(792, 'Piedra Parada', '', '', -27.558532300000000, -68.012393200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(793, 'El Crucillo', '', '', -27.692448900000000, -68.086121700000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(794, 'Bayo Peak', '', '', -27.373520400000000, -68.464871100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(795, 'Cerro San Buenaventura', '', '', -26.993809900000000, -67.811831700000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(796, 'Cerro de la Hoyada', '', '', -26.841499500000000, -67.673650500000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(797, 'Chucula', '', '', -26.845250400000000, -67.969431600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(798, 'Cerro del Peñón', '', '', -25.287185400000000, -68.422655300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(799, 'Cerro Laguna Pedernal', '', '', -25.345086100000000, -68.290342800000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(800, 'Cerro Medano', '', '', -25.231396700000000, -68.231903600000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(801, 'Cerro de La Punta', '', '', -25.345804700000000, -68.405911000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(802, 'Alancay', '', '', -25.346573700000000, -68.191507000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(803, 'Cerro Cajeros', '', '', -25.628356700000000, -68.007846600000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(804, 'Cerro La Botijuela', '', '', -25.636260100000000, -67.923224700000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(805, 'Cerro Onas', '', '', -25.445869800000000, -68.003566300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(806, 'Cerro Patos', '', '', -25.474219800000000, -68.090735000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(807, 'Cerro del Medio', '', '', -25.352179900000000, -67.965987000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(808, 'Cerro Abra Grande', '', '', -25.461049400000000, -68.297478900000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(809, 'Cerro Negro', '', '', -25.473658100000000, -67.884870300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(810, 'Cerro Laguna Amarga', '', '', -26.604821100000000, -68.201223300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(811, 'Cerro El Borito', '', '', -26.402080600000000, -67.806321600000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(812, 'Cerro Incahuasi', '', '', -26.398124000000000, -67.774183700000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(813, 'Morro Ratones', '', '', -26.239895100000000, -67.836023100000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(814, 'Cerro del Hombre Muerto', '', '', -25.542364400000000, -66.996075200000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(815, 'Cerro Ratones', '', '', -25.242693600000000, -66.879994600000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(816, 'Cerro Agua Caliente', '', '', -25.618695300000000, -66.969321000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(817, 'Cerro Mojónes', '', '', -25.654266100000000, -67.355793500000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(818, 'Hito XV-20', '', '', -26.318873200000000, -68.565672500000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(819, 'Cerro Colorado O Diablillos', '', '', -25.306423300000000, -66.801220700000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(820, 'Cerro Incahuasi', '', '', -25.298929900000000, -66.561537000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(821, 'Barranquillas', '', '', -25.355656700000000, -66.733154800000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(822, 'Pico de Concha Argolla', '', '', -25.717279800000000, -67.000948200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(823, 'Cerro Galán', '', '', -25.939164100000000, -66.920619200000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(824, 'Cerro Vicuñorco', '', '', -25.913158400000000, -66.853397100000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(825, 'Cerro Colorado', '', '', -25.932747800000000, -67.087415500000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(826, 'Cerro Colorado', '', '', -26.043883300000000, -67.170831900000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(827, 'Cerro León Muerto', '', '', -26.117431600000000, -66.855860700000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(828, 'Cerro Pabellón', '', '', -26.128962500000000, -66.975532100000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(829, 'Cerro Alto Aspero Vaca Corral', '', '', -26.260972800000000, -66.541937600000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(830, 'Cerro Alto del Mulato', '', '', -26.270446000000000, -66.650046300000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(831, 'Cerro Laguna Blanca', '', '', -26.393203900000000, -67.060383000000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(832, 'Cerro Ojo del Chusco', '', '', -26.404986400000000, -66.874284000000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(833, 'Cerro Laguna Blanca(s)', '', '', -26.530281200000000, -67.058517200000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(834, 'Cerro Abra de Caja', '', '', -26.598540400000000, -66.730350000000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(835, 'Cerro Listas Negras', '', '', -26.661865900000000, -66.861358900000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(836, 'Cerro Pabellón', '', '', -26.505220000000000, -66.830380900000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(837, 'Cerro Corralito', '', '', -26.716818700000000, -66.780755800000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(838, 'Cerro Punta Grande', '', '', -26.612577400000000, -66.952739700000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(839, 'Cerro Bayo', '', '', -25.566770600000000, -67.753287100000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(840, 'Cerro El Colorado', '', '', -25.605808700000000, -67.544471700000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(841, 'Cerro Onas', '', '', -25.535761800000000, -67.707473500000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(842, 'Cerro de Los Colorados', '', '', -25.520177100000000, -67.415676600000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(843, 'Cerro de Marai', '', '', -25.438883600000000, -67.401786300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(844, 'Cerro Alto Calalaste', '', '', -25.716433300000000, -67.552178900000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(845, 'Cerro Alto de Los Colorados', '', '', -25.938595800000000, -68.066825900000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(846, 'Cerro Acazoque', '', '', -25.336803100000000, -67.376766400000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(847, 'Cerro Cortadera', '', '', -25.247750800000000, -67.385463200000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(848, 'Cerro Bola', '', '', -25.881423300000000, -67.274186400000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(849, 'Cerro Colorado', '', '', -26.118327700000000, -67.462437200000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(850, 'Cerro Miriguaca', '', '', -25.951306200000000, -67.284877300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(851, 'Loma Palca', '', '', -26.069705200000000, -67.324730200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(852, 'Iglesia San Antonio de Padua', '', '', -28.423809500000000, -65.704564300000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(853, 'Gruta de San Isidro Labrador', '', '', -28.063126600000000, -65.496398300000000, '../img-catamarca/default.jpg', 1, 12, 'aprobado'),
(854, 'Iglesia San Nicolas de Bari', '', '', -28.430735000000000, -65.694535500000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(855, 'termas Aguas Caliente', '', '', -25.545685700000000, -68.427739000000000, '../img-catamarca/default.jpg', 8, 3, 'aprobado'),
(856, 'Mirador Parinas', '', '', -25.789905900000000, -68.459397900000000, '../img-catamarca/default.jpg', 10, 3, 'aprobado'),
(857, 'Portal de la ciudad', '', '', -28.457674800000000, -65.769878500000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(858, 'Portal de la ciudad', '', '', -28.457676800000000, -65.770122800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(859, 'Casa de Piedra Cabañas', '', '', -26.060309500000000, -67.406857900000000, '../img-catamarca/default.jpg', 27, 3, 'aprobado'),
(860, 'Camping Los Túneles', '', '', -28.118788800000000, -65.642777300000000, '../img-catamarca/default.jpg', 24, 10, 'aprobado'),
(861, 'Mogote Verde', '', '', -28.794894900000000, -66.269803000000000, '../img-catamarca/default.jpg', 14, 6, 'aprobado'),
(862, 'Cerro Colorada', '', '', -28.695915800000000, -66.300291500000000, '../img-catamarca/default.jpg', 14, 6, 'aprobado'),
(863, 'Mogote La Aspereza', '', '', -28.684322000000000, -66.222904200000000, '../img-catamarca/default.jpg', 14, 6, 'aprobado'),
(864, 'Cerro de Mazan', '', '', -28.617324300000000, -66.472700800000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(865, 'Mogote de La Cordillera', '', '', -28.763282300000000, -66.326574100000000, '../img-catamarca/default.jpg', 14, 6, 'aprobado'),
(866, 'Cerro Pabellón', '', '', -28.306493200000000, -65.970744600000000, '../img-catamarca/default.jpg', 14, 4, 'aprobado'),
(867, 'Cerro Tres Cerros', '', '', -28.061029400000000, -66.056113200000000, '../img-catamarca/default.jpg', 14, 4, 'aprobado'),
(868, 'Cerro Los Dormidos', '', '', -28.079152700000000, -66.059592700000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(869, 'Cerro Joyango', '', '', -28.077281000000000, -66.094235400000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(870, 'Cerro Alto', '', '', -28.172302500000000, -66.037968200000000, '../img-catamarca/default.jpg', 14, 4, 'aprobado'),
(871, 'Cerro Nievas', '', '', -28.299239500000000, -66.089575800000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(872, 'Cerro de La Estancia', '', '', -28.245182400000000, -66.104572300000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(873, 'Cerro Aspero', '', '', -28.344460600000000, -67.845572900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(874, 'Morro de Lindero Colorado', '', '', -28.211244400000000, -67.898551900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(875, 'Cerro El Tantana', '', '', -28.159370000000000, -67.856239600000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(876, 'Cerro Blanco', '', '', -28.071085700000000, -67.886138400000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(877, 'Cerro de La Minita', '', '', -28.048469600000000, -67.921273200000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(878, 'Cerro de La Cruz', '', '', -28.124124500000000, -68.127591100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(879, 'Cerro Pabellón Grande', '', '', -28.078220600000000, -68.254692100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(880, 'Cerro Aspero', '', '', -28.028458900000000, -67.229782100000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(881, 'Cerro de Las Animas', '', '', -28.025588100000000, -67.350678900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(882, 'Cerro de Los Ramblones', '', '', -28.045121300000000, -67.363071700000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(883, 'Cerro de Las Mulas', '', '', -27.849554700000000, -67.273430100000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(884, 'Cerro Fraile', '', '', -27.658235700000000, -67.348397500000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(885, 'Cerro Negro', '', '', -27.829386800000000, -67.454883600000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(886, 'Cerro Pabellón', '', '', -27.777084400000000, -67.508800000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(887, 'Cerro Pelado', '', '', -27.872278000000000, -67.567226900000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(888, 'Cerro Morteros', '', '', -27.835114500000000, -67.581335100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(889, 'Cerro Punta Colorada', '', '', -27.692935800000000, -67.943594000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(890, 'Cerro El Delgadito', '', '', -27.079907400000000, -67.643627600000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(891, 'Cerro Nevado del Candado', '', '', -27.323685400000000, -66.188960300000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(892, 'Cerro de Las Dos Lagunas O De Los Cóndores', '', '', -27.250648600000000, -66.134490700000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(893, 'Cerro Negro', '', '', -27.341390900000000, -66.267900500000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(894, 'Cerro El Durazno', '', '', -27.262252900000000, -66.523495200000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(895, 'Cerro Quemado', '', '', -27.512538900000000, -66.632884000000000, '../img-catamarca/default.jpg', 14, 16, 'aprobado'),
(896, 'Cerro Pampa', '', '', -27.425441000000000, -66.809281100000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(897, 'Morro de Ampujaco', '', '', -27.429148900000000, -66.716166000000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(898, 'Cerro Bayo', '', '', -27.484269300000000, -66.846760500000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(899, 'Cerro El Durazno', '', '', -27.303145500000000, -67.069756300000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(900, 'Cerro de La Laguna Verde', '', '', -27.096598600000000, -65.985275000000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(901, 'Cerro Negro', '', '', -27.100097900000000, -66.026340000000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(902, 'Morro Ñuñorco de San Juan', '', '', -26.794321400000000, -65.882847800000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(903, 'Morro de Los Venados', '', '', -26.956729700000000, -65.932355900000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(904, 'Cerro Pabellón Blanco', '', '', -27.022411400000000, -66.605811600000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(905, 'Cerro El Sorochal', '', '', -27.083242400000000, -66.714301600000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(906, 'Cerro León Muerto', '', '', -27.022466500000000, -66.927926100000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(907, 'Médano de Santa María', '', '', -26.688660000000000, -66.193602600000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(908, 'Morro de La Trampa', '', '', -26.747580300000000, -66.197947300000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(909, 'Cerro Alto de Los Torres', '', '', -26.722809000000000, -66.150620500000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(910, 'Cerro Alto de Las Campanas', '', '', -26.776231900000000, -66.143363500000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(911, 'Cerro Alto de Los Palacios', '', '', -26.782341300000000, -66.199144400000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(912, 'Morro Rasguñado', '', '', -26.857479300000000, -66.183578500000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(913, 'Cerro Trampeadero', '', '', -26.871386500000000, -66.205641700000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(914, 'Morro Azul', '', '', -26.918306800000000, -66.189604300000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(915, 'Cerro del Antigal', '', '', -26.938542700000000, -66.167355800000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(916, 'Morro Blanco', '', '', -26.961643600000000, -66.195371900000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(917, 'Cerro Alto del Mendocino', '', '', -26.925828300000000, -66.203433000000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(918, 'Loma de Los Pabellones', '', '', -26.860032900000000, -66.361396800000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(919, 'Loma Chiquero', '', '', -26.838658300000000, -66.348050100000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(920, 'Cerro San Francisco', '', '', -26.632926500000000, -66.183672900000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(921, 'Loma de La Quebrada', '', '', -26.692477200000000, -66.455086700000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(922, 'Cerro Aguadita del Tolar', '', '', -26.637616100000000, -66.382276100000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(923, 'Cerro Alto del Remate', '', '', -26.534027000000000, -66.165835900000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(924, 'Morro Blanco', '', '', -26.502636700000000, -66.231593100000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(925, 'Cerro El Mollar', '', '', -26.546362200000000, -66.469303100000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(926, 'Cerro Abra Quemada', '', '', -26.524857600000000, -66.381624700000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(927, 'Loma Colorada', '', '', -26.532870900000000, -66.721630100000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(928, 'Cerro Reventón Blanco', '', '', -26.729303900000000, -66.521930900000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(929, 'Cerro Bayo del Volcán', '', '', -26.723577000000000, -66.540650400000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(930, 'Cerro Olla Quebrada', '', '', -26.609260400000000, -66.530349000000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(931, 'Cerro La Tipa', '', '', -26.640820400000000, -66.531271000000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(932, 'Cerro Aspero Solo', '', '', -26.665353300000000, -66.526728600000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(933, 'Cerro Tipa', '', '', -26.659529600000000, -66.594350800000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(934, 'Cerro Laguna Verde', '', '', -26.620652000000000, -66.646441900000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(935, 'Cerro Bayo Grande', '', '', -26.731816200000000, -66.656519200000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(936, 'Cerro Ojo Bramador', '', '', -26.765068000000000, -66.659965500000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(937, 'Cerro Bayo Chico', '', '', -26.776808800000000, -66.643424500000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(938, 'Cerro Manijita', '', '', -26.785788000000000, -66.647157700000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(939, 'Cerro Chango Real', '', '', -26.831789200000000, -66.604690600000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(940, 'Cerro Cienaga Pelada', '', '', -26.854718400000000, -66.638560500000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(941, 'Cerro Punta Grande', '', '', -26.943021400000000, -66.575454700000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(942, 'Médano del Medano', '', '', -26.979171500000000, -66.678928400000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(943, 'Cerro Loma Corral', '', '', -26.844172100000000, -66.674576000000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(944, 'Cerro Rincón Grande', '', '', -26.789131300000000, -66.740312100000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(945, 'Cerro Negro', '', '', -26.929167100000000, -66.835079200000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(946, 'Cerro Sorocho', '', '', -26.882223600000000, -66.828558200000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(947, 'Cerro Medano Blanco', '', '', -26.859889100000000, -66.837271700000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(948, 'Cerro Campo', '', '', -26.833449000000000, -66.813615800000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(949, 'Morro El Chorro', '', '', -26.530989400000000, -66.938933400000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(950, 'Morro Cóndorhuasi', '', '', -26.989106400000000, -66.944090800000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(951, 'Cerro La Lunareja', '', '', -26.827462200000000, -67.044098900000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(952, 'Cerro Alto del Chiquerito', '', '', -26.762278100000000, -67.026737700000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(953, 'Cerro Bayo', '', '', -27.278684600000000, -67.208894300000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(954, 'Cerro Alto del Volcán', '', '', -27.395885000000000, -67.283440400000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(955, 'Cerro Negro', '', '', -27.313956100000000, -67.291081400000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(956, 'Cerro Pabellón', '', '', -27.085168300000000, -67.294751400000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(957, 'Cerro Alto de La Quebrada Honda', '', '', -27.082878900000000, -67.442966000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(958, 'Cerro Toronado', '', '', -26.911749700000000, -67.201534700000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(959, 'Cerro de Curuto', '', '', -26.720210800000000, -67.326519500000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(960, 'Cerro Morado', '', '', -26.833109800000000, -67.289544100000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(961, 'Cerro Calderón', '', '', -26.968762700000000, -67.358929600000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(962, 'Chucula / Negro Muerto', '', '', -26.767325500000000, -67.996975900000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(963, 'Cerro Pabellón', '', '', -26.794680600000000, -68.136375000000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(964, 'Cerro Situque', '', '', -26.124774700000000, -67.657293300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(965, 'Cerro Oire', '', '', -26.146123300000000, -67.729716800000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(966, 'Cerro Morado', '', '', -26.307833600000000, -67.600464800000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(967, 'Cerro Chascón', '', '', -26.585026800000000, -67.917867900000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(968, 'Cerro Cueros de Purulla', '', '', -26.552601000000000, -67.820168500000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(969, 'Cerro Blanco', '', '', -26.539642600000000, -67.840475100000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(970, 'Cerro Alto de Los Colorados', '', '', -25.936338100000000, -68.066926700000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(971, 'Médano Crugnios', '', '', -26.271890900000000, -66.303058600000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(972, 'Médano de Ambrosio', '', '', -26.234324500000000, -66.567398500000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(973, 'Médano del Abrigo', '', '', -26.220596300000000, -66.571859400000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(974, 'Médano de Chucha', '', '', -26.139337800000000, -66.185419100000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(975, 'Morro Ovejería', '', '', -26.356976600000000, -66.202400200000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(976, 'Cerro Espiadero', '', '', -26.375457000000000, -66.119892100000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(977, 'Loma del Medio', '', '', -26.266853300000000, -66.171941800000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(978, 'Cerro El Morado', '', '', -26.366954000000000, -66.258644100000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(979, 'Cerro Alto de Las Trojas', '', '', -26.315110800000000, -66.330188800000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(980, 'Pico Colorado', '', '', -26.296684400000000, -66.317325600000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(981, 'Cerro Chuscha', '', '', -26.146666000000000, -66.219330800000000, '../img-catamarca/default.jpg', 14, 13, 'aprobado'),
(982, 'Cerro Cienaga Pelada', '', '', -26.352892800000000, -66.541286900000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(983, 'Cerro El Derrumbe', '', '', -26.356867800000000, -66.734557200000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(984, 'Cerro Pumahuasi', '', '', -26.387968900000000, -66.626666100000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(985, 'Cerro Laguna Blanca', '', '', -26.393167700000000, -67.060414300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(986, 'Cerro Diamante', '', '', -25.791904300000000, -66.850032300000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(987, 'Monumento a la Mujer', '', '', -27.693667800000000, -67.626528000000000, '../img-catamarca/default.jpg', 18, 14, 'aprobado'),
(988, 'Cerro Gordo', '', '', -25.710132100000000, -66.649110700000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(989, 'Cerro Blanco', '', '', -25.524087700000000, -66.546727400000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(990, 'Médano del Cerro Blanco', '', '', -25.478295700000000, -66.533992800000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(991, 'Cerro Hoyada', '', '', -25.737643700000000, -67.194097800000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(992, 'Cerro Calalaste', '', '', -25.664445400000000, -67.434079600000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(993, 'Cerro Calalaste', '', '', -25.773851700000000, -67.570426900000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(994, 'Hostería Municipal de Fiambalá', '', '', -27.692090700000000, -67.620688300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(995, 'Fiesta en el Médano', '', '', -27.691950600000000, -67.607678600000000, '../img-catamarca/default.jpg', 17, 14, 'aprobado'),
(996, 'Hotel de Turismo', '', '', -28.066682500000000, -67.565393300000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(997, 'Santiago', '', '', -28.499243300000000, -65.430439700000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(998, 'Estancia La Huerta _ Flia. Cabral Los Pedraza', '', '', -28.498648600000000, -65.503988500000000, '../img-catamarca/default.jpg', 27, 9, 'aprobado'),
(999, 'Cementerio_ Los Pedraza', '', '', -28.500387800000000, -65.491031400000000, '../img-catamarca/default.jpg', 3, 9, 'aprobado'),
(1000, 'Selva Medina _ Los Pedraza', '', '', -28.514302200000000, -65.494387400000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1001, 'Negalisa Arebalo _ Los Pedraza', '', '', -28.503219200000000, -65.506276600000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1002, 'Fabian Arévalo', '', '', -28.508005300000000, -65.516306700000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1003, 'Vicente Arevalo- Los Pedraza', '', '', -28.495579400000000, -65.524388200000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1004, 'Gilo Carranza', '', '', -28.484530300000000, -65.787756300000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1005, 'Luchin', '', '', -28.484530500000000, -65.788206800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1006, '1-Santiago - Vilizman', '', '', -28.499246200000000, -65.430517700000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1007, '2-Mocha - Ancamugalla', '', '', -28.474816100000000, -65.431998100000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1008, 'El Lindero _ El Alto', '', '', -28.588853300000000, -65.522534300000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1009, 'La Piedra Aujereada - El Alto', '', '', -28.580449100000000, -65.545556800000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1010, 'Antenas repetidoras de radio y TV', '', '', -28.535498200000000, -65.610309500000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1011, 'Lili Carrizo_Los Nogales_ El Alto', '', '', -28.603985400000000, -65.525877300000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1012, 'La Trilla -El Alto', '', '', -28.566957400000000, -65.586116200000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1013, 'La Bebida-El Alto', '', '', -28.521632900000000, -65.602466500000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1014, 'Las Angostura - El Alto', '', '', -28.573406400000000, -65.579830400000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1015, 'Negalisa Arebalo _ Los Pedraza', '', '', -28.503389800000000, -65.506400400000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1016, 'Los Nogales', '', '', -28.794969400000000, -65.512876800000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(1017, 'Estancia La Loma Sola - El Alto', '', '', -28.558016500000000, -65.594962700000000, '../img-catamarca/default.jpg', 27, 9, 'aprobado'),
(1018, 'El Bolson _ El Alto', '', '', -28.591753100000000, -65.542891700000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1019, 'Cumbre', '', '', -28.498354800000000, -65.611541200000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1020, 'La Chacrita _ El Alto', '', '', -28.589542200000000, -65.546326400000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1021, 'Vilapa_ El Alto', '', '', -28.492887100000000, -65.541501400000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1022, 'Estancia El Gateao', '', '', -27.818088700000000, -65.896076100000000, '../img-catamarca/default.jpg', 27, 4, 'aprobado'),
(1023, 'Pepe Chazarreta_ El lindero', '', '', -28.590203400000000, -65.523532400000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1024, 'Porta Coronel _ los Nogales', '', '', -28.603115000000000, -65.525262700000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1025, 'Pedro Quiroga_ El lindero', '', '', -28.589324400000000, -65.521773800000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1026, 'Flia. Reynozo _Casa Armada_ Ancasti', '', '', -28.662734800000000, -65.518924700000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(1027, 'Empalme Rodeo Chiquico', '', '', -28.590813400000000, -65.490870500000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1028, 'Cenenterio _ Los Pedraza', '', '', -28.500150000000000, -65.491780900000000, '../img-catamarca/default.jpg', 3, 9, 'aprobado'),
(1029, 'Flia. Romero', '', '', -28.455596400000000, -65.708047600000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1030, 'La Huerta _ Flia Cabral Los Pedraza', '', '', -28.503012700000000, -65.503870500000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1031, 'Ancamugaya _ El Alto', '', '', -28.471877400000000, -65.440360000000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1032, 'Fabio Medina _ Los Pedraza', '', '', -28.513860100000000, -65.494740500000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1033, 'Selva Medina _ Los Pedraza', '', '', -28.513984100000000, -65.494271900000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1034, 'Capilla Santa Bernandita', '', '', -28.231263600000000, -65.761360200000000, '../img-catamarca/default.jpg', 1, 4, 'aprobado'),
(1035, 'Museo Arqueológico Municipal', '', '', -28.064693800000000, -67.565231900000000, '../img-catamarca/default.jpg', 4, 14, 'aprobado'),
(1036, 'Hito XV-21', '', '', -26.259624500000000, -68.515353800000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1037, 'Hito XV-22', '', '', -26.237351300000000, -68.477437500000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1038, 'Hito XV-23', '', '', -26.119816700000000, -68.393125800000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1039, 'Hito XV-19', '', '', -26.331731200000000, -68.567529900000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1040, 'Hito XV-16', '', '', -26.702155900000000, -68.437566100000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1041, 'Hito XV-17', '', '', -26.687424000000000, -68.448228400000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1042, 'Hito XV-18', '', '', -26.616740800000000, -68.499336500000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1044, 'Hito XV-14 Paso de San Francisco', '', '', -26.873699700000000, -68.299089200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1045, 'Nuestra seňora de Belén', '', '', -27.649309700000000, -67.027003400000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1046, 'Los Yucanes', '', '', -27.647983200000000, -67.026568800000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1047, 'Mirador Balcón del Pissis', '', '', -27.581966100000000, -68.539000000000000, '../img-catamarca/default.jpg', 10, 14, 'aprobado'),
(1048, 'Hotel de Campo Oeste Paraiso', '', '', -27.500545500000000, -66.982801700000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1049, 'Cabanas municipal', '', '', -28.093545000000000, -65.897098700000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1050, 'Familia Avar Saracho', '', '', -27.670039900000000, -67.032656600000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1051, 'Paso San Francisco', '', '', -27.586518400000000, -68.155587300000000, '../img-catamarca/default.jpg', 12, 14, 'aprobado'),
(1052, 'Paso San Francisco', '', '', -27.543777500000000, -68.139282500000000, '../img-catamarca/default.jpg', 12, 14, 'aprobado'),
(1053, 'Paso San Francisco', '', '', -26.911973200000000, -68.113745200000000, '../img-catamarca/default.jpg', 12, 14, 'aprobado'),
(1054, 'Paso San Francisco', '', '', -26.912187500000000, -68.113730600000000, '../img-catamarca/default.jpg', 12, 14, 'aprobado'),
(1055, 'Paso San Francisco', '', '', -27.668154500000000, -67.650996900000000, '../img-catamarca/default.jpg', 12, 14, 'aprobado'),
(1056, 'Paso San Francisco', '', '', -27.668346300000000, -67.651240200000000, '../img-catamarca/default.jpg', 12, 14, 'aprobado'),
(1057, 'Ruinas de Watungasta', '', '', -27.878634900000000, -67.681438200000000, '../img-catamarca/default.jpg', 18, 14, 'aprobado'),
(1058, 'hostal Las Parinas', '', '', -28.065630200000000, -67.562806800000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(1059, 'Ruinas de Watungasta', '', '', -27.878415100000000, -67.684526500000000, '../img-catamarca/default.jpg', 18, 14, 'aprobado'),
(1060, 'Hostal La Nona', '', '', -27.713505800000000, -67.134036700000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1061, 'Cabañas El Recuerdo', '', '', -27.664230100000000, -67.035937300000000, '../img-catamarca/default.jpg', 27, 5, 'aprobado'),
(1062, 'El Recuerdo', '', '', -27.664152600000000, -67.035897000000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1063, 'Turismo', '', '', -27.582549700000000, -66.315035900000000, '../img-catamarca/default.jpg', 25, 16, 'aprobado'),
(1064, 'Hospedaje Casa de Campo El Fortín', '', '', -27.493635900000000, -66.022222100000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(1065, 'Hospedaje Il Nono', '', '', -27.468865200000000, -66.010390200000000, '../img-catamarca/default.jpg', 22, 16, 'aprobado'),
(1066, 'Capilla Virgen del valle', '', '', -27.692570600000000, -67.625681900000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1067, 'Pesebre', '', '', -27.573899700000000, -67.619924200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1068, 'Iglesia de San Pedro', '', '', -27.714636900000000, -67.631132300000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1069, 'Cristo crucificado', '', '', -27.211292300000000, -67.599488000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1070, 'Mirador del vertedero del Dique Las Pirquitas', '', '', -28.274282400000000, -65.741047700000000, '../img-catamarca/default.jpg', 5, 16, 'aprobado'),
(1071, 'Camping Municipal de Salado', '', '', -28.305311800000000, -67.248618800000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1072, 'Virgen', '', '', -27.936531300000000, -65.876059200000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1073, 'Hostería Recreo', '', '', -29.277662000000000, -65.052843100000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(1074, 'salar', '', '', -25.490874700000000, -67.109295900000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1075, 'Residencial San Francisco', '', '', -28.066631700000000, -67.566565100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1076, 'Hotel Perez', '', '', -26.693479900000000, -66.050088600000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(1077, 'Geno', '', '', -28.474566800000000, -65.779712300000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1078, 'Hospedaje Las Cañas', '', '', -27.713606200000000, -67.151757700000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1079, 'Hostel b&b', '', '', -27.656942900000000, -67.032240200000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1080, 'Oficina de Turismo', '', '', -27.224914700000000, -66.835362400000000, '../img-catamarca/default.jpg', 25, 5, 'aprobado'),
(1081, 'Camping Agreste Pozo Verde', '', '', -27.216806200000000, -66.833364000000000, '../img-catamarca/default.jpg', 24, 5, 'aprobado'),
(1082, 'Chocolate', '', '', -28.446520300000000, -65.848274200000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1083, 'Cerro Negro', '', '', -25.480864100000000, -67.872585800000000, '../img-catamarca/default.jpg', 14, 3, 'aprobado'),
(1084, 'alquiler por dia', '', '', -28.441236400000000, -65.736091700000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1085, 'Hospedaje Lomas', '', '', -28.150452300000000, -65.657872600000000, '../img-catamarca/default.jpg', 22, 10, 'aprobado'),
(1086, 'Hospedaje Ruta 38', '', '', -28.850450900000000, -66.224946200000000, '../img-catamarca/default.jpg', 22, 6, 'aprobado'),
(1087, 'Policarpo', '', '', -27.505735100000000, -66.023024600000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1088, 'Puente destruido por el alud de El Rodeo (23 de enero de 2014)', '', '', -28.218963100000000, -65.877788400000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1089, 'Termas los Hornos', '', '', -26.878534000000000, -67.767696100000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(1090, 'Termas las Grutas', '', '', -26.922970300000000, -68.146377900000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1091, 'Morocho', '', '', -27.058613800000000, -68.151403900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1092, 'Duna Federico Kirbus', '', '', -27.563269600000000, -67.488638900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1093, 'Camping El Paraíso', '', '', -27.687607000000000, -67.624202500000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1094, 'Plaza', '', '', -27.581985900000000, -66.314480000000000, '../img-catamarca/default.jpg', 29, 16, 'aprobado'),
(1095, 'Hostal Pomanti', '', '', -28.393733800000000, -66.222405800000000, '../img-catamarca/default.jpg', 22, 11, 'aprobado'),
(1096, 'Rumi Huasi', '', '', -26.062599500000000, -67.408533300000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1097, 'Camping campestre Tata Bencho', '', '', -27.633280300000000, -67.024075900000000, '../img-catamarca/default.jpg', 24, 5, 'aprobado'),
(1098, 'Fabrica Artesanal de Alfombras', '', '', -28.447927500000000, -65.755855200000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1099, 'Ermita de Nuestra Señora del Valle', '', '', -28.457123100000000, -65.727313000000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1100, 'Villa San Ignacio', '', '', -27.663228900000000, -67.034867700000000, '../img-catamarca/default.jpg', 6, 5, 'aprobado'),
(1101, 'Hostal \"El Adonay\"', '', '', -27.648312800000000, -67.026466700000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1102, 'Residencial Güemes', '', '', -29.272445900000000, -65.057062800000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(1103, 'El Obelisco', '', '', -27.062064100000000, -66.856045200000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1104, 'Castillos de Villa Vil', '', '', -27.056234800000000, -66.861104100000000, '../img-catamarca/default.jpg', 6, 5, 'aprobado'),
(1105, 'Sitio Arqueológico Pozo Verde', '', '', -27.215763100000000, -66.832426900000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1106, 'Información Turística', '', '', -27.094848200000000, -66.822532100000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1107, 'Cabañas Dunas de Medanitos', '', '', -27.692616300000000, -67.623457900000000, '../img-catamarca/default.jpg', 27, 14, 'aprobado'),
(1108, 'Jesús', '', '', -27.334914700000000, -67.758037600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1109, 'refugio', '', '', -26.987182900000000, -67.782159100000000, '../img-catamarca/default.jpg', 28, 14, 'aprobado'),
(1110, 'El Globo', '', '', -27.354080900000000, -66.323547900000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1111, 'Ciudad Arqueologica de Mishma', '', '', -27.585743300000000, -67.688176500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1112, 'Capilla Santa Lucia', '', '', -26.952764300000000, -66.136396000000000, '../img-catamarca/default.jpg', 1, 13, 'aprobado'),
(1113, 'Hotel Las Caás', '', '', -27.712506000000000, -67.136077900000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1114, 'Las Cañas', '', '', -27.713774000000000, -67.149319900000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1115, 'Hotel Pola', '', '', -27.712012100000000, -67.135906200000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1116, 'Templo de San Juan Bautista', '', '', -27.712185500000000, -67.135393900000000, '../img-catamarca/default.jpg', 1, 5, 'aprobado'),
(1117, 'Museo Folklórico', '', '', -27.713018900000000, -67.151323600000000, '../img-catamarca/default.jpg', 4, 5, 'aprobado'),
(1118, 'Capilla', '', '', -26.988289000000000, -66.274916100000000, '../img-catamarca/default.jpg', 1, 13, 'aprobado'),
(1119, 'Finca La Victoria', '', '', -27.602044000000000, -65.973952000000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(1120, 'cabañas Arakuku', '', '', -28.013851300000000, -65.700989500000000, '../img-catamarca/default.jpg', 27, 10, 'aprobado'),
(1121, 'Cabañas Julumao', '', '', -27.585457700000000, -66.306113200000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(1122, 'Mirador del Dique Las Pirquitas', '', '', -28.239995400000000, -65.755697800000000, '../img-catamarca/default.jpg', 5, 4, 'aprobado'),
(1123, 'Turismo Catamarca', '', '', -28.592425700000000, -65.754866300000000, '../img-catamarca/default.jpg', 25, 15, 'aprobado'),
(1124, 'Complejo La Constancia', '', '', -28.181484500000000, -65.791607200000000, '../img-catamarca/default.jpg', 24, 4, 'aprobado'),
(1125, 'Mirador', '', '', -27.471015200000000, -66.394334400000000, '../img-catamarca/default.jpg', 10, 16, 'aprobado'),
(1126, 'Hotel del Valle', '', '', -26.701266100000000, -66.050908800000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(1127, 'Hito XV-5', '', '', -27.594860300000000, -69.030522100000000, '../img-catamarca/default.jpg', 99, 16, 'rechazado'),
(1128, 'Valle Ancho', '', '', -27.384376400000000, -68.896551100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1129, 'Hito XVI-5', '', '', -25.533259400000000, -68.543982800000000, '../img-catamarca/default.jpg', 99, 16, 'rechazado'),
(1130, 'Incahuasi', '', '', -26.060160800000000, -67.406815800000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1131, 'Hospedaje Vicky', '', '', -28.931913500000000, -65.096945500000000, '../img-catamarca/default.jpg', 22, 8, 'aprobado'),
(1132, 'Iglesia de San Antonio', '', '', -28.932407300000000, -65.097603700000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(1133, 'Cabañas Portal del Nevado', '', '', -27.503029200000000, -66.027652300000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(1134, 'Cabañas Mirador del Aconquija', '', '', -27.504738600000000, -66.024409500000000, '../img-catamarca/default.jpg', 10, 16, 'aprobado'),
(1135, 'Complejo Habitacional El Lindero', '', '', -27.466624400000000, -66.008117800000000, '../img-catamarca/default.jpg', 24, 16, 'aprobado'),
(1136, 'Información Turística Aconquija', '', '', -27.483646300000000, -66.017569900000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1137, 'Campo de piedra pomez', '', '', -26.613362200000000, -67.460733700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1138, 'Hostel kayra', '', '', -27.656771300000000, -67.032012700000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1139, 'Las trancas', '', '', -28.077255700000000, -65.904859200000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1140, 'Centro de información turística', '', '', -26.597112300000000, -66.941055600000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado');
INSERT INTO `lugares_turisticos` (`id`, `nombre`, `descripcion`, `direccion`, `lat`, `lng`, `imagen`, `id_categoria`, `id_departamento`, `estado`) VALUES
(1141, 'Museo integral de la Reserva de Biosfera de Laguna Blanca', '', '', -26.585826200000000, -66.950060900000000, '../img-catamarca/default.jpg', 4, 5, 'aprobado'),
(1142, 'Laguna Pabellon 4WD track', '', '', -26.084043000000000, -67.035428700000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(1143, 'Cascada Lascano', '', '', -28.417770200000000, -65.916807300000000, '../img-catamarca/default.jpg', 9, 1, 'aprobado'),
(1144, 'Campos de Piedra Pomez', '', '', -26.588023100000000, -67.483757700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1145, 'Cascada', '', '', -28.792987500000000, -66.382859900000000, '../img-catamarca/default.jpg', 9, 11, 'aprobado'),
(1146, 'Cascada', '', '', -28.147694100000000, -65.937133100000000, '../img-catamarca/default.jpg', 9, 4, 'aprobado'),
(1147, 'Capilla San Cayetano', '', '', -28.459731000000000, -65.697796900000000, '../img-catamarca/default.jpg', 1, 15, 'aprobado'),
(1148, 'Hospedaje \"Avenida\"', '', '', -26.691905100000000, -66.047297100000000, '../img-catamarca/default.jpg', 22, 13, 'aprobado'),
(1149, 'Cubo Blanco Móvil', '', '', -27.653117800000000, -67.026988100000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1150, 'Alquiler de caballos', '', '', -28.205521500000000, -65.873462900000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1151, 'Camping', '', '', -26.697656000000000, -66.040669300000000, '../img-catamarca/default.jpg', 24, 13, 'aprobado'),
(1152, 'Iglesia Señor de la Salud', '', '', -28.314997400000000, -66.148579100000000, '../img-catamarca/default.jpg', 1, 11, 'aprobado'),
(1153, 'Cueva La Candelaria', '', '', -28.689936000000000, -65.447502400000000, '../img-catamarca/default.jpg', 16, 17, 'aprobado'),
(1154, 'Campo de las Piedras', '', '', -28.829643400000000, -65.339368700000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(1155, 'Cuevas de Oyola', '', '', -28.482283600000000, -65.412504800000000, '../img-catamarca/default.jpg', 16, 9, 'aprobado'),
(1156, 'Cañón del Indio', '', '', -27.681392400000000, -67.765213000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1157, 'Iglesia Sagrado Corazón De Jesús', '', '', -27.505910200000000, -66.023245300000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(1158, 'Cristo', '', '', -27.403705400000000, -65.980842400000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1159, 'Iglesia Nuestro Señor', '', '', -27.528980500000000, -66.016786200000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(1160, 'Don Perico', '', '', -27.888562400000000, -65.728971100000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1161, 'La Nona', '', '', -27.885804200000000, -65.727941800000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1162, 'Doña Carmen', '', '', -27.885065400000000, -65.727799500000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1163, 'Camping Municipal', '', '', -27.878950600000000, -65.728454700000000, '../img-catamarca/default.jpg', 24, 10, 'aprobado'),
(1164, 'Hostería Loma Hermosa', '', '', -27.875202200000000, -65.729603100000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1165, 'Casa De Alquiler', '', '', -27.874801900000000, -65.729130400000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1166, 'Alquiler de Habitaciones', '', '', -27.873690100000000, -65.728487700000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1167, 'Casa en Alquiler', '', '', -27.881672400000000, -65.723752400000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1168, 'Iglesia San Antonio de Padua', '', '', -28.579007900000000, -65.888045500000000, '../img-catamarca/default.jpg', 1, 6, 'aprobado'),
(1169, 'Bell Apartments', '', '', -28.463845500000000, -65.806667500000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1170, 'Loma Larga', '', '', -26.730655600000000, -68.176751700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1171, 'Bolinder', '', '', -26.707599500000000, -68.083904700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1172, 'Janajman', '', '', -26.751162900000000, -68.140021200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1173, 'Bertrand', '', '', -26.834209700000000, -68.163521500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1174, 'Inca del Mar', '', '', -27.573618700000000, -68.422250000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1175, 'Chaschuil', '', '', -27.758628100000000, -68.075821700000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1176, 'Pastos Largos', '', '', -27.621216400000000, -68.099743100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1177, 'Las Peladas', '', '', -27.142508900000000, -68.134428300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1178, 'Tres Picos', '', '', -27.711232500000000, -68.862075000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1179, 'Engañero', '', '', -27.753145900000000, -68.904697500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1180, 'Falso Morocho', '', '', -26.937085600000000, -68.100968900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1181, 'Mirador del Cristo Redentor', '', '', -27.474803700000000, -66.017059600000000, '../img-catamarca/default.jpg', 10, 16, 'aprobado'),
(1182, 'Cristo Redentor', '', '', -27.474785900000000, -66.017097800000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1183, 'Co. Rosillo', '', '', -27.685513300000000, -68.320655500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1184, 'Colorado', '', '', -27.724233500000000, -68.080959700000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1185, 'Las Tunas', '', '', -27.753731100000000, -68.419423600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1186, 'Cdon. Guanaco Yaco', '', '', -27.885579400000000, -68.228816100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1187, 'Bola o Chango', '', '', -27.309442100000000, -68.283948600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1188, 'Manantiales', '', '', -27.676209300000000, -68.235635800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1189, 'Laguna Amarga', '', '', -27.539212900000000, -68.407627200000000, '../img-catamarca/default.jpg', 15, 14, 'aprobado'),
(1190, 'Filo Negro', '', '', -27.672153200000000, -68.494446000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1191, 'San Eduardo', '', '', -27.645728200000000, -68.223809100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1192, 'Co. de los Alanices', '', '', -27.961742400000000, -68.067351500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1193, 'Cerrito Solo', '', '', -27.793903300000000, -68.081417600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1194, 'Pabellón Colorado', '', '', -26.108374800000000, -67.025551100000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1195, 'Casas Viejas', '', '', -25.537970600000000, -66.763701700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1196, 'Portezuelo Alto', '', '', -26.638905300000000, -67.973686700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1197, 'Mellizas Oeste', '', '', -26.754682400000000, -68.034715500000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1198, 'Negro Muerto', '', '', -26.961137800000000, -67.992211200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1199, 'Real Blanco', '', '', -27.005667700000000, -68.006160500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1200, 'Pillán', '', '', -27.700519100000000, -68.808580100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1201, 'Zacarías Sanchez', '', '', -26.745676900000000, -68.095641600000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1202, 'Mellizas Este', '', '', -26.756638100000000, -68.019508200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1203, 'Mocho', '', '', -26.766544600000000, -68.075644500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1204, 'Pirca Redonda', '', '', -27.510824600000000, -68.436235400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1205, 'Coquena', '', '', -27.632599000000000, -68.101510100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1206, 'de la Quebrada', '', '', -27.664719600000000, -68.100949000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1207, 'de la Lagunita', '', '', -27.683313300000000, -68.100297100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1208, 'Pastos Amarillos', '', '', -27.544646500000000, -68.094710100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1209, 'Lagunas Frias Norte', '', '', -27.484744400000000, -68.416951400000000, '../img-catamarca/default.jpg', 15, 14, 'aprobado'),
(1210, 'Co. de la Fortuna', '', '', -27.762878500000000, -68.367617300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1211, 'Pirca Negra', '', '', -27.460564400000000, -68.276266600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1212, 'de la Aguada', '', '', -25.678930400000000, -67.894906000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1213, 'Valle Viejo', '', '', -28.466532400000000, -65.747967800000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1214, 'El Crestón', '', '', -28.379666200000000, -65.952310900000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1215, 'Fuerte quemado', '', '', -26.622675200000000, -66.049314400000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1216, 'Toconquis', '', '', -25.885868600000000, -67.083948300000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1217, 'Falda Ciénaga', '', '', -25.615981800000000, -67.189960400000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1218, 'Sierra del Jote', '', '', -26.307587200000000, -67.153208200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1219, 'Chinina', '', '', -25.843717200000000, -67.341068000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1220, 'Co. Diamante', '', '', -26.029817000000000, -67.066539300000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1221, 'Casas Viajas Sur o Qda del Nacimiento', '', '', -25.587241000000000, -66.748462300000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1222, 'Cachiyuyo', '', '', -25.527518900000000, -66.717924700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1223, 'Mirador Los Angeles', '', '', -28.549067600000000, -65.955844200000000, '../img-catamarca/default.jpg', 10, 6, 'aprobado'),
(1224, 'GENO', '', '', -28.470314300000000, -65.814631900000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1225, 'Cabañas Lunita', '', '', -27.687700000000000, -67.620231000000000, '../img-catamarca/default.jpg', 27, 14, 'aprobado'),
(1226, 'Monumento a los Ciclistas', '', '', -28.420372200000000, -65.722758300000000, '../img-catamarca/default.jpg', 18, 16, 'aprobado'),
(1227, 'Información Turística', '', '', -28.750136700000000, -65.547148000000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(1228, 'La Silleta', '', '', -28.116964400000000, -65.958843200000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1229, 'Virgen del Valle', '', '', -27.576966700000000, -67.618582600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1230, 'Camping Municipal Saujil', '', '', -27.577172400000000, -67.618518200000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1231, 'Agua del carnero', '', '', -27.578772400000000, -67.619263900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1232, 'Vertiente La Salamanca', '', '', -27.569162400000000, -67.622801700000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1233, 'Vertiente -', '', '', -27.576152500000000, -67.618244600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1234, 'Agua del cañaveral', '', '', -27.577132000000000, -67.617952300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1235, 'Cerro Mishma', '', '', -27.591353000000000, -67.635617600000000, '../img-catamarca/default.jpg', 14, 14, 'aprobado'),
(1236, 'Capilla Saujil', '', '', -27.565054400000000, -67.621527900000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1237, 'Museo Saujil', '', '', -27.565905600000000, -67.621450200000000, '../img-catamarca/default.jpg', 4, 14, 'aprobado'),
(1238, 'Mirador de la Duna', '', '', -27.568131100000000, -67.608880800000000, '../img-catamarca/default.jpg', 10, 14, 'aprobado'),
(1239, 'Manantial', '', '', -27.568790200000000, -67.621101100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1240, 'Residencial San Francisco', '', '', -28.066879700000000, -67.566853100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1241, 'El Chorro', '', '', -26.578989000000000, -66.972273200000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1242, 'Iglesia San Antonio de Padua', '', '', -28.659407000000000, -65.784717200000000, '../img-catamarca/default.jpg', 1, 15, 'aprobado'),
(1243, 'Busto Eva Perón', '', '', -28.450430300000000, -65.774381600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1244, 'Bodega Perro Guardián', '', '', -27.995300700000000, -67.603581500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1245, 'Posta El Suncho', '', '', -29.383568000000000, -65.255270000000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(1246, 'Sitio Arqueológico Petroglifos Ampajango', '', '', -26.902350700000000, -66.083154400000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1247, 'El Cardón más alto del país', '', '', -26.867766600000000, -66.040564800000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1248, 'Monumento Natural', '', '', -26.884702500000000, -66.064343300000000, '../img-catamarca/default.jpg', 18, 13, 'aprobado'),
(1249, 'Hostel San Martin', '', '', -29.218155900000000, -65.772371000000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1250, 'Termas de San Martin', '', '', -29.223296000000000, -65.774213600000000, '../img-catamarca/default.jpg', 8, 6, 'aprobado'),
(1251, 'Tebenquicho and Salar de Antofalla', '', '', -25.678912500000000, -67.519347800000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1252, 'Iglesia de La Sierra', '', '', -26.058941800000000, -67.406322200000000, '../img-catamarca/default.jpg', 1, 3, 'aprobado'),
(1253, 'Laguna Verde', '', '', -25.477439800000000, -67.556327900000000, '../img-catamarca/default.jpg', 15, 3, 'aprobado'),
(1254, 'Spring and Viewpoint', '', '', -26.450356500000000, -67.509815000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1255, 'Mirador Laguna Blanca', '', '', -26.632664700000000, -66.935880700000000, '../img-catamarca/default.jpg', 10, 5, 'aprobado'),
(1256, 'Hécate', '', '', -28.471534700000000, -65.813207900000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1257, 'Departamento Tatita', '', '', -28.466111400000000, -65.803902800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1258, 'quebada de la angostura', '', '', -27.703971700000000, -67.932922800000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1259, 'JR Hotel', '', '', -27.691361500000000, -67.621099100000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(1260, 'Entrada Balcón del Pissis', '', '', -27.640412600000000, -68.162866900000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1261, 'Virgen del Valle', '', '', -28.461317200000000, -65.783917400000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1262, 'Hostal Kaela Phalay', '', '', -27.713184300000000, -67.122304400000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1263, 'ICE - IGLESIA CRISTIANA EVANGÉLICA', '', '', -27.580230100000000, -66.315608900000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(1264, 'Cristo Redentor', '', '', -28.457222900000000, -65.729797200000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1265, 'Valle Viejo', '', '', -28.456587800000000, -65.733433700000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1266, 'Valle Viejo', '', '', -28.448434400000000, -65.726153100000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1267, 'Hospedaje La Pómez', '', '', -26.479162000000000, -67.265582600000000, '../img-catamarca/default.jpg', 22, 3, 'aprobado'),
(1268, 'El Coplero', '', '', -26.061285300000000, -67.405339700000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1269, 'Mirador Salar de Antofalla', '', '', -25.856991700000000, -67.721204300000000, '../img-catamarca/default.jpg', 10, 3, 'aprobado'),
(1270, 'Antiguo Micro Leyland Abandonado', '', '', -29.513836900000000, -64.916265600000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(1271, 'Antiguo Micro Bedford Abandonado', '', '', -29.513423800000000, -64.916464100000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(1272, 'Capilla', '', '', -29.222207100000000, -65.775235000000000, '../img-catamarca/default.jpg', 1, 6, 'aprobado'),
(1273, 'Iglesia Sagrado Corazón de Jesus', '', '', -28.852699000000000, -66.238060900000000, '../img-catamarca/default.jpg', 1, 6, 'aprobado'),
(1274, 'Iglesia de Fatima', '', '', -28.176687300000000, -67.488724000000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1275, 'Hostería Antigal', '', '', -28.177875400000000, -67.486889400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1276, 'Camping Munay', '', '', -28.182537700000000, -67.483284500000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1277, 'Camping El Sitio de Martin', '', '', -28.029229800000000, -67.588335900000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1278, 'Camping Santa Ana', '', '', -28.060708500000000, -67.583073400000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1279, 'Camping La Belicha', '', '', -28.066929700000000, -67.554089400000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1280, 'Información Turística', '', '', -28.072349500000000, -67.550798400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1281, 'Esculturas de Gurreros Diaguitas', '', '', -27.737917800000000, -67.640208500000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1282, 'Escultura de un Condor', '', '', -27.737806200000000, -67.640184300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1283, 'Casagrande Hotel de Adobe', '', '', -28.066998900000000, -67.567740500000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(1284, 'Comandancia de Armas', '', '', -27.714260800000000, -67.631031300000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1285, 'Antiguo Molino Harinero', '', '', -27.907218400000000, -67.614299700000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1286, 'Capilla Nuestra Señora del Rosario', '', '', -27.911734900000000, -67.615068100000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1287, 'Capilla Nuestra Señora de Andacollo', '', '', -27.942260900000000, -67.646620300000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1288, 'Oratorio de los Orquera', '', '', -27.957803800000000, -67.631251200000000, '../img-catamarca/default.jpg', 3, 14, 'aprobado'),
(1289, 'Camping El Algarrobo', '', '', -27.959668400000000, -67.631122500000000, '../img-catamarca/default.jpg', 24, 14, 'aprobado'),
(1290, 'Ruinas de Watungasta', '', '', -27.878521100000000, -67.684444800000000, '../img-catamarca/default.jpg', 18, 14, 'aprobado'),
(1291, 'Mirador del Calvario', '', '', -28.104431900000000, -67.513770500000000, '../img-catamarca/default.jpg', 3, 14, 'aprobado'),
(1292, 'Iglesia San Jose de Las Peñas Blancas', '', '', -28.120989900000000, -67.504007200000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1293, 'Iglesia Nuestra Señora De La Merced', '', '', -28.173010700000000, -67.464149600000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1294, 'Puente Colgante', '', '', -28.248484000000000, -67.431865200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1295, 'Iglesia NUestra Señora de Santa Lucía', '', '', -28.282300500000000, -67.339735300000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1296, 'Iglesia de la Merced', '', '', -28.282017000000000, -67.284205600000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1297, 'Vieja Estación de Huaco - Andalgala', '', '', -27.616858100000000, -66.330794200000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1298, 'Museo Arqueologico Andalgalá', '', '', -27.583576900000000, -66.315721600000000, '../img-catamarca/default.jpg', 4, 16, 'aprobado'),
(1299, 'Corona de la Virgen del Valle', '', '', -28.469047700000000, -65.786961700000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1300, 'Ruta 40 Km 4040', '', '', -28.004422100000000, -67.197371600000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1301, 'Monumento al Labrador', '', '', -27.568912500000000, -67.133933500000000, '../img-catamarca/default.jpg', 18, 5, 'aprobado'),
(1302, 'Mirador Pozo de Piedra', '', '', -27.568766200000000, -67.133992500000000, '../img-catamarca/default.jpg', 10, 5, 'aprobado'),
(1303, 'Mirador el Cóndor', '', '', -27.495652600000000, -67.095871600000000, '../img-catamarca/default.jpg', 10, 5, 'aprobado'),
(1304, 'Monumento al Cóndor', '', '', -27.495675200000000, -67.095858200000000, '../img-catamarca/default.jpg', 18, 5, 'aprobado'),
(1305, 'Dunas de Randolfo', '', '', -26.854638800000000, -66.746753900000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1306, 'Pozo Verde', '', '', -27.216743500000000, -66.833280000000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1307, 'Camino a Piedra Pomez', '', '', -26.473408600000000, -67.369035800000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1308, 'Camino a Piedra Pomez', '', '', -26.480479200000000, -67.337552000000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1309, 'Hospedaje Bezeta', '', '', -27.655853300000000, -67.027460500000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1310, 'Iglesia', '', '', -28.304581400000000, -67.247586700000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1311, 'Posada Las Cardas', '', '', -27.651850600000000, -67.021569000000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1312, 'Oficina de Turismo', '', '', -28.062883600000000, -67.564633200000000, '../img-catamarca/default.jpg', 25, 14, 'aprobado'),
(1313, 'San Nicolás', '', '', -27.683640300000000, -67.615172000000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1314, 'Capilla Virgen del Carmén', '', '', -27.688252200000000, -67.615518700000000, '../img-catamarca/default.jpg', 1, 14, 'aprobado'),
(1315, 'Museo Inti Quilla', '', '', -26.950997600000000, -66.134243300000000, '../img-catamarca/default.jpg', 4, 13, 'aprobado'),
(1316, 'Hotel San Pablo', '', '', -27.692931800000000, -67.623595600000000, '../img-catamarca/default.jpg', 22, 14, 'aprobado'),
(1317, 'Entrada a Buena Vista', '', '', -27.509667900000000, -66.026053700000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1318, 'Entrada a Buena Vista', '', '', -27.509789200000000, -66.025903500000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1319, 'Casona del Pino', '', '', -27.687967600000000, -67.619574200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1320, 'La Lomita', '', '', -27.223144400000000, -66.817031500000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1321, 'Dunas de Tatón', '', '', -27.344815000000000, -67.550951200000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1322, 'Aguada de Cobre', '', '', -27.344674700000000, -66.374030500000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1323, '✓ FRAY M. ESQUIÚ', '', '', -28.429744700000000, -65.709818300000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1324, 'Cabañas Tunay', '', '', -27.693762000000000, -67.627045600000000, '../img-catamarca/default.jpg', 27, 14, 'aprobado'),
(1325, 'Iglesia San Francisco Solano', '', '', -28.423346200000000, -65.693134600000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(1326, 'Virgen del Valle', '', '', -28.116479000000000, -65.628043200000000, '../img-catamarca/default.jpg', 99, 10, 'aprobado'),
(1327, 'cerro de la cruz', '', '', -27.700022500000000, -67.178371700000000, '../img-catamarca/default.jpg', 14, 5, 'aprobado'),
(1328, 'Cabañas Don Marcos', '', '', -27.385930700000000, -65.986235900000000, '../img-catamarca/default.jpg', 27, 16, 'aprobado'),
(1329, 'Apart Hotel Altitud', '', '', -28.467207800000000, -65.777066600000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(1330, 'Virgen del Valle', '', '', -28.203548800000000, -65.864014600000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1331, 'Virgen del Valle', '', '', -28.475745800000000, -65.774017000000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1332, 'Iglesia de San Nicolas de Bari', '', '', -28.706424800000000, -66.026924000000000, '../img-catamarca/default.jpg', 1, 6, 'aprobado'),
(1333, 'Museo de la Fiesta Nacional del Poncho', '', '', -28.448040500000000, -65.756030200000000, '../img-catamarca/default.jpg', 4, 1, 'aprobado'),
(1334, 'Sargento Mario \"Perro\" Cisnero', '', '', -28.458755400000000, -65.786194500000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(1335, 'Homenaje al Caido y al Ex-combatiente', '', '', -28.460365500000000, -65.770099800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1336, 'Monumento a los heroes del Crucero General Belgrano', '', '', -28.460384100000000, -65.770081900000000, '../img-catamarca/default.jpg', 18, 1, 'aprobado'),
(1337, 'Virgen de la Corona', '', '', -28.412044600000000, -66.001174000000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1338, 'Virgen Altos de Arena', '', '', -28.383616000000000, -66.037566000000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1339, 'Altos de Arena/ Peinao/ Cerro Negro', '', '', -28.395265300000000, -66.060016000000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(1340, 'Alto de la Cruz (Mogote)', '', '', -28.451874000000000, -66.053107300000000, '../img-catamarca/default.jpg', 14, 11, 'aprobado'),
(1341, 'Campamento Casa de Piedra', '', '', -28.491984400000000, -66.007082000000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1342, 'Puesto El Pinito', '', '', -28.552350800000000, -65.983336800000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1343, 'Puesto Los Ávalos', '', '', -28.502533600000000, -65.990181200000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1344, 'Segundo puesto Los Ávalos', '', '', -28.500794600000000, -65.993152900000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1345, 'Encuentro de senderos', '', '', -28.379307100000000, -65.969248600000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1346, 'Beato Mamerto Esquiú', '', '', -28.466811400000000, -65.778688800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1347, 'Club Nautico Los Talas', '', '', -28.257767900000000, -65.742541800000000, '../img-catamarca/default.jpg', 99, 7, 'aprobado'),
(1348, 'Información Turística', '', '', -28.812277100000000, -65.500772600000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(1349, 'Hospedaje', '', '', -26.059133400000000, -67.405678800000000, '../img-catamarca/default.jpg', 22, 3, 'aprobado'),
(1350, 'Iglesia', '', '', -27.093485500000000, -66.821691700000000, '../img-catamarca/default.jpg', 1, 5, 'aprobado'),
(1351, 'Duna Mágica', '', '', -27.566730000000000, -67.612389100000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1352, 'Virgen de Fátima', '', '', -27.688166200000000, -65.922144500000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1353, 'Mirador de la Cascada', '', '', -28.463696800000000, -65.818195500000000, '../img-catamarca/default.jpg', 9, 1, 'aprobado'),
(1354, 'Monumento al Bicentenario', '', '', -28.465987200000000, -65.818799100000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(1355, 'Televisor de Cemento', '', '', -28.535016800000000, -65.609574500000000, '../img-catamarca/default.jpg', 99, 9, 'aprobado'),
(1356, 'Museo de la Zamba \"Paisajes de Catamarca\"', '', '', -28.472693300000000, -65.635108300000000, '../img-catamarca/default.jpg', 4, 15, 'aprobado'),
(1357, 'Paisaje de Catamarca', '', '', -28.476201300000000, -65.618973200000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1358, 'Virgen del Valle', '', '', -28.254597500000000, -65.861122000000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1359, 'Hostería Municipal', '', '', -28.752461200000000, -65.547023300000000, '../img-catamarca/default.jpg', 99, 17, 'aprobado'),
(1360, 'SFVC Travel', '', '', -28.468701800000000, -65.779565600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1361, 'Monolito', '', '', -26.694673900000000, -66.048165100000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1362, 'Manuel Belgrano', '', '', -26.694573200000000, -66.048081400000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1363, 'Dientes de león', '', '', -26.694598400000000, -66.048270700000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1364, 'Virgen del Valle', '', '', -26.694682800000000, -66.047952400000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1365, 'Virgen María', '', '', -26.695011000000000, -66.047831000000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1366, 'Antigua Iglesia', '', '', -26.694763800000000, -66.048052800000000, '../img-catamarca/default.jpg', 1, 13, 'aprobado'),
(1367, 'Casa Caravati - Museo de la Ciudad', '', '', -28.474176000000000, -65.777969100000000, '../img-catamarca/default.jpg', 4, 1, 'aprobado'),
(1368, 'iglesia San Cayetano', '', '', -28.589685400000000, -65.523184400000000, '../img-catamarca/default.jpg', 1, 9, 'aprobado'),
(1369, 'curva del diablo', '', '', -28.482833200000000, -65.609864400000000, '../img-catamarca/default.jpg', 99, 15, 'aprobado'),
(1370, 'Virgen del Valle', '', '', -28.460265900000000, -65.774757100000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1371, 'Capilla Nuestra Señora', '', '', -29.195488700000000, -65.437286700000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(1372, 'Iglesia', '', '', -29.045710300000000, -65.352462500000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(1373, 'Iglesia', '', '', -29.161919500000000, -65.410241300000000, '../img-catamarca/default.jpg', 1, 8, 'aprobado'),
(1374, 'Hostería Municipal', '', '', -28.917643700000000, -65.329498800000000, '../img-catamarca/default.jpg', 99, 8, 'aprobado'),
(1375, 'Información Turística', '', '', -27.098072600000000, -66.828845000000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1376, 'Hospedaje G-V Villa Vil', '', '', -27.093769000000000, -66.822140400000000, '../img-catamarca/default.jpg', 6, 5, 'aprobado'),
(1377, 'Camping G-V Villa Vil', '', '', -27.093991000000000, -66.822418800000000, '../img-catamarca/default.jpg', 24, 5, 'aprobado'),
(1378, 'Hospedaje Cruz', '', '', -27.096797600000000, -66.824200900000000, '../img-catamarca/default.jpg', 22, 5, 'aprobado'),
(1379, 'Complejo Termal Villa Vil', '', '', -27.113773600000000, -66.823378900000000, '../img-catamarca/default.jpg', 24, 5, 'aprobado'),
(1380, 'Información Turística', '', '', -26.482040300000000, -67.258289200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1381, 'Iglesia', '', '', -27.688290200000000, -65.923852200000000, '../img-catamarca/default.jpg', 1, 4, 'aprobado'),
(1382, 'Departamentos Terrazas del Gracian', '', '', -28.163947500000000, -65.791950700000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1383, 'Puesto de Montaña', '', '', -28.508721300000000, -65.983623400000000, '../img-catamarca/default.jpg', 99, 6, 'aprobado'),
(1384, 'Cartel de Inicio a Catamarca', '', '', -27.768322600000000, -65.801755700000000, '../img-catamarca/default.jpg', 99, 16, 'aprobado'),
(1385, 'Virgen del Valle', '', '', -27.858712900000000, -65.834830400000000, '../img-catamarca/default.jpg', 99, 4, 'aprobado'),
(1386, 'Sierra de las Minas', '', '', -26.323970600000000, -67.793522000000000, '../img-catamarca/default.jpg', 7, 3, 'aprobado'),
(1387, 'Santo Cura Brochero', '', '', -28.424028400000000, -65.766384600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1388, 'Centro de Interpretación Pueblo Perdido', '', '', -28.466180300000000, -65.831538900000000, '../img-catamarca/default.jpg', 6, 1, 'aprobado'),
(1389, 'Iglesia', '', '', -27.207197900000000, -66.858315000000000, '../img-catamarca/default.jpg', 1, 5, 'aprobado'),
(1390, 'Hospedaje', '', '', -26.480581700000000, -67.262545800000000, '../img-catamarca/default.jpg', 22, 3, 'aprobado'),
(1391, 'Hospedaje Virgen del Valle', '', '', -28.456917800000000, -65.784800600000000, '../img-catamarca/default.jpg', 22, 1, 'aprobado'),
(1392, 'La Ventanita', '', '', -26.605331100000000, -66.056508600000000, '../img-catamarca/default.jpg', 99, 13, 'aprobado'),
(1393, 'Oratorio', '', '', -28.463357300000000, -65.833458800000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(1394, 'Cartel El Jumeal', '', '', -28.461213800000000, -65.810336800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1395, 'Cartel El Jumeal', '', '', -28.461728500000000, -65.812399800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1396, 'Balcón de la Ciudad', '', '', -28.465234200000000, -65.818923800000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1397, 'Mirador Mujer Aborigen', '', '', -28.464437700000000, -65.818070900000000, '../img-catamarca/default.jpg', 10, 1, 'aprobado'),
(1398, 'Mirador Parque de los Vientos', '', '', -28.462422000000000, -65.813059800000000, '../img-catamarca/default.jpg', 10, 1, 'aprobado'),
(1399, 'Mirador Parque de los Vientos', '', '', -28.462115400000000, -65.812475100000000, '../img-catamarca/default.jpg', 10, 1, 'aprobado'),
(1400, 'Mirador Parque de los Vientos', '', '', -28.461945700000000, -65.811997600000000, '../img-catamarca/default.jpg', 10, 1, 'aprobado'),
(1401, 'Mirador Bicentenario', '', '', -28.466038000000000, -65.818892800000000, '../img-catamarca/default.jpg', 3, 1, 'aprobado'),
(1402, 'Muelle de los Juncos', '', '', -28.459515400000000, -65.810152600000000, '../img-catamarca/default.jpg', 99, 1, 'aprobado'),
(1403, 'Mirador de la Curva', '', '', -28.458530800000000, -65.808559000000000, '../img-catamarca/default.jpg', 10, 1, 'aprobado'),
(1404, 'Monumento al Inmigrante Italiano', '', '', -28.460595700000000, -65.762285700000000, '../img-catamarca/default.jpg', 18, 1, 'aprobado'),
(1405, 'Iglesia Oratorio Santa María Magdalena', '', '', -28.506610100000000, -65.800391600000000, '../img-catamarca/default.jpg', 1, 1, 'aprobado'),
(1406, 'Viñatero', '', '', -27.957860800000000, -67.631477400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1407, 'Termas', '', '', -27.692336500000000, -67.619744400000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(1408, 'Termas Fiambalá', '', '', -27.742812400000000, -67.565200800000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado'),
(1409, 'Fray Mamerto Esquiu', '', '', -27.692274300000000, -67.619272600000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1410, 'Turismo', '', '', -27.712883900000000, -67.135470500000000, '../img-catamarca/default.jpg', 25, 5, 'aprobado'),
(1411, 'Ruta del adobe', '', '', -28.187722800000000, -67.486144400000000, '../img-catamarca/default.jpg', 99, 14, 'aprobado'),
(1412, 'Cabañas Maximiliano', '', '', -27.707660700000000, -67.629453900000000, '../img-catamarca/default.jpg', 27, 14, 'aprobado'),
(1413, 'quirquincho', '', '', -27.624948400000000, -67.023870300000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1414, 'Albazul Monoambiente', '', '', -27.654150000000000, -67.027615000000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1415, 'Puesto La Pampa', '', '', -27.066280400000000, -66.850267700000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1416, 'El Puma', '', '', -27.062829900000000, -66.855245000000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1417, 'Vírgen de Belén', '', '', -27.647185100000000, -67.036209800000000, '../img-catamarca/default.jpg', 99, 5, 'aprobado'),
(1418, 'Capilla Santa Rita', '', '', -27.346997400000000, -66.369076100000000, '../img-catamarca/default.jpg', 1, 16, 'aprobado'),
(1419, 'Río Turquesa Minas Capillitas', '', '', -27.351338100000000, -66.378219700000000, '../img-catamarca/default.jpg', 3, 16, 'aprobado'),
(1420, 'Peñas Chicas', '', '', -26.497888500000000, -67.310576200000000, '../img-catamarca/default.jpg', 99, 3, 'aprobado'),
(1421, 'Mirador del Abaucan', '', '', -28.260285900000000, -67.423865700000000, '../img-catamarca/default.jpg', 10, 14, 'aprobado'),
(1422, 'Termas de Fiambalá', '', '', -27.742881500000000, -67.550888900000000, '../img-catamarca/default.jpg', 8, 14, 'aprobado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensajes`
--

CREATE TABLE `mensajes` (
  `id` int(11) NOT NULL,
  `id_remitente` int(11) NOT NULL,
  `id_destinatario` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `leido` tinyint(1) DEFAULT 0,
  `fecha_envio` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `mensajes`
--

INSERT INTO `mensajes` (`id`, `id_remitente`, `id_destinatario`, `mensaje`, `leido`, `fecha_envio`) VALUES
(5, 1, 4, 'Hola', 0, '2025-12-17 16:16:50'),
(6, 1, 4, 'asdasda', 0, '2025-12-17 16:16:53'),
(7, 1, 4, 'hola', 0, '2025-12-17 16:24:55'),
(8, 1, 3, 'Holaa', 1, '2025-12-17 16:28:10'),
(9, 1, 5, 'Holaa', 1, '2025-12-17 16:28:18'),
(10, 3, 1, 'Hola!', 1, '2025-12-17 16:29:23'),
(11, 1, 5, 'hola', 1, '2025-12-17 16:34:31'),
(12, 5, 1, 'aaaa', 0, '2025-12-17 16:35:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recuperacion_password`
--

CREATE TABLE `recuperacion_password` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` timestamp NULL DEFAULT NULL,
  `usado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seguidores`
--

CREATE TABLE `seguidores` (
  `id` int(11) NOT NULL,
  `id_seguidor` int(11) NOT NULL,
  `id_seguido` int(11) NOT NULL,
  `fecha_inicio` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `seguidores`
--

INSERT INTO `seguidores` (`id`, `id_seguidor`, `id_seguido`, `fecha_inicio`) VALUES
(4, 4, 3, '2025-10-29 08:53:28'),
(9, 3, 4, '2025-11-03 22:41:46'),
(11, 1, 4, '2025-12-17 16:16:43'),
(12, 3, 1, '2025-12-17 16:21:13'),
(13, 1, 3, '2025-12-17 16:24:49'),
(14, 1, 5, '2025-12-17 16:25:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sesiones_usuarios`
--

CREATE TABLE `sesiones_usuarios` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sesiones_usuarios`
--

INSERT INTO `sesiones_usuarios` (`id`, `id_usuario`, `token`, `fecha_creacion`, `fecha_expiracion`, `ip_address`, `user_agent`) VALUES
(56, 1, '84700dca32cc2aca7d1e9ea7bc43c7c5aaf0c623a2354efdf6686b2713214041', '2025-12-17 00:58:59', '2025-12-24 00:58:59', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(64, 1, 'c406bb6f3466992d4264eaebd8d3438b03e694f9c1486835902cb393a121d8e6', '2025-12-17 16:10:04', '2025-12-24 16:10:04', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(75, 1, 'bf417ca3e511fb47079a5ed97f6f60ea1cf68c8bbcbe9e8c88c9b17e6c85e8fa', '2025-12-17 17:39:51', '2025-12-24 17:39:51', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(76, 6, '0e1a7efa9b3c32c009666343b2feefde944f9337ce009a8fb2a298b744be3104', '2025-12-17 17:43:32', '2025-12-24 17:43:32', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `tipo_usuario` enum('usuario','administrador') DEFAULT 'usuario',
  `rol` enum('usuario','admin','administrador') DEFAULT 'usuario',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultimo_acceso` timestamp NULL DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `imagen_perfil` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `tipo_usuario`, `rol`, `fecha_registro`, `ultimo_acceso`, `estado`, `imagen_perfil`, `telefono`) VALUES
(1, 'Administrador', 'admin@catamap.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'administrador', 'administrador', '2025-10-22 21:24:49', '2025-12-17 17:39:51', 'activo', 'perfil_1_1765987932.jpg', NULL),
(3, 'misael', 'm@gmail.com', '$2y$10$utko3Z5Qat2hU3Y7UOisbuSIWftd42..j0CtcLO7bjfYem390uka.', 'usuario', 'usuario', '2025-10-23 01:24:42', '2025-12-17 16:34:43', 'activo', 'perfil_3_1761721283.png', '321321312'),
(4, 'lautaro', 'l@gmail.com', '$2y$10$id2/3EKhtNSQp2PfCMIKJO8MkPva594z8pCPPeYtyZLazZQqC/dmS', 'usuario', 'usuario', '2025-10-29 08:52:54', '2025-10-29 08:52:55', 'activo', 'perfil_4_1761727996.png', NULL),
(5, 'Manuel', 'manuel@gmail.com', '$2y$10$lqOhJ4AZdgVJEeR.mNs/6.CCfRQYbdjQYOqGK.WQ51CARnZ5JAGfC', 'usuario', 'usuario', '2025-12-13 21:47:42', '2025-12-17 16:34:54', 'activo', NULL, NULL),
(6, 'asdasdas', '123@gmail.com', '$2y$10$PsgcyA.d1aL/h3zcJ4r8meQEsR/wwDluhnZMFCSJDDtTRmbVaCXUS', 'usuario', 'usuario', '2025-12-17 17:43:31', '2025-12-17 17:43:32', 'activo', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_insignias`
--

CREATE TABLE `usuarios_insignias` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_insignia` int(11) NOT NULL,
  `fecha_obtencion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios_insignias`
--

INSERT INTO `usuarios_insignias` (`id`, `id_usuario`, `id_insignia`, `fecha_obtencion`) VALUES
(1, 3, 3, '2025-10-29 07:04:42'),
(2, 1, 2, '2025-12-17 14:59:23');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lugar` (`id_lugar`),
  ADD KEY `idx_usuario` (`id_usuario`),
  ADD KEY `idx_aprobado` (`aprobado`),
  ADD KEY `idx_fecha` (`fecha_creacion`);

--
-- Indices de la tabla `configuracion_privacidad`
--
ALTER TABLE `configuracion_privacidad`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_favorito` (`id_usuario`,`id_lugar`),
  ADD KEY `idx_usuario` (`id_usuario`),
  ADD KEY `idx_lugar` (`id_lugar`);

--
-- Indices de la tabla `insignias`
--
ALTER TABLE `insignias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `lugares_sugeridos`
--
ALTER TABLE `lugares_sugeridos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `revisado_por` (`revisado_por`),
  ADD KEY `idx_usuario` (`id_usuario`),
  ADD KEY `idx_estado` (`estado`);

--
-- Indices de la tabla `lugares_turisticos`
--
ALTER TABLE `lugares_turisticos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_categoria` (`id_categoria`),
  ADD KEY `fk_departamento` (`id_departamento`),
  ADD KEY `idx_lugares_estado` (`estado`);

--
-- Indices de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_remitente` (`id_remitente`),
  ADD KEY `idx_destinatario` (`id_destinatario`),
  ADD KEY `idx_leido` (`leido`);

--
-- Indices de la tabla `recuperacion_password`
--
ALTER TABLE `recuperacion_password`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `idx_token` (`token`);

--
-- Indices de la tabla `seguidores`
--
ALTER TABLE `seguidores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_seguimiento` (`id_seguidor`,`id_seguido`),
  ADD KEY `idx_seguidor` (`id_seguidor`),
  ADD KEY `idx_seguido` (`id_seguido`);

--
-- Indices de la tabla `sesiones_usuarios`
--
ALTER TABLE `sesiones_usuarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `idx_token` (`token`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_usuarios_rol` (`rol`);

--
-- Indices de la tabla `usuarios_insignias`
--
ALTER TABLE `usuarios_insignias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_insignia_usuario` (`id_usuario`,`id_insignia`),
  ADD KEY `id_insignia` (`id_insignia`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `configuracion_privacidad`
--
ALTER TABLE `configuracion_privacidad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de la tabla `insignias`
--
ALTER TABLE `insignias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `lugares_sugeridos`
--
ALTER TABLE `lugares_sugeridos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `lugares_turisticos`
--
ALTER TABLE `lugares_turisticos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1424;

--
-- AUTO_INCREMENT de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `recuperacion_password`
--
ALTER TABLE `recuperacion_password`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `seguidores`
--
ALTER TABLE `seguidores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `sesiones_usuarios`
--
ALTER TABLE `sesiones_usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuarios_insignias`
--
ALTER TABLE `usuarios_insignias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`id_lugar`) REFERENCES `lugares_turisticos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `configuracion_privacidad`
--
ALTER TABLE `configuracion_privacidad`
  ADD CONSTRAINT `configuracion_privacidad_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD CONSTRAINT `favoritos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `lugares_sugeridos`
--
ALTER TABLE `lugares_sugeridos`
  ADD CONSTRAINT `lugares_sugeridos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `lugares_sugeridos_ibfk_2` FOREIGN KEY (`revisado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `lugares_turisticos`
--
ALTER TABLE `lugares_turisticos`
  ADD CONSTRAINT `fk_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  ADD CONSTRAINT `fk_departamento` FOREIGN KEY (`id_departamento`) REFERENCES `departamentos` (`id`);

--
-- Filtros para la tabla `mensajes`
--
ALTER TABLE `mensajes`
  ADD CONSTRAINT `mensajes_ibfk_1` FOREIGN KEY (`id_remitente`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `mensajes_ibfk_2` FOREIGN KEY (`id_destinatario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `recuperacion_password`
--
ALTER TABLE `recuperacion_password`
  ADD CONSTRAINT `recuperacion_password_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `seguidores`
--
ALTER TABLE `seguidores`
  ADD CONSTRAINT `seguidores_ibfk_1` FOREIGN KEY (`id_seguidor`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `seguidores_ibfk_2` FOREIGN KEY (`id_seguido`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sesiones_usuarios`
--
ALTER TABLE `sesiones_usuarios`
  ADD CONSTRAINT `sesiones_usuarios_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuarios_insignias`
--
ALTER TABLE `usuarios_insignias`
  ADD CONSTRAINT `usuarios_insignias_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `usuarios_insignias_ibfk_2` FOREIGN KEY (`id_insignia`) REFERENCES `insignias` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
