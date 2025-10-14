SET NAMES utf8mb4 COLLATE utf8mb4_unicode_520_ci;

-- Add gender column to specialists
-- Values: 'female' | 'male' | 'nb' (non-binary). Nullable if not provided.
ALTER TABLE specialists
  ADD COLUMN gender ENUM('female','male','nb') NULL AFTER languages;

-- Optional index to help filtering
CREATE INDEX IF NOT EXISTS idx_spec_gender ON specialists (gender);
