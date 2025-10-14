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
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
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
(7,7,'en','Ani Petrosyan','Clinical Psychologist','Depression, anxiety, emotional regulation','Vanadzor','ani-petrosyan'),
(8,8,'en','Suren Mkrtchyan','Psychotherapist','Identity, self-acceptance, life transitions','Yerevan','suren-mkrtchyan'),
(9,9,'en','Lilit Hovhannisyan','Counseling Psychologist','Self-esteem, relationships, motivation','Gyumri','lilit-hovhannisyan'),
(10,10,'en','Hayk Avetisyan','Addiction Counselor','Addictions, codependency, recovery support','Yerevan','hayk-avetisyan'),
(11,11,'en','Tatevik Karapetyan','Art Therapist','Children, creativity, trauma healing','Yerevan','tatevik-karapetyan'),
(12,12,'en','Karen Grigoryan','Psychologist-Sexologist','Relationships, intimacy, communication','Vanadzor','karen-grigoryan'),
(13,13,'en','Narine Hakobyan','Cognitive-Behavioral Therapist','Anxiety, OCD, perfectionism','Yerevan','narine-hakobyan'),
(14,14,'en','Vahan Stepanyan','Psychotherapist','Psychosomatics, trauma, panic attacks','Gyumri','vahan-stepanyan'),
(15,15,'en','Hasmik Melkonyan','Child & Family Therapist','Parent-child relations, behavior issues','Yerevan','hasmik-melkonyan'),
(16,1,'ru','Анна Саргсян','Когнитивно-поведенческий терапевт','Тревога, панические атаки, перфекционизм','Ереван','anna-sargsyan'),
(17,2,'ru','Давид Петросян','Семейный психолог','Пары, конфликты, развод, дети','Ереван','david-petrosyan'),
(18,3,'ru','Мариам Акопян','Детский психолог','Школа, СДВГ, самооценка','Гюмри','mariam-hakobyan'),
(19,4,'ru','Арман Арутюнян','Психотерапевт','Травма, ПТСР, горе','Ереван','arman-harutyunyan'),
(20,5,'ru','Елена Григорян','Клинический психолог','Депрессия, расстройства питания','Гюмри','elena-grigoryan'),
(21,6,'ru','Артур Манукян','Психолог-консультант','Стресс, выгорание, карьера','Ереван','artur-manukyan'),
(22,7,'ru','Ани Петросян','Клинический психолог','Депрессия, тревога, эмоциональная регуляция','Ванадзор','ani-petrosyan'),
(23,8,'ru','Сурен Мкртчян','Психотерапевт','Идентичность, самопринятие, жизненные переходы','Ереван','suren-mkrtchyan'),
(24,9,'ru','Лилит Ованнисян','Психолог-консультант','Самооценка, отношения, мотивация','Гюмри','lilit-hovhannisyan'),
(25,10,'ru','Айк Аветисян','Консультант по зависимостям','Зависимости, созависимость, поддержка восстановления','Ереван','hayk-avetisyan'),
(26,11,'ru','Татевик Карапетян','Арт-терапевт','Дети, креативность, заживление травм','Ереван','tatevik-karapetyan'),
(27,12,'ru','Карен Григорян','Психолог-сексолог','Отношения, близость, коммуникация','Ванадзор','karen-grigoryan'),
(28,13,'ru','Нарине Акопян','Когнитивно-поведенческий терапевт','Тревога, ОКР, перфекционизм','Ереван','narine-hakobyan'),
(29,14,'ru','Ваган Степанян','Психотерапевт','Психосоматика, травма, панические атаки','Гюмри','vahan-stepanyan'),
(30,15,'ru','Асмик Мелконян','Детский и семейный терапевт','Отношения родитель-ребенок, поведенческие трудности','Ереван','hasmik-melkonyan'),
(31,16,'ru','Анахит Мкртчян','Детский психолог','Эмоциональное развитие, тревожность у детей','Горис','anahit-mkrtchyan'),
(32,17,'ru','Левон Овсепян','Психотерапевт','Смысл, утрата, кризис середины жизни','Севан','levon-hovsepyan'),
(33,18,'ru','Армине Бабаян','Клинический психолог','Тревога, депрессия, эмоциональное равновесие','Արտաշատ','armine-babayan'),
(34,19,'ru','Карен Петросян','Семейный консультант','Пары, семейные конфликты, коммуникация','Абовян','karen-petrosyan'),
(35,20,'ru','Лусине Саргсян','Детский и подростковый психолог','Поведение, эмоции, адаптация подростков','Иджеван','lusine-sargsyan'),
(36,21,'ru','Хрант Данелян','Клинический психолог','Тревога, паника, навязчивые мысли','Գյումրի','hrant-danielyan'),
(37,22,'ru','Диана Акопян','Психотерапевт','Травма, идентичность, самоценность','Ереван','diana-hakobyan'),
(38,23,'ru','Геворг Григорян','Терапевт по зависимостям','Злоупотребление веществами, зависимость, семейные проблемы','Капан','gevorg-grigoryan'),
(39,24,'ru','Нунэ Ավետիսյան','Психолог-консультант','Уверенность в себе, жизненные переходы','Դիլիջան','nune-avetisyan'),
(40,25,'ru','Арташес Համբարձումян','Организационный психолог','Командная динамика, лидерство, стресс','Ереван','artashes-hambardzumyan'),
(47,1,'hy','Աննա Սարգսյան','Կոգնիտիվ-վարքաբանական թերապևտ','Տագնապ, խուճապ, կատարելապաշտություն','Երևան','anna-sargsyan'),
(48,2,'hy','Դավիթ Պետրոսյան','Ընտանեկան հոգեբան','Զույգեր, կոնֆլիկտ, ամուսնալուծություն, երեխաներ','Երևան','david-petrosyan'),
(49,3,'hy','Մարիամ Հակոբյան','Մանկական հոգեբան','Դպրոց, ADHD, ինքնագնահատական','Գյումրի','mariam-hakobyan'),
(50,4,'hy','Արման Հարությունյան','Հոգեթերապևտ','Վնասվածք, ՊՏՍԴ, վիշտ','Երևան','arman-harutyunyan'),
(51,5,'hy','Ելենա Գրիգորյան','Կլինիկական հոգեբան','Դեպրեսիա, սննդառության խանգարումներ','Գյումրի','elena-grigoryan'),
(52,6,'hy','Արտուր Մանուկյան','Խորհրդատու հոգեբան','Սթրես, այրում, կարիերա','Երևան','artur-manukyan'),
(59,7,'hy','Անի Պետրոսյան','Կլինիկական հոգեբան','Դեպրեսիա, տագնապ, հույզերի կարգավորում','Վանաձոր','ani-petrosyan'),
(60,8,'hy','Սուրեն Մկրտչյան','Հոգեթերապևտ','Ինքնություն, ինքնընդունում, կյանքի անցումներ','Երևան','suren-mkrtchyan'),
(61,9,'hy','Լիլիթ Հովհաննիսյան','Խորհրդատու հոգեբան','Ինքնագնահատական, հարաբերություններ, մոտիվացիա','Գյումրի','lilit-hovhannisyan'),
(62,10,'hy','Հայկ Ավետիսյան','Կախվածությունների խորհրդատու','Կախվածություններ, համակախվածություն, վերականգնման աջակցություն','Երևան','hayk-avetisyan'),
(63,11,'hy','Տաթևիկ Կարապետյան','Արտ թերապևտ','Երեխաներ, ստեղծարարություն, տրավմայի բուժում','Երևան','tatevik-karapetyan'),
(64,12,'hy','Կարեն Գրիգորյան','Հոգեբան-սեքսոլոգ','Հարաբերություններ, մտերմություն, հաղորդակցություն','Վանաձոր','karen-grigoryan'),
(65,13,'hy','Նարինե Հակոբյան','Կոգնիտիվ-վարքաբանական թերապևտ','Տագնապ, օբսեսիվ-կոմպուլսիվ խանգարում, կատարելապաշտություն','Երևան','narine-hakobyan'),
(66,14,'hy','Վահան Ստեփանյան','Հոգեթերապևտ','Հոգեսոմատիկա, տրավմա, խուճապային հարձակումներ','Գյումրի','vahan-stepanyan'),
(67,15,'hy','Հասմիկ Մելքոնյան','Երեխաների և ընտանիքի թերապևտ','Ծնող-երեխա հարաբերություններ, վարքային խնդիրներ','Երևան','hasmik-melkonyan'),
(78,16,'hy','Անահիտ Մկրտչյան','Մանկական հոգեբան','Էմոցիոնալ զարգացում, երեխաների տագնապ','Գորիս','anahit-mkrtchyan'),
(79,17,'hy','Լևոն Հովսեփյան','Հոգեթերապևտ','Իմաստ, կորուստ, միջին տարիքի ճգնաժամ','Սևան','levon-hovsepyan'),
(80,18,'hy','Արմինե Բաբայան','Կլինիկական հոգեբան','Տագնապ, դեպրեսիա, հուզական հավասարակշռություն','Արտաշատ','armine-babayan'),
(81,19,'hy','Կարեն Պետրոսյան','Ընտանեկան խորհրդատու','Զույգեր, ընտանեկան կոնֆլիկտներ, հաղորդակցություն','Աբովյան','karen-petrosyan'),
(82,20,'hy','Լուսինե Սարգսյան','Երեխաների և պատանիների հոգեբան','Վարք, հույզեր, պատանեկան ադապտացիա','Իջևան','lusine-sargsyan'),
(83,21,'hy','Հրանդ Դանիելյան','Կլինիկական հոգեբան','Տագնապ, խուճապ, պարտադրող մտքեր','Գյումրի','hrant-danielyan'),
(84,22,'hy','Դիանա Հակոբյան','Հոգեթերապևտ','Վնասվածք, ինքնություն, ինքնարժեք','Երևան','diana-hakobyan'),
(85,23,'hy','Գևորգ Գրիգորյան','Կախվածությունների թերապևտ','Նյութերի չարաշահում, կախվածություն, ընտանեկան հարցեր','Կապան','gevorg-grigoryan'),
(86,24,'hy','Նունե Ավետիսյան','Խորհրդատու հոգեբան','Ինքնավստահություն, կյանքի անցումներ','Դիլիջան','nune-avetisyan'),
(87,25,'hy','Արտաշես Համբարձումյան','Կազմակերպական հոգեբան','Թիմային դինամիկա, առաջնորդություն, սթրես','Երևան','artashes-hambardzumyan'),
(100,16,'en','Anahit Mkrtchyan','Child Psychologist','Emotional development, anxiety in children','Goris','anahit-mkrtchyan'),
(101,17,'en','Levon Hovsepyan','Psychotherapist','Meaning, loss, midlife crisis','Sevan','levon-hovsepyan'),
(102,18,'en','Armine Babayan','Clinical Psychologist','Anxiety, depression, emotional balance','Artashat','armine-babayan'),
(103,19,'en','Karen Petrosyan','Family Counselor','Couples, family conflicts, communication','Abovyan','karen-petrosyan'),
(104,20,'en','Lusine Sargsyan','Child & Teen Psychologist','Behavior, emotions, teenage adaptation','Ijevan','lusine-sargsyan'),
(105,21,'en','Hrant Danielyan','Clinical Psychologist','Anxiety, panic, obsessive thinking','Gyumri','hrant-danielyan'),
(106,22,'en','Diana Hakobyan','Psychotherapist','Trauma, identity, self-worth','Yerevan','diana-hakobyan'),
(107,23,'en','Gevorg Grigoryan','Addiction Therapist','Substance abuse, dependence, family issues','Kapan','gevorg-grigoryan'),
(108,24,'en','Nune Avetisyan','Counseling Psychologist','Self-confidence, life transitions','Dilijan','nune-avetisyan'),
(109,25,'en','Artashes Hambardzumyan','Organizational Psychologist','Team dynamics, leadership, stress','Yerevan','artashes-hambardzumyan');
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialists`
--

LOCK TABLES `specialists` WRITE;
/*!40000 ALTER TABLE `specialists` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `specialists` VALUES
(1,'Anna Sargsyan','anna.jpg','Yerevan','☎️ +374 77 123456 · @anna_psy','Cognitive Behavioral Therapist','CBT; ACT','hy,ru,en',7,12000,4.90,'Anxiety, panic attacks, perfectionism',1,'2025-10-14 18:58:10'),
(2,'David Petrosyan','david.jpg','Yerevan','☎️ +374 55 223344','Family Psychologist','Systemic therapy','hy,ru',10,15000,4.80,'Couples, conflicts, divorce, children',1,'2025-10-14 18:58:10'),
(3,'Mariam Hakobyan','mariam.jpg','Gyumri','✉️ mariam@psy.am','Child Psychologist','Play therapy','hy,ru',6,9000,4.70,'School issues, ADHD, self-esteem',1,'2025-10-14 18:58:10'),
(4,'Arman Harutyunyan','arman.jpg','Yerevan','tg: @arman_help','Psychotherapist','EMDR; PTSD','hy,en',9,20000,4.90,'Trauma, PTSD, grief',1,'2025-10-14 18:58:10'),
(5,'Elena Grigoryan','elena.jpg','Gyumri','☎️ +374 93 445566','Clinical Psychologist','Schema therapy','ru,hy',8,14000,4.60,'Depression, eating disorders',1,'2025-10-14 18:58:10'),
(6,'Artur Manukyan','artur.jpg','Yerevan','✉️ artur@mind.am','Counseling Psychologist','Motivational interview','hy,ru,en',5,10000,4.50,'Stress, burnout, career',1,'2025-10-14 18:58:10'),
(7,'Ani Petrosyan','ani.jpg','Vanadzor','☎️ +374 98 334455','Clinical Psychologist','CBT; Schema therapy','hy,ru',7,13000,4.80,'Depression, anxiety, emotional regulation',1,'2025-10-14 18:58:10'),
(8,'Suren Mkrtchyan','suren.jpg','Yerevan','tg: @suren_mind','Psychotherapist','Gestalt; Existential','hy,en,ru',12,22000,4.90,'Identity, self-acceptance, life transitions',1,'2025-10-14 18:58:10'),
(9,'Lilit Hovhannisyan','lilit.jpg','Gyumri','✉️ lilit@care.am','Counseling Psychologist','Person-centered','hy,ru',5,9500,4.60,'Self-esteem, relationships, motivation',1,'2025-10-14 18:58:10'),
(10,'Hayk Avetisyan','hayk.jpg','Yerevan','☎️ +374 44 667788','Addiction Counselor','Motivational Interviewing','hy,ru',11,16000,4.70,'Addictions, codependency, recovery support',1,'2025-10-14 18:58:10'),
(11,'Tatevik Karapetyan','tatevik.jpg','Yerevan','tg: @tate_psych','Art Therapist','Art therapy; Gestalt','hy,ru,en',6,11000,4.80,'Children, creativity, trauma healing',1,'2025-10-14 18:58:10'),
(12,'Karen Grigoryan','karen.jpg','Vanadzor','☎️ +374 99 112233','Psychologist-Sexologist','Integrative','hy,ru',9,18000,4.70,'Relationships, intimacy, communication',1,'2025-10-14 18:58:10'),
(13,'Narine Hakobyan','narine.jpg','Yerevan','✉️ narine@mind.am','Cognitive-Behavioral Therapist','CBT; ACT','hy,ru,en',8,15000,4.90,'Anxiety, OCD, perfectionism',1,'2025-10-14 18:58:10'),
(14,'Vahan Stepanyan','vahan.jpg','Gyumri','☎️ +374 77 778899','Psychotherapist','Body-oriented; EMDR','hy,ru',13,21000,4.80,'Psychosomatics, trauma, panic attacks',1,'2025-10-14 18:58:10'),
(15,'Hasmik Melkonyan','hasmik.jpg','Yerevan','tg: @hasmik_psy','Child & Family Therapist','Play therapy; Family','hy,ru,en',7,12000,4.80,'Parent-child relations, behavior issues',1,'2025-10-14 18:58:10'),
(16,'Anahit Mkrtchyan','anahit.jpg','Goris','☎️ +374 96 111222','Child Psychologist','Play therapy; CBT','hy,ru',8,10000,4.70,'Emotional development, anxiety in children',1,'2025-10-14 18:58:10'),
(17,'Levon Hovsepyan','levon.jpg','Sevan','tg: @levon_psy','Psychotherapist','Integrative; Existential','hy,ru,en',14,23000,4.90,'Meaning, loss, midlife crisis',1,'2025-10-14 18:58:10'),
(18,'Armine Babayan','armine.jpg','Artashat','✉️ armine@balance.am','Clinical Psychologist','Schema therapy','hy,ru',9,16000,4.80,'Anxiety, depression, emotional balance',1,'2025-10-14 18:58:10'),
(19,'Karen Petrosyan','karenp.jpg','Abovyan','☎️ +374 41 889977','Family Counselor','Systemic; EFT','hy,ru',10,15000,4.70,'Couples, family conflicts, communication',1,'2025-10-14 18:58:10'),
(20,'Lusine Sargsyan','lusine.jpg','Ijevan','tg: @lusine_care','Child & Teen Psychologist','Play therapy; Art therapy','hy,ru',5,9500,4.60,'Behavior, emotions, teenage adaptation',1,'2025-10-14 18:58:10'),
(21,'Hrant Danielyan','hrant.jpg','Gyumri','☎️ +374 55 334466','Clinical Psychologist','CBT; ACT','hy,ru,en',11,18000,4.80,'Anxiety, panic, obsessive thinking',1,'2025-10-14 18:58:10'),
(22,'Diana Hakobyan','diana.jpg','Yerevan','✉️ diana@psycenter.am','Psychotherapist','Gestalt; EMDR','hy,ru,en',9,19000,4.90,'Trauma, identity, self-worth',1,'2025-10-14 18:58:10'),
(23,'Gevorg Grigoryan','gevorg.jpg','Kapan','tg: @gevorg_mind','Addiction Therapist','Motivational interviewing','hy,ru',8,14000,4.60,'Substance abuse, dependence, family issues',1,'2025-10-14 18:58:10'),
(24,'Nune Avetisyan','nune.jpg','Dilijan','☎️ +374 93 556677','Counseling Psychologist','Person-centered; CBT','hy,ru,en',6,11000,4.70,'Self-confidence, life transitions',1,'2025-10-14 18:58:10'),
(25,'Artashes Hambardzumyan','artashes.jpg','Yerevan','☎️ +374 77 447788','Organizational Psychologist','Coaching; CBT','hy,en',12,24000,4.90,'Team dynamics, leadership, stress',1,'2025-10-14 18:58:10');
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

-- Dump completed on 2025-10-14 19:36:03
