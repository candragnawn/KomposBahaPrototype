import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/theme/card_theme.dart';
import 'kb_image.dart';

/// Hero banner bergambar (ala CulTask) dengan lapisan gradien hijau.
/// Jika gambar belum ada, otomatis tampil gradien hijau + ilustrasi SVG.
class HeroBanner extends StatelessWidget {
  final String imagePath;
  final String tag;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;
  final String? fallbackSvg;

  const HeroBanner({
    super.key,
    required this.imagePath,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
    this.fallbackSvg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 230),
      decoration: AppCardTheme.heroCard(),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: KbImage(
              imagePath,
              fallback: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(12),
                child: fallbackSvg == null ? null : Opacity(opacity: 0.95, child: KbSvg(fallbackSvg!, width: 140, height: 120)),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primaryDeep.withValues(alpha: 0.88),
                    AppColors.primaryDark.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(tag, style: AppTypography.labelMedium.copyWith(color: AppColors.dark)),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTypography.displayMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                  ),
                ),
                const SizedBox(height: 18),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(buttonLabel, style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: AppColors.primaryDark),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu kategori layanan (ala CulTask _CategoryCard).
class CategoryCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final String fallbackSvg;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.fallbackSvg,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: textColor.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 6),
                  child: KbImage(
                    imagePath,
                    fit: BoxFit.contain,
                    fallback: KbSvg(fallbackSvg),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 14),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppTypography.titleSmall.copyWith(color: textColor, height: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu menu bergambar dengan overlay gelap (ala CulTask _LearningModeCard).
class MenuImageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String imagePath;
  final Color accent;
  final String? badge;
  final VoidCallback onTap;

  const MenuImageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imagePath,
    required this.accent,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 14, offset: const Offset(0, 4))],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: KbImage(
                  imagePath,
                  fallback: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, Color.lerp(accent, Colors.black, 0.35)!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.6)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -16,
                right: -16,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(99)),
                    child: Text(badge!, style: AppTypography.labelSmall.copyWith(color: AppColors.dark)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Icon(icon, color: Colors.white, size: 26),
                    ),
                    const Spacer(),
                    Text(title, style: AppTypography.titleMedium.copyWith(color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner bantuan di bawah beranda (ala CulTask AI banner).
class HelpBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  const HelpBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.soilGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: AppColors.soil.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: const KbImage(
              'assets/images/ai.png',
              fallback: Icon(Icons.support_agent_rounded, color: Colors.white, size: 34),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium.copyWith(color: Colors.white)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                const SizedBox(height: 10),
                Material(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.chat_rounded, size: 20, color: AppColors.dark),
                          const SizedBox(width: 6),
                          Text(buttonLabel, style: AppTypography.labelLarge.copyWith(color: AppColors.dark)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu saldo poin emas.
class PointsBalanceCard extends StatelessWidget {
  final int points;
  final String caption;
  final VoidCallback? onTap;
  const PointsBalanceCard({super.key, required this.points, required this.caption, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppCardTheme.goldCard(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saldo poin Anda', style: AppTypography.bodyMedium.copyWith(color: AppColors.goldText)),
                  const SizedBox(height: 4),
                  Text(
                    _fmt(points),
                    style: AppTypography.displayLarge.copyWith(color: AppColors.dark, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(caption, style: AppTypography.bodySmall.copyWith(color: AppColors.goldText)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const SizedBox(
              width: 86,
              height: 86,
              child: KbImage(
                'assets/images/ic_trophy_large.png',
                fit: BoxFit.contain,
                fallback: KbSvg('assets/illustrations/ledger_coin.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      b.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) b.write('.');
    }
    return b.toString();
  }
}
