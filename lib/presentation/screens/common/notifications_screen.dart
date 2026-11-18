import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.currentUser;
    if (user == null) return const SizedBox.shrink();
    final list = app.notificationsFor(user.id);
    final unread = app.unreadCount(user.id);

    return Scaffold(
      appBar: KbAppBar(
        title: 'Notifikasi',
        subtitle: unread > 0 ? '$unread belum dibaca' : 'Semua sudah dibaca',
        trailing: unread > 0
            ? IconButton(
                tooltip: 'Tandai semua dibaca',
                icon: const Icon(Icons.done_all_rounded, color: AppColors.primary, size: 28),
                onPressed: () => app.markAllNotificationsRead(user.id),
              )
            : null,
      ),
      body: list.isEmpty
          ? const KbScrollPage(children: [
              EmptyState(
                icon: Icons.notifications_off_rounded,
                title: 'Belum ada notifikasi',
                message: 'Kabar terbaru tentang setoran, poin, dan hadiah akan muncul di sini.',
              ),
            ])
          : KbScrollPage(
              children: [
                for (final n in list) ...[
                  KbCard(
                    color: n.isRead ? AppColors.white : AppColors.primarySurface,
                    borderColor: n.isRead ? AppColors.border : AppColors.primaryBorder,
                    onTap: () => app.markNotificationRead(n.id),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: n.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(n.icon, color: n.color, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(n.title, style: AppTypography.titleSmall)),
                                  if (!n.isRead)
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(n.body, style: AppTypography.bodyMedium),
                              const SizedBox(height: 6),
                              Text(Fmt.ago(n.createdAt), style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}
