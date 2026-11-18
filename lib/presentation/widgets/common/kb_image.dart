import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';

/// Gambar aset yang aman: jika file belum dimasukkan ke folder assets,
/// otomatis menampilkan [fallback] (tidak error/crash).
class KbImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? fallback;

  const KbImage(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) =>
          fallback ?? SizedBox(width: width, height: height),
    );
  }
}

/// Ilustrasi SVG bawaan Kompos Baha.
class KbSvg extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;

  const KbSvg(this.path, {super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path, width: width, height: height, fit: BoxFit.contain);
  }
}

/// Foto dari penyimpanan HP (hasil kamera).
class KbFileImage extends StatelessWidget {
  final String? path;
  final double height;
  final BorderRadius borderRadius;

  const KbFileImage({
    super.key,
    required this.path,
    this.height = 180,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    final p = path;
    Widget placeholder() => Container(
          height: height,
          decoration: BoxDecoration(color: AppColors.sageLight, borderRadius: borderRadius),
          child: const Center(
            child: Icon(Icons.image_not_supported_rounded, color: AppColors.mutedLight, size: 40),
          ),
        );
    if (p == null || p.isEmpty) return placeholder();
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.file(
        File(p),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder(),
      ),
    );
  }
}

/// Avatar kotak membulat ala CulTask, dengan inisial sebagai cadangan.
class KbAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color color;
  final String? assetPath;

  const KbAvatar({
    super.key,
    required this.name,
    this.size = 46,
    this.color = AppColors.primary,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final initials = Container(
      color: color,
      alignment: Alignment.center,
      child: Text(
        Fmt.initials(name),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
        ),
      ),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.3 - 2),
        child: assetPath == null ? initials : KbImage(assetPath!, fallback: initials),
      ),
    );
  }
}
