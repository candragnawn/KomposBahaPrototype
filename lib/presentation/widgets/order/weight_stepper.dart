import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';

/// Pengatur berat dengan tombol − / + besar (tanpa perlu mengetik).
class WeightStepper extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final double step;
  final String unit;

  const WeightStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 100,
    this.step = 1,
    this.unit = 'kg',
  });

  void _set(double v) {
    final clamped = v.clamp(min, max).toDouble();
    if (clamped != value) {
      HapticFeedback.selectionClick();
      onChanged(clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _RoundButton(icon: Icons.remove_rounded, onTap: value > min ? () => _set(value - step) : null, label: 'Kurangi'),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      Fmt.kg(value),
                      style: AppTypography.displayLarge.copyWith(fontSize: 40, color: AppColors.primaryDark),
                    ),
                    Text(unit, style: AppTypography.titleSmall.copyWith(color: AppColors.muted)),
                  ],
                ),
              ),
              _RoundButton(icon: Icons.add_rounded, onTap: value < max ? () => _set(value + step) : null, label: 'Tambah'),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final q in const [5.0, 10.0, 15.0, 20.0, 30.0])
                if (q >= min && q <= max)
                  ChoiceChip(
                    label: Text('${Fmt.kg(q)} $unit'),
                    selected: value == q,
                    onSelected: (_) => _set(q),
                    selectedColor: AppColors.primary,
                    labelStyle: AppTypography.labelLarge.copyWith(
                      color: value == q ? Colors.white : AppColors.primaryDark,
                    ),
                    showCheckmark: false,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String label;
  const _RoundButton({required this.icon, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: enabled ? AppColors.primary : AppColors.disabled,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(icon, color: Colors.white, size: 34),
          ),
        ),
      ),
    );
  }
}
