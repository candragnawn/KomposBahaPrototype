import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/theme/card_theme.dart';
import 'custom_button.dart';

// ─── Layout ─────────────────────────────────────────────────────────────────

/// Membatasi lebar konten di tablet agar tetap nyaman dibaca.
class KbResponsive extends StatelessWidget {
  final Widget child;
  const KbResponsive({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: child,
      ),
    );
  }
}

/// Halaman scroll standar dengan padding & batas lebar.
class KbScrollPage extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final Future<void> Function()? onRefresh;

  const KbScrollPage({
    super.key,
    required this.children,
    this.padding = AppSpacing.screenPadding,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: padding,
      children: [
        KbResponsive(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
        ),
      ],
    );
    if (onRefresh == null) return list;
    return RefreshIndicator(onRefresh: onRefresh!, color: AppColors.primary, child: list);
  }
}

/// Bar tombol yang menempel di bawah layar.
class KbBottomActionBar extends StatelessWidget {
  final List<Widget> children;
  const KbBottomActionBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: KbResponsive(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Kartu ──────────────────────────────────────────────────────────────────

class KbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  const KbCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final deco = color == null
        ? AppCardTheme.card()
        : AppCardTheme.tinted(color: color!, borderColor: borderColor);
    return Container(
      decoration: deco,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppCardTheme.radiusMedium),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Judul bagian + tautan "Lihat semua".
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.subtitle, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleLarge.copyWith(letterSpacing: -0.3),
                ),
              ),
              if (actionLabel != null)
                InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(actionLabel!, style: AppTypography.labelLarge),
                        const SizedBox(width: 2),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 22),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: AppTypography.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Tampilan kosong yang ramah.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: AppCardTheme.tinted(color: AppColors.white, borderColor: AppColors.border),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
            child: Icon(icon, size: 38, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(message, style: AppTypography.bodyMedium.copyWith(color: AppColors.muted), textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            KbButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
        ],
      ),
    );
  }
}

/// Label status berbentuk pil.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  const StatusPill({super.key, required this.label, required this.color, required this.background, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Baris label : nilai.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  const InfoRow({super.key, required this.label, required this.value, this.valueColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 10),
          ],
          Expanded(
            flex: 4,
            child: Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.muted)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.titleSmall.copyWith(color: valueColor ?? AppColors.dark),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu statistik kecil (ala CulTask QuickStats).
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: AppCardTheme.statsCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTypography.titleLarge.copyWith(letterSpacing: -0.3),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Form ───────────────────────────────────────────────────────────────────

/// Kolom isian dengan label tebal di atasnya (lebih jelas untuk lansia).
class KbTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helper;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscure;
  final int maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextCapitalization textCapitalization;

  const KbTextField({
    super.key,
    required this.label,
    this.hint,
    this.helper,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.obscure = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffix,
    this.textInputAction,
    this.onChanged,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.titleSmall),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: obscure,
            maxLines: obscure ? 1 : maxLines,
            maxLength: maxLength,
            enabled: enabled,
            onChanged: onChanged,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              helperText: helper,
              helperMaxLines: 3,
              helperStyle: AppTypography.bodySmall,
              prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 24),
              suffixIcon: suffix,
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }
}

/// Pilihan dalam bentuk kotak besar (pengganti radio/dropdown kecil).
class ChoiceTile extends StatelessWidget {
  final String label;
  final String? description;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  const ChoiceTile({
    super.key,
    required this.label,
    this.description,
    this.icon,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final fg = !enabled ? AppColors.mutedLight : (selected ? AppColors.primaryDark : AppColors.dark);
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: !enabled ? AppColors.sageLight : (selected ? AppColors.primarySurface : AppColors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2.2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: selected ? AppColors.primary : AppColors.muted, size: 26),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.titleSmall.copyWith(color: fg)),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(description!, style: AppTypography.bodySmall),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: selected ? AppColors.primary : AppColors.disabled,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kolom pilihan yang membuka daftar besar di bawah layar.
class KbSelectField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final String hint;
  final IconData? icon;
  final String? errorText;

  const KbSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.hint = 'Pilih',
    this.icon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final v = value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.titleSmall),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              final picked = await showOptionSheet<T>(
                context: context,
                title: label,
                options: options,
                labelOf: labelOf,
                selected: v,
              );
              if (picked != null) onChanged(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: errorText != null ? AppColors.error : AppColors.border, width: 1.5),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      v == null ? hint : labelOf(v),
                      style: AppTypography.bodyLarge.copyWith(
                        color: v == null ? AppColors.mutedLight : AppColors.dark,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 28),
                ],
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(errorText!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ),
        ],
      ),
    );
  }
}

