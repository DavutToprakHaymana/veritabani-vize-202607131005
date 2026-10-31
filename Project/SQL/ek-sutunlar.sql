-- Olay türü: kural tabanlı. NULL = olay tespit edilmedi (doğru olduğu anlamına gelmez)
ALTER TABLE qa_clean ADD COLUMN IF NOT EXISTS olay_turu text;
UPDATE qa_clean SET olay_turu = CASE
    WHEN is_empty_answer   THEN 'bos_cevap'
    WHEN is_empty_question THEN 'bos_soru'
    WHEN question ILIKE '%code snippet%' OR question ILIKE '%analysis:%' THEN 'model_kalintisi'
    ELSE NULL END;

-- Tarih: veri setinde YOK, üretilmiştir
ALTER TABLE qa_clean ADD COLUMN IF NOT EXISTS asked_at timestamp;
ALTER TABLE qa_clean ADD COLUMN IF NOT EXISTS asked_at_uretildi boolean DEFAULT true;
UPDATE qa_clean SET asked_at = timestamp '2026-02-01'
    + (abs(hashtext(concat(id, question))::bigint) % 270)   * interval '1 day'
    + (abs(hashtext(concat(answer, id))::bigint)   % 86400) * interval '1 second';

SELECT COUNT(*) AS toplam, COUNT(olay_turu) AS olay, COUNT(asked_at) AS tarihli FROM qa_clean;
-- 1450, 33, 1450 beklenir

SELECT COUNT(*) AS toplam, COUNT(olay_turu) AS olay, COUNT(asked_at) AS tarihli FROM qa_clean;