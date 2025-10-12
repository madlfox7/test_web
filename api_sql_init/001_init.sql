CREATE TABLE IF NOT EXISTS specialists (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(120) NOT NULL,
  specialty   VARCHAR(120) NOT NULL,
  city        VARCHAR(120) NOT NULL,
  languages   VARCHAR(120) NOT NULL, -- "hy,ru,en"
  experience  INT DEFAULT 0,         -- лет стажа
  price_from  INT DEFAULT NULL,      -- стартовая цена сессии
  rating      DECIMAL(3,2) DEFAULT NULL,
  is_active   TINYINT(1) DEFAULT 1
);

INSERT INTO specialists (name, specialty, city, languages, experience, price_from, rating) VALUES
('Անի Մ.', 'Կոգնիտիվ-վարքային թերապիա', 'Երևան', 'hy,ru', 5, 8000, 4.7),
('Мария К.', 'Семейный психолог', 'Гюмри', 'ru,hy', 7, 9000, 4.6),
('Arman S.', 'Trauma-focused therapy', 'Yerevan', 'en,hy', 9, 12000, 4.8);
