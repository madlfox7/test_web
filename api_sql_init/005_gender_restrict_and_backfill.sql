SET NAMES utf8mb4 COLLATE utf8mb4_unicode_520_ci;

-- Backfill genders where NULL, using simple name heuristics
UPDATE specialists SET gender='female' WHERE gender IS NULL AND name IN (
  'Anna Sargsyan','Mariam Hakobyan','Elena Grigoryan','Ani Petrosyan','Lilit Hovhannisyan','Tatevik Karapetyan','Narine Hakobyan','Hasmik Melkonyan',
  'Anahit Mkrtchyan','Armine Babayan','Lusine Sargsyan','Diana Hakobyan','Nune Avetisyan'
);
UPDATE specialists SET gender='male' WHERE gender IS NULL AND name IN (
  'David Petrosyan','Arman Harutyunyan','Artur Manukyan','Suren Mkrtchyan','Hayk Avetisyan','Karen Grigoryan','Vahan Stepanyan',
  'Levon Hovsepyan','Karen Petrosyan','Hrant Danielyan','Gevorg Grigoryan','Artashes Hambardzumyan'
);

-- Restrict enum to female/male only
ALTER TABLE specialists
  MODIFY COLUMN gender ENUM('female','male') NULL AFTER languages;

-- Ensure index exists (MySQL 8+: IF NOT EXISTS supported for indexes in some distributions; if not, ignore error)
CREATE INDEX IF NOT EXISTS idx_spec_gender ON specialists (gender);
