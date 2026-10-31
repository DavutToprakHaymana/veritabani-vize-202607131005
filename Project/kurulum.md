# Üniversite RAG Asistanı Bilgi Tabanında Kalite Olayları

Veritabanı Yönetim Sistemleri (PostgreSQL), Güz 2026, Vize projesi (Hafta 3-5).
Kura #6: Eğitim × RAG bilgi asistanı × Güvenlik ve olay takibi.

Bu proje, bir üniversite sorularına yanıt veren RAG asistanının soru-cevap kayıtlarını
PostgreSQL'e yükler, temizler ve kayıtlardaki bozuk satırların (boş, model kalıntısı içeren)
konulara göre dağılımını SQL ile analiz eder.

Bu dosya, projeyi **sıfırdan kendi bilgisayarında kurmak isteyen biri** için adım adım
kılavuzdur. Senaryo ve veri hakkındaki ayrıntılar için:

- `SCENARIO.md`: problem, ana soru, olay tanımı
- `data/README.md`: veri kartı (kaynak, lisans, temizlik adımları, sınırlılıklar)
- `AI_BEYAN.md`: kullanılan yapay zekâ araçları

## 1. Gereksinimler

| Araç | Not |
|---|---|
| Python 3.10 - 3.14 | Çok yeni sürümlerde (ör. 3.15) bazı kütüphaneler kurulamayabilir |
| PostgreSQL 14+ | Kurulumda belirlediğin `postgres` kullanıcı parolasını not al |
| VS Code + PostgreSQL eklentisi **ya da** pgAdmin 4 | SQL dosyalarını çalıştırmak için |
| Git | Repoyu indirmek için |

Python kütüphaneleri:

```
python -m pip install pandas psycopg2-binary
```

## 2. Klasör yapısı

```
Project/
├── README.md             ← bu dosya
├── SCENARIO.md
├── AI_BEYAN.md
├── data/
│   ├── README.md         ← veri kartı
│   ├── raw/              ← ham veri (elle değiştirilmez)
│   └── clean/            ← temizlenmiş veri
├── script/
│   ├── temizle.py        ← ham JSON'dan temiz CSV üretir
│   ├── yukle_raw.py      ← ham veriyi PostgreSQL'e yükler (raw_qa)
│   └── yukle.py          ← temiz veriyi PostgreSQL'e yükler (qa_clean)
└── sql/
    ├── kurulum.sql       ← tablo tanımının kaydı (yukle.py aynı tabloyu kurar)
    ├── ek-sutunlar.sql   ← olay_turu ve asked_at sütunlarını ekler
    ├── hafta-04.sql      ← ilk SELECT sorguları
    └── hafta-05.sql      ← 5+ analiz sorgusu
```

## 3. Kurulum adımları

Tüm komutları **projenin ana klasöründen** (içinde `data/` ve `script/` olan klasör)
çalıştır. Dosya yolları buna göre yazılmıştır.

### Adım 1: Repoyu indir

```
git clone <repo-adresi>
cd <repo-klasoru>
```

### Adım 2: Ham veriyi indir

Veri Hugging Face'te:
<https://huggingface.co/datasets/Aaron616/UWP-Instruct-Train>

Sayfada **Files and versions** sekmesinden JSON dosyasını indir ve `data/raw/` klasörüne
koy (dosya adı `run1_train_augment.json`). Dosyayı elle değiştirme.

> Bu veri setinin sayfasında dataset card ve lisans bilgisi yok. Kullanmadan önce
> lisans durumunu kendin kontrol et.

`data/raw/` klasörü repoda zaten doluysa bu adımı atla.

### Adım 3: PostgreSQL parolanı scriptlere yaz

`script/yukle.py` ve `script/yukle_raw.py` dosyalarının başında bağlantı ayarları var:

```python
conn = psycopg2.connect(host="localhost", port=5432,
                        dbname="postgres", user="postgres",
                        password="SIFRENIZ")
```

`SIFRENIZ` yerine kendi parolanı yaz. Farklı bir veritabanı kullanacaksan `dbname`'i
değiştir. **Parolanı yazdığın dosyaları GitHub'a yükleme.**

> Dikkat: Bu scriptler çalışınca `qa_clean` ve `raw_qa` tablolarını silip yeniden
> oluşturur (`DROP TABLE IF EXISTS`). Aynı adlı tablolarda verin varsa kaybolur.
> Yeni bir veritabanı açıp (`CREATE DATABASE veritabani_projesi;`) `dbname`'i ona çevirmek
> daha güvenlidir.

### Adım 4: Temiz veriyi üret

```
python script/temizle.py
```

