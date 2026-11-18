import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';

/// Panduan membuat kompos rumah tangga yang diterima TPS 3R.
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  static const _steps = [
    ('Siapkan wadah', 'Gunakan ember/tong berlubang kecil di bagian bawah atau komposter. Letakkan di tempat teduh.', Icons.delete_outline_rounded),
    ('Lapisan dasar cokelat', 'Taruh daun kering, serbuk gergaji, atau sekam setebal ±5 cm di dasar wadah.', Icons.layers_rounded),
    ('Masukkan sampah hijau', 'Potong kecil sisa sayur, kulit buah, dan ampas kopi/teh lalu masukkan ke wadah.', Icons.eco_rounded),
    ('Tutup dengan bahan cokelat', 'Setiap menambah sampah hijau, tutup lagi dengan daun kering agar tidak berbau.', Icons.compost_rounded),
    ('Aduk seminggu sekali', 'Aduk agar udara masuk. Jika terlalu kering, percikkan sedikit air. Jika becek, tambah daun kering.', Icons.autorenew_rounded),
    ('Tunggu 4–8 minggu', 'Kompos matang berwarna cokelat kehitaman, gembur, dan berbau seperti tanah.', Icons.hourglass_bottom_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KbAppBar(title: 'Panduan Kompos'),
      body: KbScrollPage(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: const KbImage(
              AppAssets.menuPanduan,
              fallback: Padding(padding: EdgeInsets.all(20), child: KbSvg(AppAssets.compostBin)),
            ),
          ),
          const SizedBox(height: 20),
          Text('Membuat kompos di rumah', style: AppTypography.displaySmall),
          const SizedBox(height: 6),
          Text(
            'Ikuti langkah sederhana ini agar kompos Anda diterima TPS 3R dan mendapat poin penuh.',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ListCard(
                  title: 'Boleh',
                  color: AppColors.success,
                  background: AppColors.successLight,
                  icon: Icons.check_circle_rounded,
                  items: const ['Sisa sayur & buah', 'Daun & rumput', 'Ampas kopi/teh', 'Kulit telur', 'Sisa canang (tanpa plastik)'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ListCard(
                  title: 'Jangan',
                  color: AppColors.error,
                  background: AppColors.errorLight,
                  icon: Icons.cancel_rounded,
                  items: const ['Plastik & kresek', 'Kaca, kaleng, logam', 'Daging & tulang', 'Minyak & santan', 'Popok & tisu basah'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Langkah membuat kompos'),
          for (int i = 0; i < _steps.length; i++) ...[
            KbCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(16)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(_steps[i].$3, color: AppColors.primary, size: 28),
                        Positioned(
                          top: 2,
                          left: 4,
                          child: Text('${i + 1}', style: AppTypography.labelMedium.copyWith(color: AppColors.goldDark)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i + 1}. ${_steps[i].$1}', style: AppTypography.titleMedium),
                        const SizedBox(height: 4),
                        Text(_steps[i].$2, style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          const SectionHeader(title: 'Ciri kompos siap disetor'),
          const InfoBanner.success(
            title: 'Diterima dengan kualitas Baik',
            message: '• Cokelat kehitaman & gembur\n• Berbau tanah, tidak busuk\n• Tidak becek saat digenggam\n• Bersih dari plastik & sampah anorganik',
          ),
          const SizedBox(height: 12),
          const InfoBanner.warning(
            title: 'Kualitas Cukup (poin dikurangi)',
            message: 'Kompos masih sedikit kasar atau agak lembap, tetapi tidak berbau busuk.',
          ),
          const SizedBox(height: 12),
          const InfoBanner.error(
            title: 'Ditolak',
            message: 'Tercampur plastik, masih berbau busuk/belum matang, atau terlalu becek.',
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Tips sebelum dijemput'),
          const InfoBanner(
            message: '1. Masukkan kompos ke karung atau ember tertutup.\n'
                '2. Letakkan di depan rumah sesuai jam penjemputan.\n'
                '3. Pastikan nomor HP aktif agar driver bisa menghubungi.',
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final String title;
  final Color color;
  final Color background;
  final IconData icon;
  final List<String> items;

  const _ListCard({
    required this.title,
    required this.color,
    required this.background,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 6),
              Text(title, style: AppTypography.titleMedium.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          for (final it in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text('• $it', style: AppTypography.bodyMedium),
            ),
        ],
      ),
    );
  }
}
