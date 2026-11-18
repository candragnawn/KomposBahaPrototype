import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

enum KbButtonVariant { primary, secondary, danger, gold, ghost, soft }

/// Tombol utama Kompos Baha — besar, jelas, mudah ditekan.
class KbButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final KbButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final bool compact;

  const KbButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = KbButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;

    final (Color bg, Color fg, Color? border) = switch (variant) {
      KbButtonVariant.primary => (AppColors.primary, AppColors.white, null),
      KbButtonVariant.secondary => (AppColors.white, AppColors.primary, AppColors.primary),
      KbButtonVariant.danger => (AppColors.errorLight, AppColors.error, AppColors.error.withValues(alpha: 0.35)),
      KbButtonVariant.gold => (AppColors.gold, AppColors.dark, null),
      KbButtonVariant.ghost => (Colors.transparent, AppColors.primary, null),
      KbButtonVariant.soft => (AppColors.primarySurface, AppColors.primaryDark, null),
    };

    final height = compact ? 46.0 : AppSpacing.buttonHeight;
    final textStyle = (compact ? AppTypography.buttonSmall : AppTypography.button)
        .copyWith(color: disabled ? AppColors.muted : fg);

    final content = loading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.6, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: compact ? 20 : 24, color: disabled ? AppColors.muted : fg),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = Material(
      color: disabled && variant != KbButtonVariant.ghost ? AppColors.disabled : bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: disabled
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        child: Container(
          constraints: BoxConstraints(minHeight: height),
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 20, vertical: 10),
          decoration: border == null || disabled
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border, width: 2),
                ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Tombol ikon kotak membulat (ala CulTask).
class KbIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final Color background;
  final bool showDot;
  final String? tooltip;
  final double size;

  const KbIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color = AppColors.dark,
    this.background = AppColors.white,
    this.showDot = false,
    this.tooltip,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            if (showDot)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return tooltip == null ? child : Tooltip(message: tooltip!, child: child);
  }
}
