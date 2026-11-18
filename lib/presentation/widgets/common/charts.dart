import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';

/// Grafik batang sederhana (tanpa paket tambahan).
class SimpleBarChart extends StatelessWidget {
  final List<(String, double)> data;
  final String unit;
  final double height;
  final Color color;

  const SimpleBarChart({
    super.key,
    required this.data,
    this.unit = 'kg',
    this.height = 190,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    double maxV = 0;
    for (final d in data) {
      if (d.$2 > maxV) maxV = d.$2;
    }
    if (maxV <= 0) maxV = 1;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < data.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Fmt.kg(data[i].$2),
                        style: AppTypography.labelSmall.copyWith(
                          color: i == data.length - 1 ? AppColors.primaryDark : AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: (data[i].$2 / maxV).clamp(0.03, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: i == data.length - 1 ? AppColors.gold : color.withValues(alpha: 0.85),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(data[i].$1, style: AppTypography.labelSmall),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Bar progres horizontal dengan label (mis. kuota harian).
class ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final String trailing;
  final Color color;

  const ProgressRow({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.trailing,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    final c = ratio >= 0.9 ? AppColors.error : (ratio >= 0.7 ? AppColors.warning : color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTypography.bodyMedium)),
              Text(trailing, style: AppTypography.titleSmall.copyWith(color: c)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              backgroundColor: AppColors.sageLight,
              valueColor: AlwaysStoppedAnimation(c),
            ),
          ),
        ],
      ),
    );
  }
}
