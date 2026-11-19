import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/common/kb_image.dart';

/// Splash screen beranimasi (tanpa paket tambahan).
///
/// Urutan animasi (±2 detik):
/// 1. Lengkung emas (seperti di logo) tergambar melingkar.
/// 2. Logo muncul membesar dengan efek pantul lembut.
/// 3. Judul GOBAHA naik perlahan & huruf merenggang.
/// 4. Tagline muncul, lalu tiga titik pemuatan berdenyut.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  // Setiap elemen punya jendela waktu sendiri (Interval) agar muncul bertahap.
  late final Animation<double> _ring = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.0, 0.55, curve: Curves.easeInOutCubic),
  );
  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.15, 0.6, curve: Curves.easeOutBack),
  );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.15, 0.4, curve: Curves.easeOut),
  );
  late final Animation<double> _title = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.45, 0.8, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _tagline = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    _intro.forward().whenComplete(() {
      if (mounted) _dots.repeat();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hormati pengaturan "kurangi animasi" di HP pengguna.
    if (MediaQuery.of(context).disableAnimations) {
      _intro.value = 1;
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _dots.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const logoSize = 150.0;
    const ringSize = 196.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Latar: gradasi sage sangat halus dari bawah.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.white, AppColors.primarySurface.withValues(alpha: 0.7)],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo + lengkung emas ──
                SizedBox(
                  width: ringSize,
                  height: ringSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _ring,
                        builder: (_, _) => CustomPaint(
                          size: const Size.square(ringSize),
                          painter: _RingPainter(progress: _ring.value),
                        ),
                      ),
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: Tween(begin: 0.6, end: 1.0).animate(_logoScale),
                          child: const KbImage(
                            AppAssets.logo,
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                            fallback: Icon(Icons.eco_rounded, size: 110, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Judul: naik + huruf merenggang ──
                AnimatedBuilder(
                  animation: _title,
                  builder: (_, child) => Opacity(
                    opacity: _title.value,
                    child: Transform.translate(
                      offset: Offset(0, 24 * (1 - _title.value)),
                      child: Text(
                        'GOBAHA',
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2 + 6 * _title.value,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Tagline ──
                FadeTransition(
                  opacity: _tagline,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(_tagline),
                    child: Text(
                      'Sampah jadi berkah untuk Desa Baha',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // ── Titik pemuatan berdenyut ──
                FadeTransition(
                  opacity: _tagline,
                  child: AnimatedBuilder(
                    animation: _dots,
                    builder: (_, _) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < 3; i++) _dot(i),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Identitas di bawah ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: SafeArea(
              top: false,
              child: FadeTransition(
                opacity: _tagline,
                child: Text(
                  'Aksara Sirkular Desa Baha · Universitas Udayana',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.mutedLight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Titik ke-i membesar-mengecil bergiliran (gelombang).
  Widget _dot(int i) {
    final t = (_dots.value - i * 0.18) % 1.0;
    final wave = math.sin(t * math.pi).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10 + 4 * wave,
      height: 10 + 4 * wave,
      decoration: BoxDecoration(
        color: Color.lerp(AppColors.sage, AppColors.gold, wave),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Menggambar lengkung emas melingkar seperti pada logo GoBAHA.
class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = AppColors.primarySurface;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.gold;

    final inset = rect.deflate(6);
    canvas.drawArc(inset, 0, 2 * math.pi, false, track);
    // Mulai dari kiri bawah, melengkung lewat atas (seperti busur di logo).
    canvas.drawArc(inset, math.pi * 0.85, math.pi * 1.3 * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}