import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app/constants/app_colors.dart';
import '../core/models/offer_stage.dart';

class StatusTimelineWidget extends StatelessWidget {
  final OfferStage stage;

  const StatusTimelineWidget({super.key, required this.stage});

  static const List<String> _steps = [
    'Menunggu konfirmasi',
    'Driver ditugaskan',
    'Dalam penjemputan',
    'Diterima TPS 3R',
    'Poin diberikan',
  ];

  static const List<String> _times = [
    '14 Okt Â· 08.10',
    '14 Okt Â· 08.35',
    '14 Okt Â· 10.02',
    '14 Okt Â· 11.18',
    '14 Okt Â· 15.42',
  ];

  @override
  Widget build(BuildContext context) {
    final currentIdx = stage.stepIndex;

    return Column(
      children: List.generate(_steps.length, (i) {
        final isDone = i < currentIdx;
        final isCurrent = i == currentIdx;
        final isPassed = isDone || isCurrent;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isPassed ? AppColors.primaryGreen : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPassed ? AppColors.primaryGreen : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: isPassed
                      ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                      : null,
                ),
                if (i < _steps.length - 1)
                  Container(
                    width: 2,
                    height: 36,
                    color: isDone ? AppColors.primaryGreen : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _steps[i],
                      style: TextStyle(
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                        fontSize: 14,
                        color: isPassed ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPassed ? _times[i] : 'Menunggu',
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

