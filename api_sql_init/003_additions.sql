SET NAMES utf8mb4 COLLATE utf8mb4_unicode_520_ci;

-- Optional additive seed: adds new specialists if they don't exist yet
-- Safe to run multiple times due to matching by unique (name, city) tuple and ON DUPLICATE behavior in translations

-- Insert specialists (avoid duplicates using name+city check)
INSERT INTO specialists (name, picture, city, contacts, specialty, methods, languages, gender, experience, price_from, rating, bio, is_active)
SELECT * FROM (
  SELECT 'Ani Petrosyan','ani.jpg','Vanadzor','☎️ +374 98 334455','Clinical Psychologist','CBT; Schema therapy','hy,ru','female',7,13000,4.8,'Depression, anxiety, emotional regulation',1 UNION ALL
    SELECT 'Suren Mkrtchyan','suren.jpg','Yerevan','tg: @suren_psy','Psychotherapist','Existential; Integrative','hy,ru,en','male',10,20000,4.8,'Identity, self-acceptance, life transitions',1 UNION ALL
  SELECT 'Lilit Hovhannisyan','lilit.jpg','Gyumri','✉️ lilit@care.am','Counseling Psychologist','Person-centered','hy,ru','female',5,9500,4.6,'Self-esteem, relationships, motivation',1 UNION ALL
  SELECT 'Hayk Avetisyan','hayk.jpg','Yerevan','☎️ +374 44 667788','Addiction Counselor','Motivational Interviewing','hy,ru','male',11,16000,4.7,'Addictions, codependency, recovery support',1 UNION ALL
  SELECT 'Tatevik Karapetyan','tatevik.jpg','Yerevan','tg: @tate_psych','Art Therapist','Art therapy; Gestalt','hy,ru,en','female',6,11000,4.8,'Children, creativity, trauma healing',1 UNION ALL
  SELECT 'Karen Grigoryan','karen.jpg','Vanadzor','☎️ +374 99 112233','Psychologist-Sexologist','Integrative','hy,ru','male',9,18000,4.7,'Relationships, intimacy, communication',1 UNION ALL
  SELECT 'Narine Hakobyan','narine.jpg','Yerevan','✉️ narine@mind.am','Cognitive-Behavioral Therapist','CBT; ACT','hy,ru,en','female',8,15000,4.9,'Anxiety, OCD, perfectionism',1 UNION ALL
  SELECT 'Vahan Stepanyan','vahan.jpg','Gyumri','☎️ +374 77 778899','Psychotherapist','Body-oriented; EMDR','hy,ru','male',13,21000,4.8,'Psychosomatics, trauma, panic attacks',1 UNION ALL
  SELECT 'Hasmik Melkonyan','hasmik.jpg','Yerevan','tg: @hasmik_psy','Child & Family Therapist','Play therapy; Family','hy,ru,en','female',7,12000,4.8,'Parent-child relations, behavior issues',1
) AS v(name,picture,city,contacts,specialty,methods,languages,gender,experience,price_from,rating,bio,is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM specialists s WHERE s.name = v.name AND s.city = v.city
);

-- Ensure EN translations mirror exist for these (idempotent)
INSERT INTO specialist_translations (specialist_id, lang, name, specialty, bio, city_label, slug)
SELECT s.id, 'en', s.name, s.specialty, COALESCE(s.bio,''), s.city,
       LOWER(REPLACE(REPLACE(REPLACE(TRIM(s.name),'—','-'),'–','-'),' ','-'))
FROM specialists s
WHERE s.name IN ('Ani Petrosyan','Suren Mkrtchyan','Lilit Hovhannisyan','Hayk Avetisyan','Tatevik Karapetyan','Karen Grigoryan','Narine Hakobyan','Vahan Stepanyan','Hasmik Melkonyan')
ON DUPLICATE KEY UPDATE
  name=VALUES(name), specialty=VALUES(specialty), bio=VALUES(bio), city_label=VALUES(city_label), slug=VALUES(slug);

