import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KOMPOS BAHA Card Theme (pola sama dengan CulTask AppCardTheme)
// Palet: Hijau daun (#5C6A40) + Emas (#D8B43C) + Tanah (#50412A)
// ─────────────────────────────────────────────────────────────────────────────

class AppCardTheme {
  AppCardTheme._();

  static const double radiusSmall = 12.0;
  static const double radiusMedium = 18.0;
  static const double radiusLarge = 22.0;
  static const double radiusXL = 26.0;

  /// Kartu standar — putih, shadow hijau halus.
  static BoxDecoration card() => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F3E4D2F),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      );

  /// Kartu dengan warna latar lembut.
  static BoxDecoration tinted({required Color color, Color? borderColor}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(color: borderColor ?? AppColors.primaryBorder),
      );

  /// Kartu hero — gradient hijau dengan shadow kuat.
  static BoxDecoration heroCard() => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radiusXL),
        boxShadow: const [
          BoxShadow(
            color: Color(0x403E4D2F),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      );

  /// Kartu emas — untuk poin & hadiah.
  static BoxDecoration goldCard() => BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40D8B43C),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      );

  /// Kartu statistik ringkasan.
  static BoxDecoration statsCard() => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
