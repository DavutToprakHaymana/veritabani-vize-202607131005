-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad: Davut Toprak Haymana
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yaz.

-- Soru 1: Her robotun adı, operatör adı ve operatör telefonu (INNER JOIN)
SELECT r.name, o.operator_name, o.phone
FROM robots r
INNER JOIN operators o ON r.operator_name = o.operator_name
ORDER BY r.id;
-- Yorum: 9 satır döndü, çünkü 10 robottan Mars-03'ün operator_name değeri NULL olduğu için hiçbir operatörle eşleşmedi.


-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT r.name, o.operator_name, o.phone
FROM robots r
LEFT JOIN operators o ON r.operator_name = o.operator_name
ORDER BY r.id;
-- Yorum: 10 satır döndü; 1. sorguda kaybolan Mars-03 geri geldi ve operatör ile telefon sütunları NULL göründü.


-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT r.name, r.model
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
WHERE m.id IS NULL
ORDER BY r.id;
-- Yorum: 4 satır döndü (Kartal-02, Atlas-03, Mars-03, Kartal-04), çünkü bu robotların missions tablosunda eşleşen satırı olmadığından m.id NULL geldi.


-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT sum(r.battery_level) AS toplam_join
FROM robots r
INNER JOIN missions m ON m.robot_id = r.id;

-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT sum(battery_level) AS toplam_dogru
FROM robots
WHERE id IN (SELECT robot_id FROM missions);

-- Yorum (iki sonuç ve fark): 4a 700, 4b 262 çıktı; fark 438, çünkü birleştirme 14 satır üretti ve Atlas-01, Kartal-01, Kartal-03 üçer, Mars-01, Mars-02 ikişer kez sayıldı (fan-out).


-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT r.name,
       count(*)    AS count_yildiz,
       count(m.id) AS count_m_id
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
GROUP BY r.id, r.name
ORDER BY r.id;
-- Yorum (hangi robotlarda ikisi farklı?): Kartal-02, Atlas-03, Mars-03 ve Kartal-04'te count(*) 1, count(m.id) 0 çıktı, çünkü LEFT JOIN bu robotlar için NULL'lu tek satır üretti ve count(*) onu sayarken count(m.id) saymadı.