-- RU/HY translations using name-based lookup
INSERT INTO specialist_translations (specialist_id, lang, name, specialty, bio, city_label, slug)
SELECT s.id, t.lang, t.name, t.specialty, t.bio, t.city_label, t.slug
FROM specialists s
JOIN (
  SELECT 'ru' AS lang, 'Ani Petrosyan' AS en_name, 'Ани Петросян' AS name, 'Клинический психолог' AS specialty, 'Депрессия, тревога, эмоциональная регуляция' AS bio, 'Ванадзор' AS city_label, 'ani-petrosyan' AS slug UNION ALL
  SELECT 'hy','Ani Petrosyan','Անի Պետրոսյան','Կլինիկական հոգեբան','Դեպրեսիա, տագնապ, հույզերի կարգավորում','Վանաձոր','ani-petrosyan' UNION ALL

  SELECT 'ru','Suren Mkrtchyan','Сурен Мкртчян','Психотерапевт','Идентичность, самопринятие, жизненные переходы','Ереван','suren-mkrtchyan' UNION ALL
  SELECT 'hy','Suren Mkrtchyan','Սուրեն Մկրտչյան','Հոգեթերապևտ','Ինքնություն, ինքնընդունում, կյանքի անցումներ','Երևան','suren-mkrtchyan' UNION ALL

  SELECT 'ru','Lilit Hovhannisyan','Лилит Ованнисян','Психолог-консультант','Самооценка, отношения, мотивация','Гюмри','lilit-hovhannisyan' UNION ALL
  SELECT 'hy','Lilit Hovhannisyan','Լիլիթ Հովհաննիսյան','Խորհրդատու հոգեբան','Ինքնագնահատական, հարաբերություններ, մոտիվացիա','Գյումրի','lilit-hovhannisyan' UNION ALL

  SELECT 'ru','Hayk Avetisyan','Айк Аветисян','Консультант по зависимостям','Зависимости, созависимость, поддержка восстановления','Ереван','hayk-avetisyan' UNION ALL
  SELECT 'hy','Hayk Avetisyan','Հայկ Ավետիսյան','Կախվածությունների խորհրդատու','Կախվածություններ, համակախվածություն, վերականգնման աջակցություն','Երևան','hayk-avetisyan' UNION ALL

  SELECT 'ru','Tatevik Karapetyan','Татевик Карапетян','Арт-терапевт','Дети, креативность, заживление травм','Ереван','tatevik-karapetyan' UNION ALL
  SELECT 'hy','Tatevik Karapetyan','Տաթևիկ Կարապետյան','Արտ թերապևտ','Երեխաներ, ստեղծարարություն, տրավմայի բուժում','Երևան','tatevik-karapetyan' UNION ALL

  SELECT 'ru','Karen Grigoryan','Карен Григорян','Психолог-сексолог','Отношения, близость, коммуникация','Ванадзор','karen-grigoryan' UNION ALL
  SELECT 'hy','Karen Grigoryan','Կարեն Գրիգորյան','Հոգեբան-սեքսոլոգ','Հարաբերություններ, մտերմություն, հաղորդակցություն','Վանաձոր','karen-grigoryan' UNION ALL

  SELECT 'ru','Narine Hakobyan','Нарине Акопян','Когнитивно-поведенческий терапевт','Тревога, ОКР, перфекционизм','Ереван','narine-hakobyan' UNION ALL
  SELECT 'hy','Narine Hakobyan','Նարինե Հակոբյան','Կոգնիտիվ-վարքաբանական թերապևտ','Տագնապ, օբսեսիվ-կոմպուլսիվ խանգարում, կատարելապաշտություն','Երևան','narine-hakobyan' UNION ALL

  SELECT 'ru','Vahan Stepanyan','Ваган Степанян','Психотерапевт','Психосоматика, травма, панические атаки','Гюмри','vahan-stepanyan' UNION ALL
  SELECT 'hy','Vahan Stepanyan','Վահան Ստեփանյան','Հոգեթերապևտ','Հոգեսոմատիկա, տրավմա, խուճապային հարձակումներ','Գյումրի','vahan-stepanyan' UNION ALL

  SELECT 'ru','Hasmik Melkonyan','Асмик Мелконян','Детский и семейный терапевт','Отношения родитель-ребенок, поведенческие трудности','Ереван','hasmik-melkonyan' UNION ALL
  SELECT 'hy','Hasmik Melkonyan','Հասմիկ Մելքոնյան','Երեխաների և ընտանիքի թերապևտ','Ծնող-երեխա հարաբերություններ, վարքային խնդիրներ','Երևան','hasmik-melkonyan'
) AS t
  ON s.name = t.en_name
ON DUPLICATE KEY UPDATE
  name=VALUES(name), specialty=VALUES(specialty), bio=VALUES(bio), city_label=VALUES(city_label), slug=VALUES(slug);

