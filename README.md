# Capek Mikir

Aplikasi kuis sederhana yang dibuat dengan Flutter.

## Informasi Mahasiswa

- **Nama:** Andreas Manatar Lumban Gaol
- **NIM:** 221401067
- **KOM:** B

## Tentang Aplikasi (Deskripsi)

**Capek Mikir** adalah aplikasi kuis yang menguji pengetahuan pengguna dalam berbagai kategori. Aplikasi ini dibuat sebagai proyek untuk Ujian Tengah Semester (UTS).

## Fitur

*   **Kuis Berbasis Kategori:** Pengguna dapat memilih dari beberapa kategori kuis.
*   **Pertanyaan Acak:** Setiap sesi kuis mengambil 10 pertanyaan secara acak.
*   **Batas Waktu:** Setiap sesi kuis memiliki batas waktu 3 menit.
*   **Skor dan Solusi:** Pengguna dapat melihat skor dan meninjau jawaban yang benar.
*   **Tampilan Responsif:** Layar kuis dan solusi akan menyesuaikan tata letak (compact & expanded view) untuk perangkat berlayar sempit dan lebar.
*   **Light and Dark Theme:** Pengguna dapat memakai tema terang atau gelap yang menyesuaikan dengan sistem perangkat.

## Screenshot & Video Aplikasi

### Screenshots

#### 1. Home Screen
<img src="docs/home.png" alt="Home Screen" height="450">

#### 2. Quiz Screen (Responsive)
|                    Compact View (Layar Sempit)                    |                     Expanded View (Layar Lebar)                     |
|:-----------------------------------------------------------------:|:-------------------------------------------------------------------:|
| <img src="docs/quiz_compact.png" alt="Quiz Compact" height="400"> | <img src="docs/quiz_expanded.png" alt="Quiz Expanded" height="400"> |

#### 3. Score Screen
<img src="docs/score.png" alt="Score Screen" height="450">

#### 4. Solution Screen (Responsive)
|                        Compact View (Layar Sempit)                        |                         Expanded View (Layar Lebar)                         |
|:-------------------------------------------------------------------------:|:---------------------------------------------------------------------------:|
| <img src="docs/solution_compact.png" alt="Solution Compact" height="400"> | <img src="docs/solution_expanded.png" alt="Solution Expanded" height="400"> |


### Video Demo

<p align="center">
  <img src="docs/demo.gif" alt="Video Demo Aplikasi" width="300">
</p>
<p align="center">
  <i>(Pratinjau di atas adalah file GIF. Untuk video lengkap dengan suara, klik link di bawah)</i>
</p>

[**Lihat Video Demo Lengkap (MP4)**](docs/demo.mp4)


## Link Mockup/Prototype

- **Aplikasi Web:** [Capek Mikir](https://capek-mikir.sanalab.live)


## Credit Aset

*Seluruh aset yang digunakan dalam proyek ini adalah buatan sendiri atau berasal dari sumber daya open-source yang tidak memerlukan atribusi.*

## Struktur Proyek

```
lib/
├── config/
│   ├── app_theme.dart     # Tema dan styling aplikasi
│   └── router.dart        # Konfigurasi routing aplikasi
├── data/
│   └── questions_list.dart # Daftar pertanyaan kuis
├── models/
│   ├── categories.dart    # Enum untuk kategori kuis
│   └── question.dart      # Model data untuk pertanyaan
├── provider/
│   ├── app_state_provider.dart # State management untuk logika kuis
│   └── user_state_provider.dart # State management untuk data pengguna
├── screens/
│   ├── home_screen.dart     # Tampilan utama aplikasi
│   ├── quiz_screen.dart     # Tampilan saat kuis berlangsung
│   ├── score_screen.dart    # Tampilan skor setelah kuis
│   └── solution_screen.dart # Tampilan untuk melihat solusi
├── widgets/
│   └── ...                # Berisi berbagai widget kustom
└── main.dart              # Titik masuk utama aplikasi
```

## Memulai

Untuk menjalankan proyek ini, pastikan Anda telah menginstal Flutter di lingkungan pengembangan Anda.

1.  **Clone repositori:**
    ```bash
    git clone https://github.com/andreasmlbngaol/capek_mikir.git
    ```
2.  **Masuk ke direktori proyek:**
    ```bash
    cd capek_mikir
    ```
3.  **Instal dependensi:**
    ```bash
    flutter pub get
    ```
4.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

## Dependensi

*   [flutter](https://flutter.dev/)
*   [provider](https://pub.dev/packages/provider)
*   [go_router](https://pub.dev/packages/go_router)
*   [google_fonts](https://pub.dev/packages/google_fonts)
