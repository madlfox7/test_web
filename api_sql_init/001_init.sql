-- utf8mb4 везде
CREATE TABLE IF NOT EXISTS specialists (
  id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(120)      NOT NULL,
  picture      VARCHAR(255)      NULL,     -- файл в /public/assets/specialists/
  city         VARCHAR(100)      NOT NULL,
  contacts     VARCHAR(255)      NULL,     -- телефон/telegram/email кратко, можно JSON позже
  specialty    VARCHAR(160)      NOT NULL, -- "Когнитивно-поведенческий терапевт", "Семейный психолог" и т.п.
  methods      VARCHAR(255)      NULL,     -- "CBT; EMDR; ACT" (опц.)
  languages    VARCHAR(120)      NOT NULL, -- CSV: hy,ru,en (совпадает с твоим FIND_IN_SET)
  experience   TINYINT UNSIGNED  NOT NULL DEFAULT 0,   -- лет стажа
  price_from   INT UNSIGNED      NULL,     -- минимальная цена (֏)
  rating       DECIMAL(3,2)      NULL,     -- 4.9
  bio          TEXT              NULL,
  is_active    TINYINT(1)        NOT NULL DEFAULT 1,
  created_at   TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Индексы под фильтры/поиск
CREATE INDEX idx_spec_active ON specialists (is_active, rating, experience);
CREATE INDEX idx_spec_city   ON specialists (city);
CREATE INDEX idx_spec_name   ON specialists (name);
CREATE INDEX idx_spec_spec   ON specialists (specialty);

-- Стартовые данные (пример)
INSERT INTO specialists
  (name, picture, city, contacts, specialty, methods, languages, experience, price_from, rating, bio, is_active)
VALUES
('Anna Sargsyan',      'anna.jpg',   'Yerevan', '☎️ +374 77 123456 · @anna_psy', 'Когнитивно-поведенческий терапевт', 'CBT; ACT',           'hy,ru,en', 7, 12000, 4.9, 'Тревога, панические атаки, перфекционизм', 1),
('David Petrosyan',    'david.jpg',  'Yerevan', '☎️ +374 55 223344',              'Семейный психолог',                 'Системная терапия',  'hy,ru',     10, 15000, 4.8, 'Пары, конфликты, развод, дети',           1),
('Mariam Hakobyan',    'mariam.jpg', 'Gyumri',  '✉️ mariam@psy.am',               'Детский психолог',                  'Игровая терапия',    'hy,ru',      6,  9000, 4.7, 'Школа, СДВГ, самооценка',                 1),
('Arman Harutyunyan',  'arman.jpg',  'Yerevan', 'tg: @arman_help',                'Психотерапевт',                     'EMDR; ПТСР',         'hy,en',      9, 20000, 4.9, 'Травма, ПТСР, горе',                      1),
('Elena Grigoryan',    'elena.jpg',  'Gyumri',  '☎️ +374 93 445566',              'Клинический психолог',              'Схема-терапия',      'ru,hy',      8, 14000, 4.6, 'Депрессия, расстройства питания',         1),
('Artur Manukyan',     'artur.jpg',  'Yerevan', '✉️ artur@mind.am',               'Психолог-консультант',              'Мотивационноеинтервью','hy,ru,en', 5, 10000, 4.5, 'Стресс, выгорание, карьера',              1);
