import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../common/kb_image.dart';
import '../common/kb_widgets.dart';

/// Pilih driver untuk satu setoran. Mengembalikan ID driver.
Future<String?> pickDriver(BuildContext context, PickupOrder order) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final app = ctx.watch<AppProvider>();
      final drivers = app.activeDrivers
        ..sort((a, b) {
          if (a.isAvailable != b.isAvailable) return a.isAvailable ? -1 : 1;
          return app.driverLoad(a.id, order.pickupDate).compareTo(app.driverLoad(b.id, order.pickupDate));
        });
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.8),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: Text('Pilih driver', style: AppTypography.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  '${order.code} · ${order.wargaName} · ${Fmt.relativeDay(order.pickupDate)}, ${order.timeSlot}',
                  style: AppTypography.bodySmall,
                ),
              ),
              if (drivers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: InfoBanner.warning(message: 'Belum ada driver aktif. Tambahkan driver di menu Pengguna.'),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: drivers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final d = drivers[i];
                      final load = app.driverLoad(d.id, order.pickupDate);
                      final selected = d.id == order.driverId;
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.of(ctx).pop(d.id),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primarySurface : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 2 : 1.5),
                          ),
                          child: Row(
                            children: [
                              KbAvatar(name: d.name, size: 50, color: d.isAvailable ? AppColors.primary : AppColors.mutedLight),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(d.name, style: AppTypography.titleSmall),
                                    Text(
                                      '${d.vehicle.isEmpty ? 'Kendaraan -' : d.vehicle} · $load tugas pada tanggal ini',
                                      style: AppTypography.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    StatusPill(
                                      label: d.isAvailable ? 'Siap bertugas' : 'Sedang libur',
                                      color: d.isAvailable ? AppColors.success : AppColors.warning,
                                      background: d.isAvailable ? AppColors.successLight : AppColors.warningLight,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                selected ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
                                color: selected ? AppColors.primary : AppColors.mutedLight,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