Bu script ham dosyayı okur, yalnızca özgün satırları (`Parent = true`) alır ve
`data/clean/qa_clean.csv` dosyasını yazar. Beklenen çıktı:

```
Ana satir: 1450
Bos soru: 1 | Bos cevap: 1
```

**Sıra önemli:** `temizle.py` ham klasördeki ilk dosyayı okur. Adım 5'teki CSV
dönüşümünü bundan **sonra** yap, yoksa `data/raw/` içinde iki dosya olur.

### Adım 5: Ham veriyi yükleme için CSV'ye çevir

Aşağıdaki kodu çalıştır (ham JSON'a dokunmaz, yanına bir CSV kopyası yazar):

```python
import pandas as pd
try:
    df = pd.read_json("data/raw/run1_train_augment.json")
except ValueError:
    df = pd.read_json("data/raw/run1_train_augment.json", lines=True)
df.to_csv("data/raw/uwp_raw.csv", index=False)
print(df.shape)   # (7250, 9)
```

### Adım 6: Verileri PostgreSQL'e yükle

```
python script/yukle_raw.py
python script/yukle.py
```

Beklenen çıktılar:

```
Ham satir: 7250
Yuklenen satir: 1450
```

### Adım 7: Ek sütunları ekle

VS Code PostgreSQL eklentisinde ya da pgAdmin'de aynı veritabanına bağlanıp
`sql/ek-sutunlar.sql` dosyasını çalıştır. Son sorgu şunu döndürmeli:

| toplam | olay | tarihli |
|---|---|---|
| 1450 | 33 | 1450 |

> `asked_at` sütunu **üretilmiştir**, gerçek tarih değildir (veri setinde tarih yok).
> `asked_at_uretildi = true` ile işaretlidir.

### Adım 8: Sorguları çalıştır

- `sql/hafta-04.sql`: ilk SELECT sorguları ve veri kontrolleri
- `sql/hafta-05.sql`: analiz sorguları. Her sorguyu **tek tek** çalıştır (tümünü seçip
  çalıştırınca eklenti yalnızca son sonucu gösterebilir).

Beklenen bazı sonuçlar:

| Sorgu | Beklenen |
|---|---|
| Konuya göre olay oranı | arts and athletics %4,5 ile en yüksek, admissions and aid %1,0 ile en düşük |
| Olay var / yok | 33 / 1417 |
| Cevap boyuna göre olay oranı | kısa %9,5, orta %2,8, uzun %0,6 |

## 4. Sık karşılaşılan hatalar

| Hata | Sebep ve çözüm |
|---|---|
| `No module named 'pandas'` / `'psycopg2'` | Kütüphane kurulu değil: `python -m pip install pandas psycopg2-binary` |
| `password authentication failed for user "postgres"` | Scriptteki parola yanlış ya da hâlâ `SIFRENIZ` yazıyor |
| `relation "qa_clean" already exists` | Tablo zaten var. `CREATE TABLE` bloğunu elle tekrar çalıştırma, `yukle.py` tabloyu kendi siler ve yeniler |
| `invalid input syntax for type boolean: "1.0"` | `raw_qa` tablosunda `parent` sütunu `boolean` yerine `text` olmalı (`yukle_raw.py` bunu zaten böyle kurar) |
| `psycopg2-binary` kurulamıyor | Python sürümün çok yeni olabilir: Python 3.13 ya da 3.14 kur |
| Dosya bulunamadı (`data/raw/...`) | Komutu proje ana klasöründen çalıştırmıyorsun, `cd` ile doğru klasöre geç |
| `asked_at` bazı satırlarda boş | `ek-sutunlar.sql` içinde `id || question` yerine `concat(id, question)` kullanıldığından emin ol (boş metinler NULL gelir) |

## 5. Bilinen sınırlılıklar

- Veri setinde yanıtın doğru/yanlış etiketi **yok**; bu yüzden halüsinasyon ve yanlış belge
  ayrımı yapılamaz. Analiz, bilgi tabanındaki bozuk kayıtlara odaklanır.
- Tarih sütunu üretilmiştir, zaman eğilimi yorumlanamaz.
- Olay sayıları küçüktür (toplam 33, konu başına 3-13); bulgular kesin sonuç değil, işarettir.
- Konular dengeli örneklenmiştir (her biri ~290 satır).
- Veri ABD'deki bir üniversiteye aittir ve İngilizcedir.

## 6. Dönem sonu için planlananlar

Vizede JOIN, ERD, DDL ve YZ bileşeninin veritabanında uygulanması yer almaz. Dönem sonunda
düz tablo `questions`, `responses` ve `documents` olarak ayrıştırılacak ve yanıtın hangi belge
parçasından üretildiğini izleyen bir değerlendirme tablosu eklenecektir.
