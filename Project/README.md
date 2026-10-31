# Veri Kartı

- Kaynak: Hugging Face, Aaron616/UWP-Instruct-Train
  https://huggingface.co/datasets/Aaron616/UWP-Instruct-Train
- Lisans: Sayfada dataset card ve lisans bilgisi yok; lisans doğrulanamadı.
- İndirme tarihi: 31.10.2026
- Ham veri: 7.250 satır, 9 sütun (data/raw/run1_train_augment.json). Yükleme için aynı
  içerik data/raw/uwp_raw.csv'ye çevrildi, içerik değiştirilmedi. Çevirme sırasında Parent
  sütunu 1.0/boş biçiminde yazıldı, raw_qa tablosunda text tutuluyor.
- Temiz veri: 1.450 satır, 17 sütun (qa_clean tablosu; data/clean/qa_clean.csv 12 sütun,
  olay_turu, asked_at ve asked_at_uretildi veritabanında eklendi)

## Gerçek veri oranı
Ham dosyadaki 7.250 satırın 1.450'si özgün (Parent = true), 5.800'ü bunların yeniden ifade
edilmiş çoğaltmasıdır (her ana soru için 4, 6 soru için 8 tane). Çoğaltmalar analize
alınmadı. Özgün satırlardaki soru metinlerinin de dil modeliyle üretilmiş olma ihtimali var;
dataset card olmadığı için doğrulanamadı.

## Üretilen / türetilen sütunlar
- asked_at: veri setinde tarih yok. Satır metninin özetinden (hashtext) 01.02.2026-
  28.10.2026 aralığında üretildi. asked_at_uretildi = true ile işaretli. Gerçek tarih değildir.
- olay_turu: kural tabanlı türetilmiş (bkz. SCENARIO.md).
- Sayısal sütunlar (türetilmiş): question_length, answer_length, question_words,
  answer_words, paraphrase_count.
- Üretilen satır: yok (hiç satır eklenmedi).

## Temizleme adımları
1. Yalnızca Parent = true satırlar alındı (7.250 -> 1.450).
2. category "sol | sağ" biçimindeydi; source_section ve topic olarak bölündü, küçük
   harfe çevrildi ("campus life | Campus Life" tutarsızlığı giderildi).
3. 1 boş soru ve 1 boş cevap silinmedi, is_empty_question/is_empty_answer ile işaretlendi.
4. 3 ID'yi paylaşan 6 satır silinmedi.
5. 31 satırda soru alanında dil modeli analiz metni var ("code snippet", "Analysis:");
   silinmedi, olay_turu = 'model_kalintisi' olarak işaretlendi.
6. 30 karakterden kısa cevaplar incelendi; "30", "34", "35", "Cereal" gibi geçerli kısa
   cevaplar olduğu için olay sayılmadı.

## Bilinen sınırlılıklar
- Konular dengeli örneklenmiş (her biri ~290 satır); konu sayımları gerçek soru dağılımını
  yansıtmaz.
- Bazı satırlar üniversite sorusu değil, kaynak sitedeki tweet ve kod içeriğinden üretilmiş
  (ör. "favori film" soruları); bunlar kuralla tamamen yakalanamıyor.
- Yanıtın doğru/yanlış etiketi yok.
- Veri ABD'deki bir üniversiteye (UW-Parkside) aittir ve İngilizcedir.