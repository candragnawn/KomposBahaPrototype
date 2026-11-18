import 'package:flutter/material.dart';

/// KOMPOS BAHA Spacing Constants (mengikuti pola CulTask)
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Tinggi minimum tombol & area sentuh (ramah lansia).
  static const double buttonHeight = 58;
  static const double touchTarget = 52;

  /// Lebar konten maksimum di tablet.
  static const double maxContentWidth = 720;

  // ─── SizedBox shortcuts ────────────────────────────────────────────────
  static const Widget hXs = SizedBox(width: xs);
  static const Widget hSm = SizedBox(width: sm);
  static const Widget hMd = SizedBox(width: md);
  static const Widget hLg = SizedBox(width: lg);
  static const Widget hXl = SizedBox(width: xl);

  static const Widget vXs = SizedBox(height: xs);
  static const Widget vSm = SizedBox(height: sm);
  static const Widget vMd = SizedBox(height: md);
  static const Widget vLg = SizedBox(height: lg);
  static const Widget vXl = SizedBox(height: xl);
  static const Widget vXxl = SizedBox(height: xxl);
  static const Widget vXxxl = SizedBox(height: xxxl);

  // ─── Padding Helpers ───────────────────────────────────────────────────
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(xl, xl, xl, xxxl);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: xl, vertical: md);

  // ─── Border Radius ─────────────────────────────────────────────────────
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(10));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(14));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(18));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(99));
}
