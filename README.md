# Kompos Baha

Aplikasi layanan **setor kompos → dijemput driver → ditimbang TPS 3R → poin → tukar hadiah** untuk warga Desa Baha.
Dirancang untuk pengguna usia 40–60 tahun: huruf besar, tombol besar, bahasa sederhana, konfirmasi di setiap langkah penting, dan pilihan ukuran huruf (Normal / Besar / Sangat besar).

Tata letak mengikuti CulTask (header sliver + avatar + notifikasi, hero banner bergambar, kartu statistik, kartu kategori, grid menu bergambar, bottom nav membulat), dengan **design system dari logo Kompos Baha**.

---

## 1. Menjalankan

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Flutter ≥ 3.47 (sesuai proyek awal). Paket: `provider`, `shared_preferences`, `google_fonts`, `flutter_svg`, `url_launcher`, `image_picker`, `path_provider`, `crypto`.

## 2. Akun bawaan (pertama kali dibuka)

| Peran | Nomor HP | PIN |
|---|---|---|
| Admin Desa | 081100000001 | 123456 |
| Petugas TPS 3R | 081100000002 | 123456 |
| Driver 1 (Kadek Dwi Arta) | 081100000003 | 123456 |
| Driver 2 (Komang Adi Putra) | 081100000004 | 123456 |

Warga **mendaftar sendiri** dari layar Masuk. Untuk latihan/presentasi: masuk sebagai Admin → **Kelola → Data aplikasi → Isi data contoh** (menambah 5 warga contoh, warga utama `081200000001` / PIN `123456`).

> ⚠️ Sebelum rilis: ganti PIN akun bawaan (Profil → Ganti PIN), ubah nomor WhatsApp admin (Kelola → Kuota & jadwal), dan nonaktifkan akun yang tidak dipakai.

## 3. Fitur per peran

**Warga** — Beranda (saldo, kompos bulan ini, penjemputan aktif, pengumuman), Setor kompos 5 langkah (berat dengan tombol −/+, tanggal dengan sisa kuota, jam, alamat, foto wajib), detail & timeline status, batalkan setoran, Tukar hadiah (kode `TKR-XXXX`, masa berlaku, batal = poin kembali), Riwayat (setoran / mutasi poin / hadiah), Pengaduan, Panduan membuat kompos, Pengumuman, Notifikasi, Profil.

**Driver** — Tugas hari ini & akan datang (dikelompokkan per jam), status Siap/Libur, telepon/WhatsApp/peta ke rumah warga, Mulai jemput → foto bukti → Sudah diambil → Sudah diantar ke TPS 3R, laporan gagal jemput, Riwayat.

**Petugas TPS 3R** — Antrean timbang, timbang & verifikasi (berat resmi, pemeriksaan mutu, kualitas Baik/Cukup, foto, pratinjau poin), tolak kompos, kuota hari ini/besok, penugasan driver, rekap per banjar & pemasok, grafik mingguan, atur kuota & jam layanan.

**Admin Desa (admin panel)** — Dashboard (kg, poin terbit/ditukar, grafik 6 minggu, status setoran, daftar "Perlu tindakan"), semua setoran (cari & filter), pengguna (tambah/ubah, peran, nonaktifkan, reset PIN, koreksi poin), penugasan driver, serahkan hadiah (cek kode), katalog hadiah & stok, tarif poin + riwayat versi, kuota/jam/hari layanan/banjar/kontak desa, pengaduan (balas & status), pengumuman (sematkan, sembunyikan, kirim notifikasi), laporan bulanan (salin CSV / simpan file), data contoh & reset.

**Aturan poin (bisa diubah admin)**: Baik = 10 poin/kg, Cukup = 75%, bonus +20 untuk kualitas Baik ≥ 15 kg. Kode penukaran berlaku 7 hari; jika kedaluwarsa, poin & stok otomatis dikembalikan.

## 4. Design system (dari logo)

| Token | Warna | Dipakai untuk |
|---|---|---|
| `primary` | `#5C6A40` hijau daun | tombol utama, ikon aktif |
| `primaryDark` | `#3E4D2F` hijau sawah | hero, teks penekanan |
| `primaryDeep` | `#2D3723` hijau pura | overlay gambar |
| `sage` | `#BDBD9D` perbukitan | latar netral |
| `soil` | `#50412A` tanah | aksen cokelat |
| `gold` | `#D8B43C` lengkung emas | poin, hadiah, indikator aktif |

