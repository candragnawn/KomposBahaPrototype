import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';

class DriverHistoryScreen extends StatefulWidget {
  const DriverHistoryScreen({super.key});

  @override
  State<DriverHistoryScreen> createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final finished = app
        .ordersOfDriver(u.id)
        .where((o) =>
            o.status == OrderStatus.diantar ||
            o.status == OrderStatus.selesai ||
            o.status == OrderStatus.ditolak ||
            o.status == OrderStatus.gagal)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final filtered = switch (_filter) {
      1 => finished.where((o) => o.status != OrderStatus.gagal).toList(),
      2 => finished.where((o) => o.status == OrderStatus.gagal).toList(),
      _ => finished,
    };

    final weekStart = Fmt.dateOnly(now).subtract(Duration(days: now.weekday - 1));
    int weekCount = 0;
    double weekKg = 0;
    int monthCount = 0;
    for (final o in finished) {
      if (o.status == OrderStatus.gagal) continue;
      final t = o.timeOf(OrderStatus.diantar) ?? o.updatedAt;
      if (!t.isBefore(weekStart)) {
        weekCount++;
        weekKg += o.officialKg ?? o.estimatedKg;
      }
      if (t.year == now.year && t.month == now.month) monthCount++;
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Riwayat Tugas',
          subtitle: 'Tugas yang sudah Anda selesaikan',
          userName: u.name,
          notifCount: app.unreadCount(u.id),
          onNotifTap: () => NotificationsScreen.open(context),
        ),
        SliverToBoxAdapter(
          child: KbResponsive(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.date_range_rounded,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.primarySurface,
                          value: '$weekCount',
                          label: 'Tugas minggu ini',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.scale_rounded,
                          iconColor: AppColors.soil,
                          iconBg: AppColors.soilLight,
                          value: '${Fmt.kg(weekKg)} kg',
                          label: 'Kompos minggu ini',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.emoji_events_rounded,
                          iconColor: AppColors.goldDark,
                          iconBg: AppColors.goldLight,
                          value: '$monthCount',
                          label: 'Tugas ${Fmt.monthShort(now.month)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  KbFilterChips(
                    labels: const ['Semua', 'Berhasil', 'Gagal'],
                    index: _filter,
                    onChanged: (i) => setState(() => _filter = i),
                  ),
                  const SizedBox(height: 16),
                  if (filtered.isEmpty)
                    const EmptyState(
                      icon: Icons.history_rounded,
                      title: 'Belum ada riwayat',
                      message: 'Tugas yang sudah selesai akan tercatat di sini.',
                    )
                  else
                    for (final o in filtered) ...[
                      OrderCard(order: o, showWarga: true, onTap: () => OrderDetailScreen.open(context, o.id)),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
