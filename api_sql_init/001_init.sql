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
  gender       ENUM('female','male','nb') NULL, -- optional: female/male/non-binary
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
  (name, picture, city, contacts, specialty, methods, languages, gender, experience, price_from, rating, bio, is_active)
VALUES
('Anna Sargsyan',     'anna.jpg',   'Yerevan', '☎️ +374 77 123456 · @anna_psy', 'Cognitive Behavioral Therapist', 'CBT; ACT',             'hy,ru,en', 'female', 7, 12000, 4.9, 'Anxiety, panic attacks, perfectionism', 1),
('David Petrosyan',   'david.jpg',  'Yerevan', '☎️ +374 55 223344',              'Family Psychologist',            'Systemic therapy',     'hy,ru',    'male', 10, 15000, 4.8, 'Couples, conflicts, divorce, children', 1),
('Mariam Hakobyan',   'mariam.jpg', 'Gyumri',  '✉️ mariam@psy.am',               'Child Psychologist',             'Play therapy',         'hy,ru',    'female', 6,  9000, 4.7, 'School issues, ADHD, self-esteem',      1),
('Arman Harutyunyan', 'arman.jpg',  'Yerevan', 'tg: @arman_help',                'Psychotherapist',                'EMDR; PTSD',           'hy,en',    'male', 9, 20000, 4.9, 'Trauma, PTSD, grief',                   1),
('Elena Grigoryan',   'elena.jpg',  'Gyumri',  '☎️ +374 93 445566',              'Clinical Psychologist',          'Schema therapy',       'ru,hy',    'female', 8, 14000, 4.6, 'Depression, eating disorders',          1),
('Artur Manukyan',    'artur.jpg',  'Yerevan', '✉️ artur@mind.am',               'Counseling Psychologist',        'Motivational interview','hy,ru,en', 'male', 5, 10000, 4.5, 'Stress, burnout, career',               1);

-- Additional seed specialists
INSERT INTO specialists
  (name, picture, city, contacts, specialty, methods, languages, gender, experience, price_from, rating, bio, is_active)
VALUES
('Ani Petrosyan',      'ani.jpg',     'Vanadzor', '☎️ +374 98 334455', 'Clinical Psychologist',            'CBT; Schema therapy',         'hy,ru',      'female', 7, 13000, 4.8, 'Depression, anxiety, emotional regulation', 1),
('Suren Mkrtchyan',    'suren.jpg',   'Yerevan',  'tg: @suren_mind',   'Psychotherapist',                  'Gestalt; Existential',        'hy,en,ru',  'male', 12, 22000, 4.9, 'Identity, self-acceptance, life transitions', 1),
('Lilit Hovhannisyan', 'lilit.jpg',   'Gyumri',   '✉️ lilit@care.am',  'Counseling Psychologist',          'Person-centered',             'hy,ru',      'female', 5,  9500, 4.6, 'Self-esteem, relationships, motivation',      1),
('Hayk Avetisyan',     'hayk.jpg',    'Yerevan',  '☎️ +374 44 667788', 'Addiction Counselor',              'Motivational Interviewing',   'hy,ru',      'male', 11, 16000, 4.7, 'Addictions, codependency, recovery support', 1),
('Tatevik Karapetyan', 'tatevik.jpg', 'Yerevan',  'tg: @tate_psych',   'Art Therapist',                    'Art therapy; Gestalt',        'hy,ru,en',   'female', 6, 11000, 4.8, 'Children, creativity, trauma healing',       1),
('Karen Grigoryan',    'karen.jpg',   'Vanadzor', '☎️ +374 99 112233', 'Psychologist-Sexologist',          'Integrative',                 'hy,ru',      'male', 9, 18000, 4.7, 'Relationships, intimacy, communication',     1),
('Narine Hakobyan',    'narine.jpg',  'Yerevan',  '✉️ narine@mind.am', 'Cognitive-Behavioral Therapist',   'CBT; ACT',                    'hy,ru,en',   'female', 8, 15000, 4.9, 'Anxiety, OCD, perfectionism',               1),
('Vahan Stepanyan',    'vahan.jpg',   'Gyumri',   '☎️ +374 77 778899', 'Psychotherapist',                  'Body-oriented; EMDR',         'hy,ru',      'male', 13, 21000, 4.8, 'Psychosomatics, trauma, panic attacks',     1),
('Hasmik Melkonyan',   'hasmik.jpg',  'Yerevan',  'tg: @hasmik_psy',   'Child & Family Therapist',         'Play therapy; Family',        'hy,ru,en',   'female', 7, 12000, 4.8, 'Parent-child relations, behavior issues',   1);

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

-- Additional seed specialists (batch 2)
INSERT INTO specialists
  (name, picture, city, contacts, specialty, methods, languages, gender, experience, price_from, rating, bio, is_active)
VALUES
('Anahit Mkrtchyan',  'anahit.jpg',   'Goris',    '☎️ +374 96 111222',  'Child Psychologist',            'Play therapy; CBT',           'hy,ru',      'female', 8, 10000, 4.7, 'Emotional development, anxiety in children', 1),
('Levon Hovsepyan',   'levon.jpg',    'Sevan',    'tg: @levon_psy',     'Psychotherapist',               'Integrative; Existential',    'hy,ru,en',  'male', 14, 23000, 4.9, 'Meaning, loss, midlife crisis',               1),
('Armine Babayan',    'armine.jpg',   'Artashat', '✉️ armine@balance.am','Clinical Psychologist',         'Schema therapy',              'hy,ru',      'female', 9, 16000, 4.8, 'Anxiety, depression, emotional balance',      1),
('Karen Petrosyan',   'karenp.jpg',   'Abovyan',  '☎️ +374 41 889977',  'Family Counselor',              'Systemic; EFT',               'hy,ru',      'male', 10, 15000, 4.7, 'Couples, family conflicts, communication',   1),
('Lusine Sargsyan',   'lusine.jpg',   'Ijevan',   'tg: @lusine_care',   'Child & Teen Psychologist',     'Play therapy; Art therapy',   'hy,ru',      'female', 5,  9500, 4.6, 'Behavior, emotions, teenage adaptation',     1),
('Hrant Danielyan',   'hrant.jpg',    'Gyumri',   '☎️ +374 55 334466',  'Clinical Psychologist',         'CBT; ACT',                    'hy,ru,en',   'male', 11, 18000, 4.8, 'Anxiety, panic, obsessive thinking',         1),
('Diana Hakobyan',    'diana.jpg',    'Yerevan',  '✉️ diana@psycenter.am','Psychotherapist',              'Gestalt; EMDR',               'hy,ru,en',   'female', 9, 19000, 4.9, 'Trauma, identity, self-worth',               1),
('Gevorg Grigoryan',  'gevorg.jpg',   'Kapan',    'tg: @gevorg_mind',   'Addiction Therapist',           'Motivational interviewing',   'hy,ru',      'male', 8, 14000, 4.6, 'Substance abuse, dependence, family issues', 1),
('Nune Avetisyan',    'nune.jpg',     'Dilijan',  '☎️ +374 93 556677',  'Counseling Psychologist',       'Person-centered; CBT',        'hy,ru,en',   'female', 6, 11000, 4.7, 'Self-confidence, life transitions',          1),
('Artashes Hambardzumyan', 'artashes.jpg', 'Yerevan','☎️ +374 77 447788','Organizational Psychologist',   'Coaching; CBT',               'hy,en',      'male', 12, 24000, 4.9, 'Team dynamics, leadership, stress',         1);