-- Batch 2: insert more specialists if missing
INSERT INTO specialists (name, picture, city, contacts, specialty, methods, languages, gender, experience, price_from, rating, bio, is_active)
SELECT * FROM (
  SELECT 'Anahit Mkrtchyan','anahit.jpg','Goris','☎️ +374 96 111222','Child Psychologist','Play therapy; CBT','hy,ru','female',8,10000,4.7,'Emotional development, anxiety in children',1 UNION ALL
  SELECT 'Levon Hovsepyan','levon.jpg','Sevan','tg: @levon_psy','Psychotherapist','Integrative; Existential','hy,ru,en','male',14,23000,4.9,'Meaning, loss, midlife crisis',1 UNION ALL
  SELECT 'Armine Babayan','armine.jpg','Artashat','✉️ armine@balance.am','Clinical Psychologist','Schema therapy','hy,ru','female',9,16000,4.8,'Anxiety, depression, emotional balance',1 UNION ALL
  SELECT 'Karen Petrosyan','karenp.jpg','Abovyan','☎️ +374 41 889977','Family Counselor','Systemic; EFT','hy,ru','male',10,15000,4.7,'Couples, family conflicts, communication',1 UNION ALL
  SELECT 'Lusine Sargsyan','lusine.jpg','Ijevan','tg: @lusine_care','Child & Teen Psychologist','Play therapy; Art therapy','hy,ru','female',5,9500,4.6,'Behavior, emotions, teenage adaptation',1 UNION ALL
  SELECT 'Hrant Danielyan','hrant.jpg','Gyumri','☎️ +374 55 334466','Clinical Psychologist','CBT; ACT','hy,ru,en','male',11,18000,4.8,'Anxiety, panic, obsessive thinking',1 UNION ALL
  SELECT 'Diana Hakobyan','diana.jpg','Yerevan','✉️ diana@psycenter.am','Psychotherapist','Gestalt; EMDR','hy,ru,en','female',9,19000,4.9,'Trauma, identity, self-worth',1 UNION ALL
  SELECT 'Gevorg Grigoryan','gevorg.jpg','Kapan','tg: @gevorg_mind','Addiction Therapist','Motivational interviewing','hy,ru','male',8,14000,4.6,'Substance abuse, dependence, family issues',1 UNION ALL
  SELECT 'Nune Avetisyan','nune.jpg','Dilijan','☎️ +374 93 556677','Counseling Psychologist','Person-centered; CBT','hy,ru,en','female',6,11000,4.7,'Self-confidence, life transitions',1 UNION ALL
  SELECT 'Artashes Hambardzumyan','artashes.jpg','Yerevan','☎️ +374 77 447788','Organizational Psychologist','Coaching; CBT','hy,en','male',12,24000,4.9,'Team dynamics, leadership, stress',1
) AS v(name,picture,city,contacts,specialty,methods,languages,gender,experience,price_from,rating,bio,is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM specialists s WHERE s.name = v.name AND s.city = v.city
);

-- Ensure EN translations mirror exist for batch 2
INSERT INTO specialist_translations (specialist_id, lang, name, specialty, bio, city_label, slug)
SELECT s.id, 'en', s.name, s.specialty, COALESCE(s.bio,''), s.city,
       LOWER(REPLACE(REPLACE(REPLACE(TRIM(s.name),'—','-'),'–','-'),' ','-'))
FROM specialists s
WHERE s.name IN ('Anahit Mkrtchyan','Levon Hovsepyan','Armine Babayan','Karen Petrosyan','Lusine Sargsyan','Hrant Danielyan','Diana Hakobyan','Gevorg Grigoryan','Nune Avetisyan','Artashes Hambardzumyan')
ON DUPLICATE KEY UPDATE
  name=VALUES(name), specialty=VALUES(specialty), bio=VALUES(bio), city_label=VALUES(city_label), slug=VALUES(slug);

