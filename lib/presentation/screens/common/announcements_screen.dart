import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/misc_models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context.watch<AppProvider>().activeAnnouncements;
    return Scaffold(
      appBar: const KbAppBar(title: 'Pengumuman Desa'),
      body: KbScrollPage(
        children: [
          if (list.isEmpty)
            const EmptyState(
              icon: Icons.campaign_outlined,
              title: 'Belum ada pengumuman',
              message: 'Informasi terbaru dari Desa Baha akan tampil di sini.',
            )
          else
            for (final a in list) ...[
              AnnouncementCard(announcement: a),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;
  final Widget? trailing;
  const AnnouncementCard({super.key, required this.announcement, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    final a = announcement;
    return KbCard(
      onTap: onTap,
      color: a.isPinned ? AppColors.goldLight : null,
      borderColor: a.isPinned ? AppColors.gold.withValues(alpha: 0.5) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: a.isPinned ? AppColors.gold : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  a.isPinned ? Icons.push_pin_rounded : Icons.campaign_rounded,
                  color: a.isPinned ? AppColors.dark : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.title, style: AppTypography.titleMedium),
                    Text(Fmt.date(a.createdAt), style: AppTypography.bodySmall),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          Text(a.body, style: AppTypography.bodyMedium),
          if (!a.isActive) ...[
            const SizedBox(height: 8),
            const StatusPill(label: 'Disembunyikan', color: AppColors.muted, background: AppColors.sageLight),
          ],
        ],
      ),
    );
  }
}