/// Lembar pilihan dari bawah layar.
Future<T?> showOptionSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required String Function(T) labelOf,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final maxH = MediaQuery.of(ctx).size.height * 0.75;
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(title, style: AppTypography.titleLarge),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final o = options[i];
                    return ChoiceTile(
                      label: labelOf(o),
                      selected: o == selected,
                      onTap: () => Navigator.of(ctx).pop(o),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ─── Dialog & snackbar ──────────────────────────────────────────────────────

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Ya, lanjutkan',
  String cancelLabel = 'Batal',
  bool danger = false,
  IconData? icon,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(
        icon ?? (danger ? Icons.warning_amber_rounded : Icons.help_outline_rounded),
        color: danger ? AppColors.error : AppColors.primary,
        size: 44,
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KbButton(
              label: confirmLabel,
              variant: danger ? KbButtonVariant.danger : KbButtonVariant.primary,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
            const SizedBox(height: 10),
            KbButton(
              label: cancelLabel,
              variant: KbButtonVariant.ghost,
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Dialog isian teks (mis. alasan pembatalan).
Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  required String label,
  String? hint,
  String confirmLabel = 'Simpan',
  List<String> quickOptions = const [],
  bool danger = false,
  String initial = '',
  int maxLines = 3,
  TextInputType? keyboardType,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _TextInputSheet(
      title: title,
      label: label,
      hint: hint,
      confirmLabel: confirmLabel,
      quickOptions: quickOptions,
      danger: danger,
      initial: initial,
      maxLines: maxLines,
      keyboardType: keyboardType,
    ),
  );
}

class _TextInputSheet extends StatefulWidget {
  final String title;
  final String label;
  final String? hint;
  final String confirmLabel;
  final List<String> quickOptions;
  final bool danger;
  final String initial;
  final int maxLines;
  final TextInputType? keyboardType;

  const _TextInputSheet({
    required this.title,
    required this.label,
    this.hint,
    required this.confirmLabel,
    required this.quickOptions,
    required this.danger,
    required this.initial,
    required this.maxLines,
    this.keyboardType,
  });

  @override
  State<_TextInputSheet> createState() => _TextInputSheetState();
}

class _TextInputSheetState extends State<_TextInputSheet> {
  late final TextEditingController _c = TextEditingController(text: widget.initial);
  String? _selectedQuick;
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _c.text.trim();
    final value = text.isNotEmpty ? text : (_selectedQuick ?? '');
    if (value.isEmpty) {
      setState(() => _error = 'Mohon isi atau pilih salah satu.');
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              if (widget.quickOptions.isNotEmpty) ...[
                for (final o in widget.quickOptions) ...[
                  ChoiceTile(
                    label: o,
                    selected: _selectedQuick == o,
                    onTap: () => setState(() {
                      _selectedQuick = o;
                      _c.clear();
                      _error = null;
                    }),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 6),
              ],
              KbTextField(
                label: widget.quickOptions.isEmpty ? widget.label : 'Atau tulis sendiri',
                hint: widget.hint,
                controller: _c,
                maxLines: widget.maxLines,
                keyboardType: widget.keyboardType,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) {
                  if (_selectedQuick != null || _error != null) {
                    setState(() {
                      _selectedQuick = null;
                      _error = null;
                    });
                  }
                },
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                ),
              KbButton(
                label: widget.confirmLabel,
                variant: widget.danger ? KbButtonVariant.danger : KbButtonVariant.primary,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showKbSnack(BuildContext context, String message, {bool error = false}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: error ? AppColors.error : AppColors.primaryDark,
        duration: Duration(seconds: error ? 4 : 3),
        content: Row(
          children: [
            Icon(error ? Icons.error_outline_rounded : Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}

/// Segmented tab besar (pengganti TabBar kecil).
class KbSegmented extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  const KbSegmented({super.key, required this.labels, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.sageLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: i == index
                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleSmall.copyWith(
                      color: i == index ? AppColors.primaryDark : AppColors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip filter horizontal.
class KbFilterChips extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  const KbFilterChips({super.key, required this.labels, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final sel = i == index;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sel ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: 1.5),
              ),
              child: Text(
                labels[i],
                style: AppTypography.labelLarge.copyWith(color: sel ? AppColors.white : AppColors.dark),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Kotak info / peringatan.
class InfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Color background;
  final String? title;

  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline_rounded,
    this.color = AppColors.info,
    this.background = AppColors.infoLight,
    this.title,
  });

  const InfoBanner.warning({super.key, required this.message, this.title})
      : icon = Icons.warning_amber_rounded,
        color = AppColors.warning,
        background = AppColors.warningLight;

  const InfoBanner.success({super.key, required this.message, this.title})
      : icon = Icons.check_circle_rounded,
        color = AppColors.success,
        background = AppColors.successLight;

  const InfoBanner.error({super.key, required this.message, this.title})
      : icon = Icons.error_outline_rounded,
        color = AppColors.error,
        background = AppColors.errorLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(title!, style: AppTypography.titleSmall.copyWith(color: color)),
                  const SizedBox(height: 2),
                ],
                Text(message, style: AppTypography.bodyMedium.copyWith(color: AppColors.dark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu baris (dipakai di profil & menu admin).
class KbMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color color;
  final Widget? trailing;
  final int badge;

  const KbMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.color = AppColors.primary,
    this.trailing,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  if (subtitle != null) Text(subtitle!, style: AppTypography.bodySmall),
                ],
              ),
            ),
            if (badge > 0)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(99)),
                child: Text('$badge', style: AppTypography.labelMedium.copyWith(color: Colors.white)),
              ),
            trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.mutedLight, size: 28),
          ],
        ),
      ),
    );
  }
}

/// Kelompok menu dalam satu kartu.
class KbMenuGroup extends StatelessWidget {
  final List<Widget> children;
  const KbMenuGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppCardTheme.card(),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(indent: 76),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
