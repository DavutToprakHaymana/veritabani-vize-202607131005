# Ödev Raporu

**Ödev no:** Ödev 2     **Hafta:** 7     **Tarih:** 27 / 11 / 2026

**Ad Soyad:** Davut Toprak Haymana  **Öğrenci No:** 202607131005

**Program:** ☒ Yapay Zeka Operatörlüğü  ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☐ `llm_ops`  ☒ `robot_fleet`

**PR bağlantısı:** `https://github.com/DavutToprakHaymana/veritabani-vize-202607131005/pull/` ______

**Commit sayısı:** ______

---

## 1. Fan-out

4. soruda toplam **262'den 700'e** çıktı. `robots` ile `missions` birleşince 6 robot 14 satıra çoğaldı ve her robotun bataryası görev sayısı kadar toplandı: Atlas-01, Kartal-01 ve Kartal-03 üçer kez, Mars-01 ve Mars-02 ikişer kez, Atlas-02 bir kez sayıldı (fark 438). Gerçek bir raporda çok görevi olan robotların bataryası fazla sayılır, filonun şarjı olduğundan yüksek görünür ve şarj ya da görev planlaması yanlış bilgiyle yapılır; üstelik 700 gibi makul görünen bir sayı hatayı fark ettirmez.

## 2. En zor karar

En çok questions ile responses arasındaki kardinaliteyi düşündüm. İki seçenek vardı: yanıtı questions içine katıp 1-1 ilişki yapmak ya da ayrı tablo tutup 1-N bırakmak. Veride her soruya tam bir yanıt düştüğü için 1-1 daha doğal görünüyordu. Yine de 1-N seçtim, çünkü model yanıtı yeniden üretilebilir ve event_type sorunun değil yanıtın durumunu anlatıyor. Bunun bedeli, 4. sorudaki fan-out riskinin kendi şemamda da olması: soru başına birden çok yanıt olursa soru sayarken COUNT(DISTINCT q.id) kullanmam gerekir.

---

## 5. Yapay zeka kullanım beyanı

☐ Bu ödevde yapay zeka aracı **kullanmadım.**

☒ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Bölüm 1, S1-S5 | Claude | `robot_fleet` için JOIN sorgularını ve yorum taslağını yazmasını | psql'de çalıştırdım, satır sayılarını ve toplamları (9, 10, 4, 700/262, 10) kendi çıktımla karşılaştırdım |
| Bölüm 2 | Claude | Vize ERD'mi ödeve göre güncellemesini, normalizasyon notunu ve 2 JOIN sorusunu | ERD'yi vizedeki tablolarla ve veri kartıyla karşılaştırdım; JOIN sorularını anlatabildiğimden emin oldum |
| Bölüm 3 | Claude | Rapor taslağı | Sayıları kendi sorgu çıktılarımla kontrol ettim; 2. soruyu kendi düşüncemle düzelttim |

---

**İmza:** ________________________

*Doğruluk beyanı: Bu çalışmayı kendim yaptım. Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*
