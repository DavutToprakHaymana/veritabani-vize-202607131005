# Senaryo: Üniversite RAG Asistanı Bilgi Tabanında Kalite Olayları (Kura #6)

## Problem
Üniversite öğrencileri ders ve yönetmelik sorularını bir RAG asistanına soruyor. Asistan
bazen yanlış belgeden yanıt veriyor, bazen belgede olmayan bilgiyi uyduruyor. Kalite ekibi
bu olayları kaydetmek istiyor.

## Ana soru
Atanan soru: Yanlış yanıtların ne kadarı yanlış belge seçiminden, ne kadarı belgede
olmayan bilgiden kaynaklanıyor?

Verimle yanıtlanabilen uyarlanmış soru: Asistanın bilgi tabanına dayanan soru-cevap
kayıtlarında hangi konu başlığında bozuk kayıt (boş, model kalıntısı) oranı yüksek?
Gerekçe: Seçtiğim veri setinde yanıtın doğru/yanlış etiketi yok, bu yüzden atanan soru
doğrudan yanıtlanamıyor. (Hocama sordum, cevabı bekliyorum.)

## Hedef kullanıcı
Üniversite kalite ekibi ve asistanı geliştiren ekip.

## Olay tanımı
- bos_cevap: cevap metni boş
- bos_soru: soru metni boş
- model_kalintisi: soru alanında kaynak sitenin kod parçası ya da tweet içeriğinden
  üretilmiş dil modeli analiz metni var ("code snippet", "Analysis:")
- NULL: olay tespit edilmedi. Bu, kaydın doğru olduğu anlamına gelmez.

## Tablo adayları
- questions(id, question_text, topic, asked_at, question_length)
- responses(id, question_id, answer_text, answer_length, olay_turu)
- documents(id, source_section)
Vizede tek düz tablo (qa_clean) kullanılır, ayrıştırma Hafta 7'de (ERD) yapılacak.

## YZ bileşeni (dönem sonu)
RAG asistanı. Her yanıtın hangi belge parçasından üretildiğini ve olay türünü izleyen
bir değerlendirme tablosu (Hafta 11).

## Veri kaynağı
Hugging Face, Aaron616/UWP-Instruct-Train (UW-Parkside soru-cevap verisi).

## Kabul ettiğim kurallar ve sınırlar
- Analiz yalnızca özgün (Parent) 1.450 satırla yapılır; 5.800 yeniden ifade satırı sayılmaz.
- asked_at üretilmiş bir sütundur, zaman eğilimi yorumlanmaz.
- Olay oranı küçük (%2,3), konu karşılaştırmaları kesin sonuç değil, işarettir.
- Kişisel veri içeren kayıt kullanılmadı.