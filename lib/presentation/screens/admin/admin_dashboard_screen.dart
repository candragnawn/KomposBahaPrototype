import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/theme/card_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/reward_model.dart';
import '../../../data/models/user_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/charts.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';
import '../shell/role_shell.dart';
import 'admin_content_screens.dart';
import 'admin_reward_screens.dart';
import 'admin_assign_page.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final m = app.monthStats(now);
    final counts = app.statusCounts();
    final active = (counts[OrderStatus.menunggu] ?? 0) +
        (counts[OrderStatus.ditugaskan] ?? 0) +
        (counts[OrderStatus.dijemput] ?? 0) +
        (counts[OrderStatus.diantar] ?? 0);
    final wargaCount = app.users.where((x) => x.role == UserRole.warga).length;
    final newComplaints = app.complaints.where((c) => c.status == ComplaintStatus.baru).length;
    final pendingRedemptions = app.redemptions.where((r) => r.status == RedemptionStatus.menunggu).length;
    final latest = [...app.orders]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final shell = ShellScope.maybeOf(context);

    void push(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Panel Admin Desa',
          subtitle: 'Ringkasan ${Fmt.monthYear(now)}',
          userName: u.name,
          notifCount: app.unreadCount(u.id),
          onNotifTap: () => NotificationsScreen.open(context),
          onAvatarTap: () => shell?.goTo(4),
        ),
        SliverToBoxAdapter(
          child: KbResponsive(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Hero ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppCardTheme.heroCard(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kompos terserap bulan ini', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text(
                                '${Fmt.kg(m.verifiedKg)} kg',
                                style: AppTypography.displayLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${m.verifiedCount} setoran · ${m.activeWarga} warga aktif',
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.goldLight),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 90,
                          height: 90,
                          child: KbImage(AppAssets.report, fit: BoxFit.contain, fallback: KbSvg(AppAssets.compostBin)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Statistik ──
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.local_shipping_rounded,
                            iconColor: AppColors.primary,
                            iconBg: AppColors.primarySurface,
                            value: '$active',
                            label: 'Setoran berjalan',
                            onTap: () => shell?.goTo(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            icon: Icons.groups_rounded,
                            iconColor: AppColors.soil,
                            iconBg: AppColors.soilLight,
                            value: '$wargaCount',
                            label: 'Warga (+${m.newWarga} bulan ini)',
                            onTap: () => shell?.goTo(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.stars_rounded,
                            iconColor: AppColors.goldDark,
                            iconBg: AppColors.goldLight,
                            value: Fmt.number(m.pointsIssued),
                            label: 'Poin terbit bulan ini',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            icon: Icons.redeem_rounded,
                            iconColor: AppColors.info,
                            iconBg: AppColors.infoLight,
                            value: Fmt.number(m.pointsRedeemed),
                            label: 'Poin ditukar bulan ini',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Perlu tindakan ──
                  const SectionHeader(title: 'Perlu tindakan'),
                  KbMenuGroup(children: [
                    KbMenuTile(
                      icon: Icons.assignment_ind_rounded,
                      title: 'Tugaskan driver',
                      subtitle: '${counts[OrderStatus.menunggu] ?? 0} setoran menunggu driver',
                      badge: counts[OrderStatus.menunggu] ?? 0,
                      onTap: () => push(const AdminAssignPage()),
                    ),
                    KbMenuTile(
                      icon: Icons.confirmation_number_rounded,
                      title: 'Serahkan hadiah',
                      subtitle: '$pendingRedemptions kode penukaran aktif',
                      color: AppColors.goldDark,
                      badge: pendingRedemptions,
                      onTap: () => push(const AdminRedemptionsScreen()),
                    ),
                    KbMenuTile(
                      icon: Icons.support_agent_rounded,
                      title: 'Tanggapi pengaduan',
                      subtitle: '$newComplaints pengaduan baru',
                      color: AppColors.info,
                      badge: newComplaints,
                      onTap: () => push(const AdminComplaintsScreen()),
                    ),
                    KbMenuTile(
                      icon: Icons.scale_rounded,
                      title: 'Menunggu ditimbang TPS',
                      subtitle: '${counts[OrderStatus.diantar] ?? 0} kompos di TPS 3R',
                      color: AppColors.soil,
                      badge: counts[OrderStatus.diantar] ?? 0,
                      onTap: () => shell?.goTo(1),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // ── Grafik ──
                  KbCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Kompos terverifikasi per minggu', style: AppTypography.titleMedium),
                        Text('6 minggu terakhir (kg)', style: AppTypography.bodySmall),
                        const SizedBox(height: 16),
                        SimpleBarChart(data: app.weeklyKg()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  KbCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Status semua setoran', style: AppTypography.titleMedium),
                        const SizedBox(height: 8),
                        for (final s in OrderStatus.values)
                          if ((counts[s] ?? 0) > 0)
                            ProgressRow(
                              label: s.label,
                              value: (counts[s] ?? 0).toDouble(),
                              max: app.orders.isEmpty ? 1 : app.orders.length.toDouble(),
                              trailing: '${counts[s]}',
                              color: s.color,
                            ),
                        if (app.orders.isEmpty) Text('Belum ada setoran.', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Aktivitas terbaru ──
                  SectionHeader(title: 'Aktivitas terbaru', actionLabel: 'Semua', onAction: () => shell?.goTo(1)),
                  if (latest.isEmpty)
                    const EmptyState(
                      icon: Icons.inbox_rounded,
                      title: 'Belum ada setoran',
                      message: 'Setoran warga akan tampil di sini. Coba isi data contoh dari menu Kelola → Data aplikasi.',
                    )
                  else
                    for (final o in latest.take(5)) ...[
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
