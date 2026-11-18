import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/services/photo_service.dart';
import 'kb_image.dart';
import 'kb_widgets.dart';

/// Kotak ambil foto (kamera / galeri) dengan pratinjau besar.
class PhotoPickerTile extends StatelessWidget {
  final String label;
  final String? path;
  final ValueChanged<String> onPicked;
  final VoidCallback? onRemove;
  final bool isRequired;
  final String? errorText;

  const PhotoPickerTile({
    super.key,
    required this.label,
    required this.path,
    required this.onPicked,
    this.onRemove,
    this.isRequired = true,
    this.errorText,
  });

  Future<void> _choose(BuildContext context) async {
    final fromCamera = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Ambil foto dari', style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              ChoiceTile(
                label: 'Kamera',
                description: 'Foto langsung sekarang',
                icon: Icons.photo_camera_rounded,
                selected: false,
                onTap: () => Navigator.of(ctx).pop(true),
              ),
              const SizedBox(height: 10),
              ChoiceTile(
                label: 'Galeri',
                description: 'Pilih foto yang sudah ada',
                icon: Icons.photo_library_rounded,
                selected: false,
                onTap: () => Navigator.of(ctx).pop(false),
              ),
            ],
          ),
        ),
      ),
    );
    if (fromCamera == null) return;
    try {
      final p = await PhotoService.pick(fromCamera: fromCamera);
      if (p != null) onPicked(p);
    } catch (_) {
      if (context.mounted) {
        showKbSnack(context, 'Tidak bisa membuka ${fromCamera ? 'kamera' : 'galeri'}. Periksa izin aplikasi.', error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final has = path != null && path!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AppTypography.titleSmall),
              if (isRequired) Text(' (wajib)', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 8),
          if (has)
            Stack(
              children: [
                KbFileImage(path: path, height: 200),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Row(
                    children: [
                      _OverlayButton(icon: Icons.refresh_rounded, label: 'Ganti', onTap: () => _choose(context)),
                      if (onRemove != null) ...[
                        const SizedBox(width: 8),
                        _OverlayButton(icon: Icons.delete_outline_rounded, label: 'Hapus', onTap: onRemove!),
                      ],
                    ],
                  ),
                ),
              ],
            )
          else
            InkWell(
              onTap: () => _choose(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: errorText != null ? AppColors.error : AppColors.primaryLight,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_rounded, size: 44, color: AppColors.primary),
                    const SizedBox(height: 8),
                    Text('Ketuk untuk ambil foto', style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
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

class _OverlayButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OverlayButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(label, style: AppTypography.labelMedium.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pratinjau foto (bisa diperbesar).
class PhotoPreview extends StatelessWidget {
  final String label;
  final String? path;
  const PhotoPreview({super.key, required this.label, required this.path});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySmall),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: path == null
              ? null
              : () => showDialog<void>(
                    context: context,
                    builder: (ctx) => Dialog(
                      insetPadding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InteractiveViewer(child: KbFileImage(path: path, height: 420)),
                          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Tutup')),
                        ],
                      ),
                    ),
                  ),
          child: KbFileImage(path: path, height: 140),
        ),
      ],
    );
  }
}
