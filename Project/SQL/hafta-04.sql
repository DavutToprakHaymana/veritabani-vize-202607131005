-- HAFTA 4: Ham veri PostgreSQL'e yüklendi, ilk SELECT ve WHERE sorguları

-- 1) İlk bakış: temiz tablodan 10 satır
SELECT * FROM qa_clean LIMIT 10;

-- 2) Ham ve temiz tablodaki satır sayıları (7250 ve 1450 beklenir)
SELECT (SELECT COUNT(*) FROM raw_qa)   AS ham_satir,
       (SELECT COUNT(*) FROM qa_clean) AS temiz_satir;

-- 3) Ham tabloda özgün (parent = '1.0') ve çoğaltma satırları (1450 ve 5800 beklenir)
SELECT parent, COUNT(*) AS adet FROM raw_qa GROUP BY parent;

-- 4) Konu başına satır sayısı (her biri yaklaşık 290)
SELECT topic, COUNT(*) AS adet FROM qa_clean GROUP BY topic ORDER BY adet DESC;

-- 5) WHERE: boş soru ya da boş cevabı olan satırlar
SELECT id, question, answer
FROM qa_clean
WHERE is_empty_question OR is_empty_answer;

-- 6) WHERE: çok uzun cevaplar
SELECT id, topic, answer_length
FROM qa_clean
WHERE answer_length > 500
ORDER BY answer_length DESC
LIMIT 10;

-- 7) Aynı ID'yi paylaşan satırlar (3 ID, 6 satır)
SELECT id, COUNT(*) AS adet FROM qa_clean GROUP BY id HAVING COUNT(*) > 1;

-- 8) Model kalıntısı içeren sorular (31 satır)
SELECT id, topic, LEFT(question, 110) AS soru
FROM qa_clean
WHERE olay_turu = 'model_kalintisi'
LIMIT 15;
SELECT COUNT(*) AS toplam, COUNT(olay_turu) AS olay, COUNT(asked_at) AS tarihli FROM qa_clean;