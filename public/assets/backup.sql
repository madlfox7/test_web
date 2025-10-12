/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: psyaid
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `specialist_translations`
--

DROP TABLE IF EXISTS `specialist_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `specialist_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `specialist_id` int(10) unsigned NOT NULL,
  `lang` char(2) NOT NULL,
  `name` varchar(160) NOT NULL,
  `specialty` varchar(200) NOT NULL,
  `bio` text DEFAULT NULL,
  `city_label` varchar(120) NOT NULL,
  `slug` varchar(160) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_spec_lang` (`specialist_id`,`lang`),
  UNIQUE KEY `uniq_slug_lang` (`lang`,`slug`),
  FULLTEXT KEY `ft_name_spec_bio` (`name`,`specialty`,`bio`),
  CONSTRAINT `fk_st_spec` FOREIGN KEY (`specialist_id`) REFERENCES `specialists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialist_translations`
--

LOCK TABLES `specialist_translations` WRITE;
/*!40000 ALTER TABLE `specialist_translations` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `specialist_translations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `specialists`
--

DROP TABLE IF EXISTS `specialists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `specialists` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `contacts` varchar(255) DEFAULT NULL,
  `specialty` varchar(160) NOT NULL,
  `methods` varchar(255) DEFAULT NULL,
  `languages` varchar(120) NOT NULL,
  `experience` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `price_from` int(10) unsigned DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_spec_active` (`is_active`,`rating`,`experience`),
  KEY `idx_spec_city` (`city`),
  KEY `idx_spec_name` (`name`),
  KEY `idx_spec_spec` (`specialty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialists`
--

LOCK TABLES `specialists` WRITE;
/*!40000 ALTER TABLE `specialists` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `specialists` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-10-12 15:51:22
