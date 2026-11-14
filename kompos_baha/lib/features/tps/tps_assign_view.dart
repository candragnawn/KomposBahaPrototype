import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/constants/app_colors.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_button.dart';

class TpsAssignView extends ConsumerStatefulWidget {
  const TpsAssignView({super.key});

  @override
  ConsumerState<TpsAssignView> createState() => _TpsAssignViewState();
}

class _TpsAssignViewState extends ConsumerState<TpsAssignView> {
  final Map<String, bool> _assignedMap = {};

  @override
  Widget build(BuildContext context) {
    final unassigned = [
      ('KB-0415', 'Ni Kadek Sari', 'Baha Kaja · 15 kg'),
      ('KB-0414', 'Ni Made Suriati', 'Baha Kelod · 11 kg'),
      ('KB-0413', 'I Ketut Sudarma', 'Baha Kaja · 9 kg'),
    ];

    final drivers = [
      ('Kadek Dwi Arta', '3 tugas hari ini', 'Siap'),
      ('I Ketut Budi', '1 tugas hari ini', 'Siap'),
      ('I Gede Arta', '0 tugas hari ini', 'Siap'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Operasional', style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 2),
        const Text('Penugasan Driver', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Unassigned Orders
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Belum ditugaskan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 14),
                    ...unassigned.map((item) {
                      final isAssigned = _assignedMap[item.$1] ?? false;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${item.$1} · ${item.$2}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(item.$3, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                              ],
                            ),
                            AppButton(
                              label: isAssigned ? 'Ditugaskan' : 'Tugaskan',
                              variant: isAssigned ? ButtonVariant.secondary : ButtonVariant.primary,
                              onPressed: isAssigned
                                  ? null
                                  : () {
                                      setState(() => _assignedMap[item.$1] = true);
                                      ref.read(appStateProvider.notifier).assignDriverToOrder(item.$1, 'Kadek Dwi Arta');
                                    },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Right: Active Drivers
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Driver aktif siaga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 14),
                    ...drivers.map((driver) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.surfaceMint,
                              child: Text(
                                driver.$1.substring(0, 1),
                                style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(driver.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(driver.$2, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.statusPointsBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                driver.$3,
                                style: const TextStyle(color: AppColors.statusPointsText, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

