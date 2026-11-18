import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// KOMPOS BAHA Typography System
/// Ukuran huruf sengaja dibuat lebih besar dari standar agar nyaman
/// dibaca oleh pengguna usia 40-60 tahun.
abstract class AppTypography {
  // ─── Display / Heading ─────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.nunito(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.dark,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.nunito(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.dark,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get displaySmall => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.dark,
        height: 1.3,
      );

  // ─── Title ─────────────────────────────────────────────────────────────
  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.dark,
        height: 1.35,
      );

  static TextStyle get titleMedium => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.dark,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.dark,
        height: 1.4,
      );

  // ─── Body ──────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.dark,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.dark,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
        height: 1.45,
      );

  // ─── Label ─────────────────────────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        height: 1.2,
      );

  static TextStyle get labelMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        height: 1.2,
      );

  static TextStyle get labelSmall => GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.muted,
        letterSpacing: 0.2,
        height: 1.2,
      );

  // ─── Button ────────────────────────────────────────────────────────────
  static TextStyle get button => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        height: 1.1,
      );

  static TextStyle get buttonSmall => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        height: 1.1,
      );
}
