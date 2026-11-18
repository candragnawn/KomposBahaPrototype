import 'package:flutter/material.dart';

/// KOMPOS BAHA Brand Color Palette
/// Diambil langsung dari logo Kompos Baha:
/// hijau daun, hijau sawah tua, sage perbukitan, cokelat tanah, dan emas.
abstract class AppColors {
  // ─── Primary Green Ramp (daun & sawah) ──────────────────────────────────
  static const Color primary = Color(0xFF5C6A40); // hijau daun (logo)
  static const Color primaryDark = Color(0xFF3E4D2F); // hijau sawah tua (logo)
  static const Color primaryDeep = Color(0xFF2D3723); // hijau pura (logo)
  static const Color primaryMedium = Color(0xFF768655);
  static const Color primaryLight = Color(0xFFA9B58A);
  static const Color primarySurface = Color(0xFFF0F2E6);
  static const Color primaryBorder = Color(0xFFDCE1CB);

  // ─── Sage (perbukitan) ──────────────────────────────────────────────────
  static const Color sage = Color(0xFFBDBD9D);
  static const Color sageLight = Color(0xFFEFEFE4);

  // ─── Soil / Tanah ──────────────────────────────────────────────────────
  static const Color soil = Color(0xFF50412A);
  static const Color soilMedium = Color(0xFF7A6446);
  static const Color soilLight = Color(0xFFF4EEE5);

  // ─── Gold / Accent (lengkung emas logo) ────────────────────────────────
  static const Color gold = Color(0xFFD8B43C);
  static const Color goldLight = Color(0xFFFBF3D8);
  static const Color goldDark = Color(0xFFB08E1E);
  static const Color goldText = Color(0xFF5B470C);

  // ─── Neutrals ──────────────────────────────────────────────────────────
  static const Color dark = Color(0xFF1F2618);
  static const Color surface = Color(0xFFF7F7F1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF5D6452); // kontras tinggi utk usia 40-60
  static const Color mutedLight = Color(0xFF8A9080);
  static const Color border = Color(0xFFE2E4D6);
  static const Color disabled = Color(0xFFD5D8C8);

  // ─── Semantic ──────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFFDECEA);
  static const Color warning = Color(0xFFB45F06);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF1F5F8B);
  static const Color infoLight = Color(0xFFE6F0F7);

  // ─── Category Colors (kartu menu) ──────────────────────────────────────
  static const Color categorySetor = Color(0xFFF0F2E6);
  static const Color categoryHadiah = Color(0xFFFBF3D8);
  static const Color categoryRiwayat = Color(0xFFF4EEE5);

  // ─── Gradient ──────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient soilGradient = LinearGradient(
    colors: [soilMedium, soil],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
