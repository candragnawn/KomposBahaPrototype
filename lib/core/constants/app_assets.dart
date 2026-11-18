/// Daftar aset gambar.
/// Penamaan file SAMA dengan CulTask, jadi cukup salin file gambar CulTask
/// ke folder `assets/images/`. Jika file belum ada, aplikasi otomatis
/// menampilkan tampilan cadangan (gradien + ikon), jadi tidak akan error.
abstract class AppAssets {
  static const String _img = 'assets/images';
  static const String _ill = 'assets/illustrations';

  // ─── Brand ─────────────────────────────────────────────────────────────
  static const String logo = '$_img/logo.png';
  static const String avatar = '$_img/avatar.png';
  static const String ai = '$_img/ai.png';

  // ─── Hero & menu backgrounds (sama dengan CulTask) ─────────────────────
  static const String hero = '$_img/1.png';
  static const String menuPanduan = '$_img/2.png';
  static const String menuPengaduan = '$_img/3.png';
  static const String menuPengumuman = '$_img/4.png';
  static const String menuBantuan = '$_img/5.png';

  // ─── Kategori layanan ──────────────────────────────────────────────────
  static const String catSetor = '$_img/cat_daily.png';
  static const String catHadiah = '$_img/cat_culture.png';
  static const String catRiwayat = '$_img/cat_work.png';

  // ─── Background onboarding / login ─────────────────────────────────────
  static const String bg1 = '$_img/bg1.png';
  static const String bg2 = '$_img/bg2.png';
  static const String bg3 = '$_img/bg3.png';
  static const String bg4 = '$_img/bg4.png';
  static const String bg5 = '$_img/bg5.png';

  // ─── Badge & ikon ──────────────────────────────────────────────────────
  static const String badge = '$_img/badge.png';
  static const String badgeClean = '$_img/badge_clean.png';
  static const String badgeStreak = '$_img/badge_streak.png';
  static const String badgeWork = '$_img/badge_work.png';
  static const String badgeCanang = '$_img/badge_canang.png';
  static const String streak = '$_img/streak.png';
  static const String level = '$_img/level.png';
  static const String trophy = '$_img/ic_trophy_large.png';
  static const String report = '$_img/ic_report.png';
  static const String icBadge = '$_img/ic_badge.png';
  static const String icLevelBadge = '$_img/ic_level_badge.png';
  static const String task = '$_img/task.png';

  // ─── Ilustrasi bawaan Kompos Baha (SVG, sudah tersedia) ────────────────
  static const String compostBin = '$_ill/compost_bin.svg';
  static const String pickupTruck = '$_ill/pickup_truck.svg';
  static const String giftBox = '$_ill/gift_box.svg';
  static const String ledgerCoin = '$_ill/ledger_coin.svg';
}
