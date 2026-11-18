import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/driver_picker.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';

/// Penugasan driver untuk setoran yang masuk (dipakai TPS & Admin).
class TpsAssignScreen extends StatefulWidget {
  /// true jika ditampilkan di dalam halaman lain yang sudah punya AppBar.
  final bool embedded;
  const TpsAssignScreen({super.key, this.embedded = false});

  @override
  State<TpsAssignScreen> createState() => _TpsAssignScreenState();
}

class _TpsAssignScreenState extends State<TpsAssignScreen> {
  int _tab = 0;
  int _dateFilter = 0;

  Future<void> _assign(PickupOrder o) async {
    final id = await pickDriver(context, o);
    if (id == null || !mounted) return;
    final err = context.read<AppProvider>().assignDriver(o.id, id);
    showKbSnack(context, err ?? 'Driver ditugaskan untuk ${o.code}', error: err != null);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    final today = Fmt.dateOnly(DateTime.now());
    bool dateOk(PickupOrder o) => switch (_dateFilter) {
          1 => Fmt.sameDay(o.pickupDate, today),
          2 => Fmt.sameDay(o.pickupDate, today.add(const Duration(days: 1))),
          _ => true,
        };

    final waiting = app.orders.where((o) => o.status == OrderStatus.menunggu && dateOk(o)).toList()
      ..sort((a, b) => a.pickupDate.compareTo(b.pickupDate));
    final assigned = app.orders.where((o) => o.status == OrderStatus.ditugaskan && dateOk(o)).toList()
      ..sort((a, b) => a.pickupDate.compareTo(b.pickupDate));
    final list = _tab == 0 ? waiting : assigned;
    final drivers = app.activeDrivers;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (!widget.embedded)
          KbSliverHeader(
          title: 'Penugasan Driver',
          subtitle: '${waiting.length} setoran belum ada driver',
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
                  Text('Driver hari ini', style: AppTypography.titleMedium),
                  const SizedBox(height: 10),
                  if (drivers.isEmpty)
                    const InfoBanner.warning(message: 'Belum ada driver aktif. Admin Desa dapat menambah driver di menu Pengguna.')
                  else
                    SizedBox(
                      height: 118,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: drivers.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final d = drivers[i];
                          final load = app.driverLoad(d.id, today);
                          return Container(
                            width: 210,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: d.isAvailable ? AppColors.primaryBorder : AppColors.border),
                            ),
                            child: Row(
                              children: [
                                KbAvatar(name: d.name, size: 46, color: d.isAvailable ? AppColors.primary : AppColors.mutedLight),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(d.name, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text('$load tugas', style: AppTypography.bodySmall),
                                      Text(
                                        d.isAvailable ? 'Siap' : 'Libur',
                                        style: AppTypography.labelMedium.copyWith(
                                          color: d.isAvailable ? AppColors.success : AppColors.warning,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  KbSegmented(
                    labels: ['Belum ada driver (${waiting.length})', 'Sudah (${assigned.length})'],
                    index: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                  const SizedBox(height: 12),
                  KbFilterChips(
                    labels: const ['Semua tanggal', 'Hari ini', 'Besok'],
                    index: _dateFilter,
                    onChanged: (i) => setState(() => _dateFilter = i),
                  ),
                  const SizedBox(height: 16),
                  if (list.isEmpty)
                    EmptyState(
                      icon: Icons.assignment_turned_in_rounded,
                      title: _tab == 0 ? 'Semua sudah ditugaskan' : 'Belum ada penugasan',
                      message: _tab == 0 ? 'Tidak ada setoran yang menunggu driver.' : 'Setoran yang sudah ditugaskan akan muncul di sini.',
                    )
                  else
                    for (final o in list) ...[
                      OrderCard(
                        order: o,
                        showWarga: true,
                        onTap: () => OrderDetailScreen.open(context, o.id),
                        footer: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (o.driverName != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_shipping_rounded, size: 20, color: AppColors.info),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text('Driver: ${o.driverName}', style: AppTypography.titleSmall)),
                                  ],
                                ),
                              ),
                            KbButton(
                              label: o.driverId == null ? 'Tugaskan driver' : 'Ganti driver',
                              icon: Icons.assignment_ind_rounded,
                              compact: true,
                              variant: o.driverId == null ? KbButtonVariant.primary : KbButtonVariant.secondary,
                              onPressed: () => _assign(o),
                            ),
                          ],
                        ),
                      ),
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
