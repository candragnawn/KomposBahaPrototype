import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/models/reward_item.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_button.dart';
import '../../shared_widgets/illustrations.dart';

class WargaRewardsView extends ConsumerStatefulWidget {
  const WargaRewardsView({super.key});

  @override
  ConsumerState<WargaRewardsView> createState() => _WargaRewardsViewState();
}

class _WargaRewardsViewState extends ConsumerState<WargaRewardsView> {
  RewardItem? _selectedReward;
  bool _redeemSuccess = false;
  bool _isLoading = false;

  void _confirmRedeem(RewardItem reward) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi penukaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tukar ${reward.name} seharga ${reward.price} poin?'),
              const SizedBox(height: 8),
              const Text('Hadiah dapat diambil di Kantor Desa Baha.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            AppButton(
              label: 'Konfirmasi',
              variant: ButtonVariant.primary,
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _isLoading = true);
                Future.delayed(const Duration(milliseconds: 600), () {
                  final ok = ref.read(appStateProvider.notifier).redeemReward(reward.name);
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                      if (ok) _redeemSuccess = true;
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);

    if (_redeemSuccess) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.checkCircle2, color: AppColors.primaryGreen, size: 56),
              const SizedBox(height: 16),
              const Text('Penukaran berhasil', style: TextStyle(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Hadiah siap diambil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const SizedBox(height: 8),
              const Text('Tunjukkan kode ini kepada petugas Kantor Desa Baha.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMint,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.mintBorder),
                ),
                child: const Text('TKR-7F3A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppColors.primaryGreen)),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Selesai',
                variant: ButtonVariant.primary,
                wide: true,
                onPressed: () {
                  setState(() {
                    _redeemSuccess = false;
                    _selectedReward = null;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    if (_selectedReward != null) {
      final reward = _selectedReward!;
      final canRedeem = state.points >= reward.price && reward.stock > 0;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.arrowLeft, color: AppColors.ink),
                  onPressed: () => setState(() => _selectedReward = null),
                ),
                const Text('Katalog hadiah', style: TextStyle(fontSize: 14, color: AppColors.muted)),
              ],
            ),
            const SizedBox(height: 12),
            const Center(child: GiftBoxIllustration(width: 120, height: 100)),
            const SizedBox(height: 16),
            Text(reward.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
            const SizedBox(height: 4),
            Text('${reward.price} poin', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Syarat penukaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('â€¢ Hadiah diambil di Kantor Desa Baha.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  SizedBox(height: 4),
                  Text('â€¢ Tunjukkan kode penukaran dan KTP.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  SizedBox(height: 4),
                  Text('â€¢ Kode berlaku selama 7 hari.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: _isLoading ? 'Memproses...' : (canRedeem ? 'Tukar poin' : (reward.stock == 0 ? 'Stok habis' : 'Poin tidak cukup')),
              variant: ButtonVariant.primary,
              wide: true,
              isLoading: _isLoading,
              onPressed: canRedeem && !_isLoading ? () => _confirmRedeem(reward) : null,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Katalog warga', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  Text('Hadiah', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMint,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.mintBorder),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.leaf, size: 14, color: AppColors.primaryGreen),
                    const SizedBox(width: 4),
                    Text('${state.points} poin', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryGreen)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: state.rewards.length,
            itemBuilder: (context, index) {
              final item = state.rewards[index];
              return InkWell(
                onTap: () => setState(() => _selectedReward = item),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: GiftBoxIllustration(width: 60, height: 60)),
                      const Spacer(),
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
                      const SizedBox(height: 2),
                      Text('${item.price} poin', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                      const SizedBox(height: 2),
                      Text(item.stock > 0 ? 'Stok ${item.stock}' : 'Stok habis', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

