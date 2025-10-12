-- Ensure sane defaults
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_520_ci;
SET sql_mode = 'STRICT_ALL_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Reset (idempotent when you want a clean slate)
DROP TABLE IF EXISTS specialist_translations;
DROP TABLE IF EXISTS specialists;

-- Base table (language-agnostic fields; working-language filter stays hy,ru,en)
CREATE TABLE specialists (
  id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(120)      NOT NULL,
  picture      VARCHAR(255)      NULL,     -- file in /public/assets/specialists/
  city         VARCHAR(100)      NOT NULL, -- store canonical (e.g., Yerevan, Gyumri)
  contacts     VARCHAR(255)      NULL,     -- phone/telegram/email summary; JSON later if needed
  specialty    VARCHAR(160)      NOT NULL, -- EN for now
  methods      VARCHAR(255)      NULL,     -- e.g., "CBT; EMDR; ACT"
  languages    VARCHAR(120)      NOT NULL, -- CSV working languages: "hy,ru,en"
  experience   TINYINT UNSIGNED  NOT NULL DEFAULT 0,
  price_from   INT UNSIGNED      NULL,     -- in ֏
  rating       DECIMAL(3,2)      NULL,
  bio          TEXT              NULL,     -- EN for now
  is_active    TINYINT(1)        NOT NULL DEFAULT 1,
  created_at   TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Indexes for common filters/sorts
CREATE INDEX idx_spec_active ON specialists (is_active, rating, experience);
CREATE INDEX idx_spec_city   ON specialists (city);
CREATE INDEX idx_spec_name   ON specialists (name);
CREATE INDEX idx_spec_spec   ON specialists (specialty);

-- Optional translations table (for SEO + localized content)
CREATE TABLE specialist_translations (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  specialist_id  INT UNSIGNED NOT NULL,
  lang           CHAR(2)      NOT NULL,     -- 'en'|'ru'|'hy'
  name           VARCHAR(160) NOT NULL,
  specialty      VARCHAR(200) NOT NULL,
  bio            TEXT         NULL,
  city_label     VARCHAR(120) NOT NULL,     -- localized city label
  slug           VARCHAR(160) NOT NULL,     -- per-lang unique slug
  UNIQUE KEY uniq_spec_lang (specialist_id, lang),
  UNIQUE KEY uniq_slug_lang  (lang, slug),
  FULLTEXT KEY ft_name_spec_bio (name, specialty, bio),
  CONSTRAINT fk_st_spec FOREIGN KEY (specialist_id)
    REFERENCES specialists(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- Seed: ENGLISH-ONLY content now (you can edit/extend as needed)
INSERT INTO specialists
  (name, picture, city, contacts, specialty, methods, languages, experience, price_from, rating, bio, is_active)
VALUES
('Anna Sargsyan',     'anna.jpg',   'Yerevan', '☎️ +374 77 123456 · @anna_psy', 'Cognitive Behavioral Therapist', 'CBT; ACT',             'hy,ru,en', 7, 12000, 4.9, 'Anxiety, panic attacks, perfectionism', 1),
('David Petrosyan',   'david.jpg',  'Yerevan', '☎️ +374 55 223344',              'Family Psychologist',            'Systemic therapy',     'hy,ru',    10, 15000, 4.8, 'Couples, conflicts, divorce, children', 1),
('Mariam Hakobyan',   'mariam.jpg', 'Gyumri',  '✉️ mariam@psy.am',               'Child Psychologist',             'Play therapy',         'hy,ru',     6,  9000, 4.7, 'School issues, ADHD, self-esteem',      1),
('Arman Harutyunyan', 'arman.jpg',  'Yerevan', 'tg: @arman_help',                'Psychotherapist',                'EMDR; PTSD',           'hy,en',     9, 20000, 4.9, 'Trauma, PTSD, grief',                   1),
('Elena Grigoryan',   'elena.jpg',  'Gyumri',  '☎️ +374 93 445566',              'Clinical Psychologist',          'Schema therapy',       'ru,hy',     8, 14000, 4.6, 'Depression, eating disorders',          1),
('Artur Manukyan',    'artur.jpg',  'Yerevan', '✉️ artur@mind.am',               'Counseling Psychologist',        'Motivational interview','hy,ru,en', 5, 10000, 4.5, 'Stress, burnout, career',               1);

-- Mirror EN into translations so JOIN by tlang='en' works immediately
INSERT INTO specialist_translations (specialist_id, lang, name, specialty, bio, city_label, slug)
SELECT s.id, 'en', s.name, s.specialty, COALESCE(s.bio,''), s.city,
       LOWER(
         REPLACE(
           REPLACE(
             REPLACE(TRIM(s.name), '—', '-'),
           '–','-'),
         ' ','-')
       )
FROM specialists s;
