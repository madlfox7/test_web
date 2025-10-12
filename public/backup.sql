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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialist_translations`
--

LOCK TABLES `specialist_translations` WRITE;
/*!40000 ALTER TABLE `specialist_translations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `specialist_translations` VALUES
(1,1,'en','Anna Sargsyan','Cognitive Behavioral Therapist','Anxiety, panic attacks, perfectionism','Yerevan','anna-sargsyan'),
(2,2,'en','David Petrosyan','Family Psychologist','Couples, conflicts, divorce, children','Yerevan','david-petrosyan'),
(3,3,'en','Mariam Hakobyan','Child Psychologist','School issues, ADHD, self-esteem','Gyumri','mariam-hakobyan'),
(4,4,'en','Arman Harutyunyan','Psychotherapist','Trauma, PTSD, grief','Yerevan','arman-harutyunyan'),
(5,5,'en','Elena Grigoryan','Clinical Psychologist','Depression, eating disorders','Gyumri','elena-grigoryan'),
(6,6,'en','Artur Manukyan','Counseling Psychologist','Stress, burnout, career','Yerevan','artur-manukyan'),
(8,1,'ru','Анна Саргсян','Когнитивно-поведенческий терапевт','Тревога, панические атаки, перфекционизм','Ереван','anna-sargsyan'),
(9,2,'ru','Давид Петросян','Семейный психолог','Пары, конфликты, развод, дети','Ереван','david-petrosyan'),
(10,3,'ru','Мариам Акопян','Детский психолог','Школа, СДВГ, самооценка','Гюмри','mariam-hakobyan'),
(11,4,'ru','Арман Арутюнян','Психотерапевт','Травма, ПТСР, горе','Ереван','arman-harutyunyan'),
(12,5,'ru','Елена Григорян','Клинический психолог','Депрессия, расстройства питания','Гюмри','elena-grigoryan'),
(13,6,'ru','Артур Манукян','Психолог-консультант','Стресс, выгорание, карьера','Ереван','artur-manukyan'),
(15,1,'hy','Աննա Սարգսյան','Կոգնիտիվ-վարքաբանական թերապևտ','Տագնապ, խուճապ, կատարելապաշտություն','Երևան','anna-sargsyan'),
(16,2,'hy','Դավիթ Պետրոսյան','Ընտանեկան հոգեբան','Զույգեր, կոնֆլիկտ, ամուսնալուծություն, երեխաներ','Երևան','david-petrosyan'),
(17,3,'hy','Մարիամ Հակոբյան','Մանկական հոգեբան','Դպրոց, ADHD, ինքնագնահատական','Գյումրի','mariam-hakobyan'),
(18,4,'hy','Արման Հարությունյան','Հոգեթերապևտ','Վնասվածք, ՊՏՍԴ, վիշտ','Երևան','arman-harutyunyan'),
(19,5,'hy','Ելենա Գրիգորյան','Կլինիկական հոգեբան','Դեպրեսիա, սննդառության խանգարումներ','Գյումրի','elena-grigoryan'),
(20,6,'hy','Արտուր Մանուկյան','Խորհրդատու հոգեբան','Սթրես, այրում, կարիերա','Երևան','artur-manukyan');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialists`
--

LOCK TABLES `specialists` WRITE;
/*!40000 ALTER TABLE `specialists` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `specialists` VALUES
(1,'Anna Sargsyan','anna.jpg','Yerevan','☎️ +374 77 123456 · @anna_psy','Cognitive Behavioral Therapist','CBT; ACT','hy,ru,en',7,12000,4.90,'Anxiety, panic attacks, perfectionism',1,'2025-10-12 10:38:44'),
(2,'David Petrosyan','david.jpg','Yerevan','☎️ +374 55 223344','Family Psychologist','Systemic therapy','hy,ru',10,15000,4.80,'Couples, conflicts, divorce, children',1,'2025-10-12 10:38:44'),
(3,'Mariam Hakobyan','mariam.jpg','Gyumri','✉️ mariam@psy.am','Child Psychologist','Play therapy','hy,ru',6,9000,4.70,'School issues, ADHD, self-esteem',1,'2025-10-12 10:38:44'),
(4,'Arman Harutyunyan','arman.jpg','Yerevan','tg: @arman_help','Psychotherapist','EMDR; PTSD','hy,en',9,20000,4.90,'Trauma, PTSD, grief',1,'2025-10-12 10:38:44'),
(5,'Elena Grigoryan','elena.jpg','Gyumri','☎️ +374 93 445566','Clinical Psychologist','Schema therapy','ru,hy',8,14000,4.60,'Depression, eating disorders',1,'2025-10-12 10:38:44'),
(6,'Artur Manukyan','artur.jpg','Yerevan','✉️ artur@mind.am','Counseling Psychologist','Motivational interview','hy,ru,en',5,10000,4.50,'Stress, burnout, career',1,'2025-10-12 10:38:44');
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

-- Dump completed on 2025-10-12 10:42:14
