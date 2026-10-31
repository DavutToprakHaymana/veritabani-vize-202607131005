-- Yorum: Oran, konudaki olay sayısının konunun toplam satırına bölünmesidir. En yüksek
-- oran arts and athletics'te (%4,5), en düşük admissions and aid'de (%1,0). Konular dengeli
-- örneklendiği için (her biri ~290 satır) fark gerçek soru dağılımını değil, kaynak
-- kalitesini gösterir. Olay sayıları küçük (3 ile 13 arası), fark kesin bir sonuç değil.
SELECT topic,
       COUNT(*) AS soru_sayisi,
       SUM(CASE WHEN olay_turu IS NOT NULL THEN 1 ELSE 0 END) AS olay_sayisi,
       ROUND(100.0 * SUM(CASE WHEN olay_turu IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS olay_yuzde
FROM qa_clean
GROUP BY topic
ORDER BY olay_yuzde DESC;

-- SORGU 2 (NULL, COUNT farkı)
-- Soru: Kaç satırda olay yok, kaç satırda var?
-- Beklenti: Olay sayısı toplamın küçük bir kısmı (~33).
-- Yorum: COUNT(*) tüm satırları, COUNT(olay_turu) yalnızca olay olanları sayar; fark olay
-- tespit edilmeyen satırlardır. NULL burada "olay yok"tur; bu, satırın doğru olduğunu kanıtlamaz.
SELECT COUNT(*) AS toplam,
       COUNT(olay_turu) AS olay_var,
       COUNT(*) - COUNT(olay_turu) AS olay_yok
FROM qa_clean;

-- Yorum: Eşiği düşük tuttum (en az 5 olay, oran %2 üstü), çünkü olay sayıları küçük.
-- Üç konu eşiği geçti: arts and athletics, about us, campus life. Bu konular önce
-- incelenecek kaynaklardır, kesin bir sıralama değildir.
SELECT topic,
       COUNT(olay_turu) AS olay_sayisi,
       ROUND(100.0 * COUNT(olay_turu) / COUNT(*), 1) AS olay_yuzde
FROM qa_clean
GROUP BY topic
HAVING COUNT(olay_turu) >= 5
   AND 100.0 * COUNT(olay_turu) / COUNT(*) > 2
ORDER BY olay_yuzde DESC;

-- SORGU 4 (CASE WHEN)
-- Soru: Cevap uzunluğu ile olay oranı arasında ilişki var mı?
-- Beklenti: Çok kısa ve çok uzun cevaplarda oran daha yüksek.
-- Yorum: Cevapları kısa (<50), orta (<200) ve uzun olarak ayırıyorum. Kısa cevapların hepsi
-- sorunlu değildir ("30" kredi saati geçerli bir cevaptır), bu yüzden uzunluk olay tanımına girmedi.
SELECT CASE WHEN answer_length < 50  THEN 'kisa'
            WHEN answer_length < 200 THEN 'orta'
            ELSE 'uzun' END AS cevap_boyu,
       COUNT(*) AS adet,
       COUNT(olay_turu) AS olay_sayisi,
       ROUND(100.0 * COUNT(olay_turu) / COUNT(*), 1) AS olay_yuzde
FROM qa_clean
GROUP BY 1
ORDER BY MIN(answer_length);

-- SORGU 5 (date_trunc)
-- Soru: Olaylar aylara göre nasıl dağılıyor?
-- Beklenti: Düz bir dağılım, çünkü tarih üretilmiştir.
-- Yorum: DİKKAT: asked_at sütunu rastgele üretildi, gerçek tarih değildir. Bu sorgu yalnızca
-- date_trunc kullanımını gösterir; sonuçtan zamansal bir eğilim çıkarılamaz.
SELECT date_trunc('month', asked_at) AS ay,
       COUNT(*) AS soru_sayisi,
       COUNT(olay_turu) AS olay_sayisi
FROM qa_clean
GROUP BY date_trunc('month', asked_at)
ORDER BY ay;

-- SORGU 6 (COALESCE)
-- Soru: Olay türleri nasıl dağılıyor?
-- Beklenti: Çoğunluk "normal", olayların çoğu model_kalintisi.
-- Yorum: COALESCE ile NULL değerlere "normal" etiketi verdim.
SELECT COALESCE(olay_turu, 'normal') AS durum, COUNT(*) AS adet
FROM qa_clean
GROUP BY COALESCE(olay_turu, 'normal')
ORDER BY adet DESC;