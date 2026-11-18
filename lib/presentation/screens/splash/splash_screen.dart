import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/common/kb_image.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const KbImage(
              AppAssets.logo,
              width: 170,
              height: 170,
              fit: BoxFit.contain,
              fallback: Icon(Icons.eco_rounded, size: 120, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text('KOMPOS BAHA', style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark, letterSpacing: 2)),
            const SizedBox(height: 6),
            Text('Sampah jadi berkah untuk Desa Baha', style: AppTypography.bodyMedium.copyWith(color: AppColors.muted)),
            const SizedBox(height: 32),
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(strokeWidth: 3.5, color: AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}
