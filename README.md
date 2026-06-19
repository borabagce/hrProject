# İK Analiz

Kurumsal İK (İnsan Kaynakları) bilgi değerlendirme platformu. Çalışanların bilgi düzeyini SM-2 aralıklı tekrar (spaced repetition) algoritması ile ölçen ve zamana yayılmış tekrar planı sunan bir sistem.

## Proje Hakkında

İK Analiz, başlangıçta bir ekip projesi olarak başlamış (Süleyman Çakır ve Uğur Gökpınar ile birlikte, danışman: Volkan Sözeri), şu anda tek başına geliştirilmeye devam edilen bir platform. Temel amaç, kurumsal eğitim/bilgi içeriklerini SM-2 algoritmasıyla zamana yayarak çalışanlara tekrar ettirmek ve bu süreci analiz etmek.

## Özellikler

- **SM-2 Aralıklı Tekrar Algoritması** — kullanıcı performansına göre tekrar aralıklarını dinamik olarak hesaplar
- **Web arayüzü** (Vue.js 3) — quiz/değerlendirme akışı
- **Mobil destek** (Flutter) — aynı değerlendirme akışının mobilde kullanımı
- **API / Backend** (Node.js + Express) — kullanıcı, soru, ve SM-2 durum yönetimi
- *(Geliştirme aşamasında)* Deterministik quiz üretici
- *(Değerlendirme aşamasında)* Python mikroservisi (FastAPI + scikit-learn) ile İK analitiği

## Teknoloji Yığını

| Katman | Teknoloji |
|---|---|
| Backend | Node.js, Express.js |
| Veritabanı | MongoDB |
| Frontend | Vue.js 3 |
| Mobil | Flutter |
| AI/ML (planlanan) | Python, FastAPI, scikit-learn |

**MEVN Stack** (MongoDB, Express, Vue, Node) + Flutter mobil katmanı.

## Mimari

Veritabanı şeması 11 tablo/koleksiyondan oluşuyor; bunlardan biri SM-2 durum kaydı (her kullanıcı-soru çifti için interval, ease factor, repetition sayısı, sonraki tekrar tarihi gibi alanları tutan log). Diğer tablolar kullanıcı, soru bankası, kategori, oturum gibi standart İK değerlendirme varlıklarını kapsıyor.

## Geliştirme Geçmişi

Proje, Ege MYO Bilgisayar Programcılığı bölümünde bir ekip projesi olarak başladı; şu an tek geliştirici tarafından sürdürülüyor.
