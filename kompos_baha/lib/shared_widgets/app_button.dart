import 'package:flutter/material.dart';
import '../app/constants/app_colors.dart';

enum ButtonVariant { primary, secondary, danger, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool wide;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.secondary,
    this.icon,
    this.wide = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Row(
            mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          );

    final btnStyle = ElevatedButton.styleFrom(
      minimumSize: wide ? const Size.fromHeight(44) : const Size(0, 40),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 0,
    );

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          style: btnStyle.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.primaryGreen.withValues(alpha: 0.5);
              }
              return AppColors.primaryGreen;
            }),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
          ),
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case ButtonVariant.danger:
        return ElevatedButton(
          style: btnStyle.copyWith(
            backgroundColor: const WidgetStatePropertyAll(AppColors.error),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
          ),
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryGreen,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: child,
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: wide ? const Size.fromHeight(44) : const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: const BorderSide(color: AppColors.border),
            foregroundColor: AppColors.ink,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
    }
  }
}

