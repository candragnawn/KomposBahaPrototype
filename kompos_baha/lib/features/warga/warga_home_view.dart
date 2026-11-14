import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_badge.dart';
import '../../shared_widgets/illustrations.dart';

class WargaHomeView extends ConsumerWidget {
  final ValueChanged<int> onNavigateTab;
  final VoidCallback onOpenDetail;

  const WargaHomeView({
    super.key,
    required this.onNavigateTab,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Flex Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE6F6EF), Colors.white],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Row
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryGreen,
                      child: Text(
                        'WS',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selamat pagi', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                          Text(
                            'I Wayan Sudarta',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.mintBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.leaf, size: 14, color: AppColors.primaryGreen),
                          const SizedBox(width: 4),
                          Text(
                            '${state.points} poin',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Monthly Hero Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Setoran bulan ini',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                text: '42,5 ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'kg',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'terkirim ke TPS 3R',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const CompostBinIllustration(width: 80, height: 70),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Services Grid
                const Text(
                  'Layanan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildServiceItem(
                        context,
                        title: 'Setor kompos',
                        illustration: const CompostBinIllustration(width: 48, height: 48),
                        onTap: () => onNavigateTab(2), // Setor tab
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildServiceItem(
                        context,
                        title: 'Tukar hadiah',
                        illustration: const GiftBoxIllustration(width: 48, height: 48),
                        onTap: () => onNavigateTab(1), // Hadiah tab
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildServiceItem(
                        context,
                        title: 'Mutasi poin',
                        illustration: const LedgerCoinIllustration(width: 48, height: 48),
                        onTap: () => onNavigateTab(3), // Riwayat tab
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Active Pickups Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Penjemputan aktif',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
                    ),
                    TextButton(
                      onPressed: () => onNavigateTab(3),
                      child: const Text('Lihat semua', style: TextStyle(color: AppColors.primaryGreen)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Active Order Card
                InkWell(
                  onTap: onOpenDetail,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.mintBorder),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KB-0412 • 12 kg',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(LucideIcons.mapPin, size: 12, color: AppColors.muted),
                                  SizedBox(width: 4),
                                  Text(
                                    'Jl. Baha No. 18, Baha Kelod',
                                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Besok, 08.00-10.00',
                                style: TextStyle(fontSize: 12, color: AppColors.muted),
                              ),
                              SizedBox(height: 8),
                              AppBadge(label: 'Driver ditugaskan'),
                            ],
                          ),
                        ),
                        const PickupTruckIllustration(width: 70, height: 50),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Completed Pickup Card
                InkWell(
                  onTap: onOpenDetail,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KB-0409 • 8 kg',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.ink),
                            ),
                            SizedBox(height: 2),
                            Text('14 Okt 2026', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                        Row(
                          children: [
                            AppBadge(label: 'Poin diberikan'),
                            SizedBox(width: 8),
                            Icon(LucideIcons.check, size: 16, color: AppColors.primaryGreen),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required String title,
    required Widget illustration,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            illustration,
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.ink),
            ),
          ],
        ),
      ),
    );
  }
}

