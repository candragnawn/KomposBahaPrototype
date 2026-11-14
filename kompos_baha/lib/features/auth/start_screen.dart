import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/models/role.dart';
import '../../core/providers/app_state_provider.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = [
      (UserRole.warga, 'Warga', 'Setor kompos dan tukar poin', LucideIcons.home),
      (UserRole.driver, 'Driver', 'Kelola tugas penjemputan', LucideIcons.truck),
      (UserRole.tps, 'TPS 3R', 'Timbang dan verifikasi kompos', LucideIcons.box),
      (UserRole.admin, 'Admin Desa', 'Pantau layanan desa', LucideIcons.users),
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceMint,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.leaf, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Layanan Desa Baha',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kompos Baha',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Platform pengumpulan kompos rumah tangga untuk lingkungan desa yang lebih bersih.',
                  style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 28),
                ...roles.map((r) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        ref.read(appStateProvider.notifier).setRole(r.$1);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMint,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(r.$4, color: AppColors.primaryGreen, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.$2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    r.$3,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.arrowRight, size: 18, color: AppColors.muted),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Pilih peran untuk memulai demonstrasi prototipe.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

