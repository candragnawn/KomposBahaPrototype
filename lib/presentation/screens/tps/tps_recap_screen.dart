import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/charts.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';
import '../common/notifications_screen.dart';

/// Pemilih bulan sederhana (‹ Oktober 2026 ›).
class MonthSwitcher extends StatelessWidget {
  final DateTime month;
  final ValueChanged<DateTime> onChanged;
  const MonthSwitcher({super.key, required this.month, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrent = month.year == now.year && month.month == now.month;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Bulan sebelumnya',
            iconSize: 30,
            icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
            onPressed: () => onChanged(DateTime(month.year, month.month - 1)),
          ),
          Expanded(child: Text(Fmt.monthYear(month), textAlign: TextAlign.center, style: AppTypography.titleMedium)),
          IconButton(
            tooltip: 'Bulan berikutnya',
            iconSize: 30,
            icon: Icon(Icons.chevron_right_rounded, color: isCurrent ? AppColors.disabled : AppColors.primary),
            onPressed: isCurrent ? null : () => onChanged(DateTime(month.year, month.month + 1)),
          ),
        ],
      ),
    );
  }
}

class TpsRecapScreen extends StatefulWidget {
  const TpsRecapScreen({super.key});

  @override
  State<TpsRecapScreen> createState() => _TpsRecapScreenState();
}

class _TpsRecapScreenState extends State<TpsRecapScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final m = app.monthStats(_month);
    final banjar = app.banjarRecap(_month);
    final suppliers = app.supplierRecap(month: _month);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Rekap Pemasok',
          subtitle: 'Kompos yang diterima TPS 3R',
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
                  KbCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Kompos per minggu (kg)', style: AppTypography.titleMedium),
                        const SizedBox(height: 16),
                        SimpleBarChart(data: app.weeklyKg()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MonthSwitcher(month: _month, onChanged: (d) => setState(() => _month = d)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.scale_rounded,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.primarySurface,
                          value: '${Fmt.kg(m.verifiedKg)} kg',
                          label: 'Kompos diterima',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.receipt_long_rounded,
                          iconColor: AppColors.soil,
                          iconBg: AppColors.soilLight,
                          value: '${m.verifiedCount}',
                          label: 'Setoran',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.groups_rounded,
                          iconColor: AppColors.goldDark,
                          iconBg: AppColors.goldLight,
                          value: '${m.activeWarga}',
                          label: 'Warga aktif',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Per banjar'),
                  KbMenuGroup(children: [
                    for (final r in banjar)
                      _RecapTile(
                        title: r.label,
                        subtitle: '${r.count} setoran · ${r.sublabel}',
                        value: '${Fmt.kg(r.kg)} kg',
                        icon: Icons.location_city_rounded,
                      ),
                  ]),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Pemasok teratas'),
                  if (suppliers.isEmpty)
                    const EmptyState(
                      icon: Icons.groups_outlined,
                      title: 'Belum ada data',
                      message: 'Belum ada setoran yang diverifikasi pada bulan ini.',
                    )
                  else
                    KbMenuGroup(children: [
                      for (int i = 0; i < suppliers.length; i++)
                        _RecapTile(
                          title: '${i + 1}. ${suppliers[i].label}',
                          subtitle: '${suppliers[i].sublabel} · ${suppliers[i].count}x · ${Fmt.number(suppliers[i].points)} poin',
                          value: '${Fmt.kg(suppliers[i].kg)} kg',
                          leading: KbAvatar(
                            name: suppliers[i].label,
                            size: 44,
                            color: i == 0 ? AppColors.gold : AppColors.primary,
                          ),
                        ),
                    ]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecapTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData? icon;
  final Widget? leading;

  const _RecapTile({required this.title, required this.subtitle, required this.value, this.icon, this.leading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          leading ??
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(13)),
                child: Icon(icon ?? Icons.circle, color: AppColors.primary),
              ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Text(value, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryDark)),
        ],
      ),
    );
  }
}
