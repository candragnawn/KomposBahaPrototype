import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/charts.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';
import '../shell/role_shell.dart';
import 'verify_screen.dart';

class TpsHomeScreen extends StatelessWidget {
  const TpsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final today = Fmt.dateOnly(now);
    final tomorrow = today.add(const Duration(days: 1));

    final toVerify = app.orders.where((o) => o.status == OrderStatus.diantar).toList()
      ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    final onTheWay = app.orders.where((o) => o.status == OrderStatus.dijemput).toList();
    final waiting = app.orders.where((o) => o.status == OrderStatus.menunggu).length;
    final verifiedToday = app.orders.where((o) {
      final t = o.timeOf(OrderStatus.selesai);
      return o.status == OrderStatus.selesai && t != null && Fmt.sameDay(t, now);
    }).toList();
    double kgToday = 0;
    for (final o in verifiedToday) {
      kgToday += o.officialKg ?? 0;
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'TPS 3R Desa Baha',
          subtitle: 'Halo, ${u.name}',
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
                          icon: Icons.scale_rounded,
                          iconColor: AppColors.soil,
                          iconBg: AppColors.soilLight,
                          value: '${toVerify.length}',
                          label: 'Perlu ditimbang',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.eco_rounded,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.primarySurface,
                          value: '${Fmt.kg(kgToday)} kg',
                          label: 'Diterima hari ini',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.hourglass_top_rounded,
                          iconColor: AppColors.warning,
                          iconBg: AppColors.warningLight,
                          value: '$waiting',
                          label: 'Belum ada driver',
                          onTap: () => ShellScope.maybeOf(context)?.goTo(1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  KbCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Kuota penerimaan', style: AppTypography.titleMedium),
                        const SizedBox(height: 4),
                        ProgressRow(
                          label: 'Hari ini',
                          value: app.bookedKg(today),
                          max: app.settings.dailyQuotaKg,
                          trailing: '${Fmt.kg(app.bookedKg(today))} / ${Fmt.kg(app.settings.dailyQuotaKg)} kg',
                        ),
                        ProgressRow(
                          label: 'Besok',
                          value: app.bookedKg(tomorrow),
                          max: app.settings.dailyQuotaKg,
                          trailing: '${Fmt.kg(app.bookedKg(tomorrow))} / ${Fmt.kg(app.settings.dailyQuotaKg)} kg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Menunggu ditimbang',
                    subtitle: toVerify.isEmpty ? null : 'Kompos yang sudah diantar driver',
                  ),
                  if (toVerify.isEmpty)
                    const EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Tidak ada antrean',
                      message: 'Kompos yang diantar driver akan muncul di sini untuk ditimbang.',
                    )
                  else
                    for (final o in toVerify) ...[
                      OrderCard(
                        order: o,
                        showWarga: true,
                        onTap: () => OrderDetailScreen.open(context, o.id),
                        footer: KbButton(
                          label: 'Timbang & verifikasi',
                          icon: Icons.scale_rounded,
                          compact: true,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => VerifyScreen(orderId: o.id)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  if (onTheWay.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SectionHeader(title: 'Dalam perjalanan', subtitle: '${onTheWay.length} kompos sedang dibawa driver'),
                    for (final o in onTheWay) ...[
                      OrderCard(order: o, showWarga: true, onTap: () => OrderDetailScreen.open(context, o.id)),
                      const SizedBox(height: 12),
                    ],
                  ],
                  if (verifiedToday.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const SectionHeader(title: 'Selesai hari ini'),
                    for (final o in verifiedToday) ...[
                      OrderCard(order: o, showWarga: true, onTap: () => OrderDetailScreen.open(context, o.id)),
                      const SizedBox(height: 12),
                    ],
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
