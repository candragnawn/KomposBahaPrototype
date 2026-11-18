import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/common/kb_image.dart';

/// Header bergambar untuk layar Masuk/Daftar (pola CulTask _HeroHeader).
class AuthHeroHeader extends StatelessWidget {
  final String subtitle;
  final bool showBack;
  const AuthHeroHeader({super.key, required this.subtitle, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 250 + top,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            KbImage(
              AppAssets.bg3,
              fallback: Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDeep.withValues(alpha: 0.75),
                    AppColors.primaryDark.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 3),
                ),
              ),
            ),
            if (showBack)
              Positioned(
                top: top + 12,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(28, top + 28, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const KbImage(
                      AppAssets.logo,
                      fit: BoxFit.contain,
                      fallback: Icon(Icons.eco_rounded, color: AppColors.primary, size: 40),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'KOMPOS BAHA',
                    style: AppTypography.displayMedium.copyWith(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
