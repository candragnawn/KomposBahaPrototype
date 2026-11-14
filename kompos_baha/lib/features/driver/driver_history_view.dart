import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_badge.dart';

class DriverHistoryView extends StatelessWidget {
  const DriverHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [
      ('Ni Made Suriati', '18 Okt 2026', '12 kg'),
      ('I Ketut Merta', '17 Okt 2026', '16 kg'),
      ('Putu Eka Pramana', '15 Okt 2026', '11 kg'),
      ('Ni Nyoman Rai', '12 Okt 2026', '14 kg'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Riwayat tugas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.mintBorder),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total minggu ini', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
                Text('74 kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...list.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
                      const SizedBox(height: 2),
                      Text('${item.$2} · ${item.$3}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                  const AppBadge(label: 'Poin diberikan'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

