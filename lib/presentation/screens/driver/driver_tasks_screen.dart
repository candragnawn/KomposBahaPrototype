import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/theme/card_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/contact_service.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';

class DriverTasksScreen extends StatefulWidget {
  const DriverTasksScreen({super.key});

  @override
  State<DriverTasksScreen> createState() => _DriverTasksScreenState();
}

class _DriverTasksScreenState extends State<DriverTasksScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    final today = Fmt.dateOnly(DateTime.now());
    final active = app
        .ordersOfDriver(u.id)
        .where((o) => o.status == OrderStatus.ditugaskan || o.status == OrderStatus.dijemput)
        .toList();
    final ongoing = active.where((o) => o.status == OrderStatus.dijemput).toList();
    final todayList = active
        .where((o) => o.status == OrderStatus.ditugaskan && !o.pickupDate.isAfter(today))
        .toList();
    final upcoming = active.where((o) => o.status == OrderStatus.ditugaskan && o.pickupDate.isAfter(today)).toList();
    double todayKg = 0;
    for (final o in [...ongoing, ...todayList]) {
      todayKg += o.estimatedKg;
    }

    final list = _tab == 0 ? todayList : upcoming;
    final slots = <String, List<PickupOrder>>{};
    for (final o in list) {
      final key = _tab == 0 ? o.timeSlot : '${Fmt.relativeDay(o.pickupDate)} · ${o.timeSlot}';
      (slots[key] ??= []).add(o);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Tugas Jemput',
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
                  // ── Ringkasan hari ini ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppCardTheme.heroCard(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Fmt.dateLong(today), style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text(
                                '${ongoing.length + todayList.length} tugas',
                                style: AppTypography.displayMedium.copyWith(color: Colors.white),
                              ),
                              Text(
                                '±${Fmt.kg(todayKg)} kg kompos hari ini',
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.goldLight),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 110,
                          height: 80,
                          child: KbImage(
                            AppAssets.task,
                            fit: BoxFit.contain,
                            fallback: KbSvg(AppAssets.pickupTruck),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Status siap ──
                  KbCard(
                    color: u.isAvailable ? AppColors.successLight : AppColors.warningLight,
                    borderColor: (u.isAvailable ? AppColors.success : AppColors.warning).withValues(alpha: 0.3),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          u.isAvailable ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
                          color: u.isAvailable ? AppColors.success : AppColors.warning,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.isAvailable ? 'Siap bertugas' : 'Sedang libur', style: AppTypography.titleMedium),
                              Text(
                                u.isAvailable ? 'Petugas bisa memberi tugas baru' : 'Petugas akan melihat Anda sedang libur',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            value: u.isAvailable,
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppColors.success,
                            onChanged: (v) => app.setDriverAvailability(v),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Sedang berjalan ──
                  if (ongoing.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Sedang dijemput', subtitle: 'Selesaikan tugas ini terlebih dahulu'),
                    for (final o in ongoing) ...[
                      _TaskCard(order: o, highlight: true),
                      const SizedBox(height: 12),
                    ],
                  ],

                  const SizedBox(height: 24),
                  KbSegmented(
                    labels: ['Hari ini (${todayList.length})', 'Akan datang (${upcoming.length})'],
                    index: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                  const SizedBox(height: 16),
                  if (list.isEmpty)
                    EmptyState(
                      icon: Icons.task_alt_rounded,
                      title: _tab == 0 ? 'Tidak ada tugas hari ini' : 'Belum ada tugas mendatang',
                      message: 'Tugas baru dari petugas TPS 3R akan muncul di sini beserta notifikasinya.',
                    )
                  else
                    for (final entry in slots.entries) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 22),
                            const SizedBox(width: 8),
                            Expanded(child: Text(entry.key, style: AppTypography.titleSmall)),
                            Text('${entry.value.length} rumah', style: AppTypography.labelMedium),
                          ],
                        ),
                      ),
                      for (final o in entry.value) ...[
                        _TaskCard(order: o),
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

class _TaskCard extends StatelessWidget {
  final PickupOrder order;
  final bool highlight;
  const _TaskCard({required this.order, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final o = order;
    return Container(
      decoration: highlight
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(AppCardTheme.radiusMedium + 3),
              border: Border.all(color: AppColors.gold, width: 3),
            )
          : null,
      child: OrderCard(
        order: o,
        showWarga: true,
        onTap: () => OrderDetailScreen.open(context, o.id),
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.home_rounded, size: 20, color: AppColors.muted),
                const SizedBox(width: 6),
                Expanded(child: Text(o.address, style: AppTypography.bodyMedium)),
              ],
            ),
            if (o.notes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sticky_note_2_rounded, size: 20, color: AppColors.muted),
                  const SizedBox(width: 6),
                  Expanded(child: Text(o.notes, style: AppTypography.bodySmall)),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: KbButton(
                    label: 'Telepon',
                    icon: Icons.call_rounded,
                    compact: true,
                    variant: KbButtonVariant.soft,
                    onPressed: () => ContactService.call(o.wargaPhone),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: KbButton(
                    label: 'Peta',
                    icon: Icons.map_rounded,
                    compact: true,
                    variant: KbButtonVariant.soft,
                    onPressed: () => ContactService.openMap('${o.address}, Desa Baha, Mengwi, Badung, Bali'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