Huruf: Nunito (Google Fonts) dengan ukuran dasar 16–18. Semua token ada di `lib/core/constants/` dan `lib/core/theme/`.

## 5. Aset gambar (penamaan sama dengan CulTask)

Cukup salin file dari CulTask ke **`assets/images/`**. File yang belum ada **tidak membuat error** — otomatis tampil gradien hijau + ilustrasi SVG bawaan.

| File | Dipakai di |
|---|---|
| `logo.png` | ✅ sudah disertakan (dari logo Anda) — splash, login, onboarding |
| `1.png` | Hero banner beranda warga |
| `2.png` | Kartu & halaman Panduan Kompos |
| `3.png` | Kartu Pengaduan |
| `4.png` | Kartu Pengumuman |
| `5.png` | Kartu Hubungi Desa |
| `cat_daily.png` | Kategori "Setor Kompos" |
| `cat_culture.png` | Kategori "Tukar Hadiah" |
| `cat_work.png` | Kategori "Riwayat Poin" |
| `bg1.png`, `bg2.png`, `bg4.png` | Slide onboarding 1–3 |
| `bg3.png` | Header login/daftar & kartu profil |
| `avatar.png` | Foto di kartu profil |
| `ai.png` | Banner "Butuh bantuan?" |
| `ic_trophy_large.png` | Kartu saldo poin |
| `ic_report.png` | Hero dashboard admin |
| `task.png` | Ringkasan tugas driver |

Ilustrasi SVG bawaan (`assets/illustrations/`) sudah ada. Ikon launcher Android sudah dibuat dari logo; `playstore_icon_512.png` siap diunggah ke Play Console.

## 6. Rilis ke Play Store

1. Buat keystore (sekali saja, simpan baik-baik):
   ```bash
   keytool -genkey -v -keystore ~/kompos-baha-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Buat `android/key.properties` (jangan di-commit):
   ```properties
   storePassword=PASSWORD_ANDA
   keyPassword=PASSWORD_ANDA
   keyAlias=upload
   storeFile=/home/USER/kompos-baha-upload.jks
   ```
3. Naikkan `version:` di `pubspec.yaml` setiap rilis (mis. `1.0.1+2`).
4. Build: `flutter build appbundle --release` → unggah `build/app/outputs/bundle/release/app-release.aab`.
5. Play Console membutuhkan **Kebijakan Privasi** (aplikasi memakai kamera/foto, nama, nomor HP, alamat) dan formulir **Keamanan Data**.

Application ID: `id.desabaha.kompos_baha` — ganti sebelum unggahan pertama jika perlu (tidak bisa diubah setelah rilis).

## 7. Server bersama (penting sebelum dipakai banyak HP)

Saat ini semua data tersimpan **di perangkat** (`LocalDatabaseService`, SharedPreferences) — semua fitur berfungsi penuh, persisten, dan dinamis dalam satu HP (cocok untuk uji coba / satu HP di kantor desa).

Agar warga, driver, TPS, dan admin memakai **HP masing-masing dengan data yang sama**, data harus disimpan di server. Seluruh akses data sudah dipusatkan di:

- `lib/data/services/database_service.dart` — kontrak `DatabaseService`
- `lib/presentation/providers/app_provider.dart` — semua logika bisnis

Buat implementasi `DatabaseService` baru (Firebase Firestore / Supabase / REST API desa) lalu ganti di `main.dart`: `AppProvider(database: ServerDatabaseService())`. Untuk banyak pengguna bersamaan, idealnya tiap koleksi (users, orders, rewards, …) disimpan terpisah di server dan foto diunggah ke storage.

## 8. Struktur

```
lib/
  core/        constants (warna, tipografi, spasi, aset), theme, utils
  data/        models, seed (akun bawaan & data contoh), services (database, foto, kontak)
  presentation/
    providers/ app_provider.dart
    widgets/   common (tombol, header, nav, kartu, form), order (kartu setoran, timeline, driver, tiket)
    screens/   splash, onboarding, auth, shell, common, warga, driver, tps, admin
test/          app_provider_test.dart (alur lengkap end-to-end)
```
