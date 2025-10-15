-- 1) Базовая таблица уже есть. Добавим код города (если решишь уйти от текстового):
-- ALTER TABLE specialists ADD COLUMN city_code VARCHAR(64) NULL AFTER picture;

-- 2) Таблица переводов
CREATE TABLE IF NOT EXISTS specialist_translations (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  specialist_id  INT UNSIGNED NOT NULL,
  lang           CHAR(2)      NOT NULL,  -- 'ru' | 'en' | 'hy'
  name           VARCHAR(160) NOT NULL,
  specialty      VARCHAR(200) NOT NULL,
  bio            TEXT         NULL,
  city_label     VARCHAR(120) NOT NULL,
  slug           VARCHAR(160) NOT NULL,
  UNIQUE KEY uniq_spec_lang (specialist_id, lang),
  UNIQUE KEY uniq_slug_lang (lang, slug),
  FULLTEXT KEY ft_name_spec_bio (name, specialty, bio),
  CONSTRAINT fk_st_spec
    FOREIGN KEY (specialist_id) REFERENCES specialists(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- 3) Переложим текущие RU-тексты в translations
INSERT INTO specialist_translations (specialist_id, lang, name, specialty, bio, city_label, slug)
SELECT s.id, 'ru',
       s.name,
       s.specialty,
       COALESCE(s.bio, ''),
       s.city,                              -- временно берём city как метку
       LOWER(REPLACE(REPLACE(s.name, ' ', '-'), '—', '-'))  -- простая заготовка SLUG
FROM specialists s
WHERE s.id NOT IN (
  SELECT specialist_id FROM specialist_translations WHERE lang='ru'
);
