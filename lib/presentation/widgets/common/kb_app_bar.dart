import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import 'custom_button.dart';
import 'kb_image.dart';

/// AppBar standar (halaman turunan) — tombol kembali kotak + judul tengah.
/// Pola sama dengan CultaskAppBar.
class KbAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;
  final Color backgroundColor;

  const KbAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.trailing,
    this.backgroundColor = AppColors.white,
  });

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            child: showBack && canPop
                ? Center(
                    child: Semantics(
                      button: true,
                      label: 'Kembali',
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.primary),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.titleLarge,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 68,
            child: trailing == null ? null : Center(child: trailing),
          ),
        ],
      ),
    );
  }
}

/// Header utama tab (SliverAppBar) — judul besar, nama pengguna,
/// tombol notifikasi bertitik merah, dan avatar. Pola sama dengan
/// CultaskSliverAppBar.
class KbSliverHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String userName;
  final int notifCount;
  final VoidCallback? onNotifTap;
  final VoidCallback? onAvatarTap;
  final Widget? trailing;

  const KbSliverHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.userName,
    this.notifCount = 0,
    this.onNotifTap,
    this.onAvatarTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    // Tinggi header menyesuaikan ukuran huruf agar tidak terpotong.
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 60 + 36 * scale,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.displaySmall.copyWith(letterSpacing: -0.5, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[trailing!, const SizedBox(width: 10)],
                if (onNotifTap != null) ...[
                  KbIconButton(
                    icon: Icons.notifications_none_rounded,
                    tooltip: 'Notifikasi',
                    showDot: notifCount > 0,
                    onTap: onNotifTap,
                  ),
                  const SizedBox(width: 10),
                ],
                GestureDetector(
                  onTap: onAvatarTap,
                  child: KbAvatar(name: userName, size: 48),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