-- RU/HY translations for batch 2
INSERT INTO specialist_translations (specialist_id, lang, name, specialty, bio, city_label, slug)
SELECT s.id, t.lang, t.name, t.specialty, t.bio, t.city_label, t.slug
FROM specialists s
JOIN (
  SELECT 'ru' AS lang, 'Anahit Mkrtchyan' AS en_name, 'Анаит Мкртчян' AS name, 'Детский психолог' AS specialty, 'Эмоциональное развитие, тревожность у детей' AS bio, 'Горис' AS city_label, 'anahit-mkrtchyan' AS slug UNION ALL
  SELECT 'hy','Anahit Mkrtchyan','Անահիտ Մկրտչյան','Մանկական հոգեբան','Էմոցիոնալ զարգացում, երեխաների տագնապ','Գորիս','anahit-mkrtchyan' UNION ALL

  SELECT 'ru','Levon Hovsepyan','Левон Овсепян','Психотерапевт','Смысл, утрата, кризис середины жизни','Севан','levon-hovsepyan' UNION ALL
  SELECT 'hy','Levon Hovsepyan','Լևոն Հովսեփյան','Հոգեթերապևտ','Իմաստ, կորուստ, միջին տարիքի ճգնաժամ','Սևան','levon-hovsepyan' UNION ALL

  SELECT 'ru','Armine Babayan','Армине Бабаян','Клинический психолог','Тревога, депрессия, эмоциональное равновесие','Арташат','armine-babayan' UNION ALL
  SELECT 'hy','Armine Babayan','Արմինե Բաբայան','Կլինիկական հոգեբան','Տագնապ, դեպրեսիա, հուզական հավասարակշռություն','Արտաշատ','armine-babayan' UNION ALL

  SELECT 'ru','Karen Petrosyan','Карен Петросян','Семейный консультант','Пары, семейные конфликты, коммуникация','Абовян','karen-petrosyan' UNION ALL
  SELECT 'hy','Karen Petrosyan','Կարեն Պետրոսյան','Ընտանեկան խորհրդատու','Զույգեր, ընտանեկան կոնֆլիկտներ, հաղորդակցություն','Աբովյան','karen-petrosyan' UNION ALL

  SELECT 'ru','Lusine Sargsyan','Лусине Саргсян','Детский и подростковый психолог','Поведение, эмоции, адаптация подростков','Иджеван','lusine-sargsyan' UNION ALL
  SELECT 'hy','Lusine Sargsyan','Լուսինե Սարգսյան','Երեխաների և պատանիների հոգեբան','Վարք, հույզեր, պատանեկան ադապտացիա','Իջևան','lusine-sargsyan' UNION ALL

  SELECT 'ru','Hrant Danielyan','Грант Даниелян','Клинический психолог','Тревога, паника, навязчивые мысли','Գյումրի','hrant-danielyan' UNION ALL
  SELECT 'hy','Hrant Danielyan','Հրանդ Դանիելյան','Կլինիկական հոգեբան','Տագնապ, խուճապ, պարտադրող մտքեր','Գյումրի','hrant-danielyan' UNION ALL

  SELECT 'ru','Diana Hakobyan','Диана Акопян','Психотерапевт','Травма, идентичность, самоценность','Ереван','diana-hakobyan' UNION ALL
  SELECT 'hy','Diana Hakobyan','Դիանա Հակոբյան','Հոգեթերապևտ','Վնասվածք, ինքնություն, ինքնարժեք','Երևան','diana-hakobyan' UNION ALL

  SELECT 'ru','Gevorg Grigoryan','Геворг Григорян','Терапевт по зависимостям','Злоупотребление веществами, зависимость, семейные проблемы','Капан','gevorg-grigoryan' UNION ALL
  SELECT 'hy','Gevorg Grigoryan','Գևորգ Գրիգորյան','Կախվածությունների թերապևտ','Նյութերի չարաշահում, կախվածություն, ընտանեկան հարցեր','Կապան','gevorg-grigoryan' UNION ALL

  SELECT 'ru','Nune Avetisyan','Нуне Аветисян','Психолог-консультант','Уверенность в себе, жизненные переходы','Դիլիջան','nune-avetisyan' UNION ALL
  SELECT 'hy','Nune Avetisyan','Նունե Ավետիսյան','Խորհրդատու հոգեբան','Ինքնավստահություն, կյանքի անցումներ','Դիլիջան','nune-avetisyan' UNION ALL

  SELECT 'ru','Artashes Hambardzumyan','Арташес Амбардзумян','Организационный психолог','Командная динамика, лидерство, стресс','Ереван','artashes-hambardzumyan' UNION ALL
  SELECT 'hy','Artashes Hambardzumyan','Արտաշես Համբարձումյան','Կազմակերպական հոգեբան','Թիմային դինամիկա, առաջնորդություն, սթրես','Երևան','artashes-hambardzumyan'
) AS t
  ON s.name = t.en_name
ON DUPLICATE KEY UPDATE
  name=VALUES(name), specialty=VALUES(specialty), bio=VALUES(bio), city_label=VALUES(city_label), slug=VALUES(slug);
