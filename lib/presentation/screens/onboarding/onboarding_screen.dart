import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_image.dart';

class _Slide {
  final String image;
  final String svg;
  final String title;
  final String body;
  const _Slide(this.image, this.svg, this.title, this.body);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      AppAssets.bg1,
      AppAssets.compostBin,
      'Olah sampah dapur jadi kompos',
      'Sisa sayur, buah, dan daun bisa diolah menjadi kompos di rumah. Lebih bersih, lebih sehat untuk Desa Baha.',
    ),
    _Slide(
      AppAssets.bg2,
      AppAssets.pickupTruck,
      'Kompos dijemput ke rumah',
      'Cukup foto komposnya dan pilih jadwal. Driver desa akan menjemput dan membawanya ke TPS 3R.',
    ),
    _Slide(
      AppAssets.bg4,
      AppAssets.giftBox,
      'Kumpulkan poin, tukar hadiah',
      'Setiap kilogram kompos jadi poin. Tukar poin dengan bibit, beras, atau hadiah lain di Kantor Desa.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
    } else {
      context.read<AppProvider>().completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                children: [
                  const KbImage(AppAssets.logo, width: 44, height: 44, fit: BoxFit.contain,
                      fallback: Icon(Icons.eco_rounded, color: AppColors.primary, size: 36)),
                  const SizedBox(width: 10),
                  Text('Kompos Baha', style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark)),
                  const Spacer(),
                  if (!isLast)
                    TextButton(
                      onPressed: () => context.read<AppProvider>().completeOnboarding(),
                      child: const Text('Lewati'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final s = _slides[i];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: KbImage(
                              s.image,
                              fallback: Padding(
                                padding: const EdgeInsets.all(36),
                                child: KbSvg(s.svg),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(s.title, textAlign: TextAlign.center, style: AppTypography.displayMedium),
                        const SizedBox(height: 12),
                        Text(
                          s.body,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i == _page ? AppColors.primary : AppColors.sage,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: KbButton(
                label: isLast ? 'Mulai sekarang' : 'Lanjut',
                icon: isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
