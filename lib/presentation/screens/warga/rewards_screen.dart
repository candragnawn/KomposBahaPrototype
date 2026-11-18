import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/reward_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/home_widgets.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/reward_widgets.dart';
import '../common/notifications_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _filter = 0;

  Future<void> _redeem(Reward r) async {
    final app = context.read<AppProvider>();
    final u = app.currentUser;
    if (u == null) return;
    final ok = await showConfirmDialog(
      context,
      title: 'Tukar ${r.name}?',
      message: 'Poin Anda akan berkurang ${Fmt.number(r.price)}.\n'
          'Sisa poin: ${Fmt.number(u.points - r.price)}.\n\n'
          'Ambil hadiah di Kantor Desa dalam ${app.settings.redemptionValidDays} hari.',
      confirmLabel: 'Ya, tukar sekarang',
      icon: Icons.card_giftcard_rounded,
    );
    if (!ok || !mounted) return;
    final res = app.redeem(r.id);
    if (!res.isOk) {
      showKbSnack(context, res.error!, error: true);
      return;
    }
    await showRedemptionTicket(context, res.data!);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    final categories = ['semua', ...Reward.categories.where((c) => app.activeRewards.any((r) => r.category == c))];
    if (_filter >= categories.length) _filter = 0;
    final cat = categories[_filter];
    final rewards = app.activeRewards.where((r) => cat == 'semua' || r.category == cat).toList();
    final pending = app.redemptionsOf(u.id).where((r) => r.status == RedemptionStatus.menunggu).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Tukar Hadiah',
          subtitle: 'Poin Anda: ${Fmt.number(u.points)}',
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
                  PointsBalanceCard(
                    points: u.points,
                    caption: '${app.settings.pointsPerKg} poin untuk setiap 1 kg kompos',
                  ),
                  if (pending.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: 'Hadiah siap diambil',
                      subtitle: 'Tunjukkan kode di Kantor Desa Baha',
                    ),
                    for (final r in pending) ...[
                      RedemptionTicketCard(redemption: r, onTap: () => showRedemptionTicket(context, r)),
                      const SizedBox(height: 12),
                    ],
                  ],
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Katalog hadiah'),
                  KbFilterChips(
                    labels: categories.map((c) => c == 'semua' ? 'Semua' : Reward.categoryLabel(c)).toList(),
                    index: _filter,
                    onChanged: (i) => setState(() => _filter = i),
                  ),
                  const SizedBox(height: 16),
                  if (rewards.isEmpty)
                    const EmptyState(
                      icon: Icons.card_giftcard_rounded,
                      title: 'Belum ada hadiah',
                      message: 'Katalog hadiah akan segera diisi oleh Admin Desa.',
                    )
                  else
                    for (final r in rewards) ...[
                      _RewardCard(reward: r, points: u.points, pointsPerKg: app.settings.pointsPerKg, onRedeem: () => _redeem(r)),
                      const SizedBox(height: 12),
                    ],
                  const SizedBox(height: 12),
                  InfoBanner(
                    title: 'Syarat penukaran',
                    message: '• Hadiah diambil di Kantor Desa Baha.\n'
                        '• Kode berlaku ${app.settings.redemptionValidDays} hari. Lewat dari itu, poin dikembalikan otomatis.\n'
                        '• Tunjukkan kode penukaran dan KTP kepada petugas.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final Reward reward;
  final int points;
  final int pointsPerKg;
  final VoidCallback onRedeem;

  const _RewardCard({required this.reward, required this.points, required this.pointsPerKg, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    final r = reward;
    final enough = points >= r.price;
    final soldOut = r.stock <= 0;
    final progress = (points / r.price).clamp(0.0, 1.0);

    return KbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(color: r.toneLight, borderRadius: BorderRadius.circular(18)),
                child: Icon(r.icon, color: r.tone, size: 36),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: AppTypography.titleMedium),
                    if (r.description.isNotEmpty)
                      Text(r.description, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.goldDark, size: 22),
                        const SizedBox(width: 4),
                        Text('${Fmt.number(r.price)} poin', style: AppTypography.titleMedium.copyWith(color: AppColors.goldText)),
                        const Spacer(),
                        Text(
                          soldOut ? 'Stok habis' : 'Stok ${r.stock}',
                          style: AppTypography.labelMedium.copyWith(color: soldOut ? AppColors.error : AppColors.muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (!enough && !soldOut) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.sageLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Kurang ${Fmt.number(r.price - points)} poin lagi (± ${Fmt.kg((r.price - points) / (pointsPerKg <= 0 ? 10 : pointsPerKg))} kg kompos)',
              style: AppTypography.bodySmall,
            ),
          ] else
            KbButton(
              label: soldOut ? 'Stok habis' : 'Tukar sekarang',
              icon: Icons.redeem_rounded,
              compact: true,
              variant: KbButtonVariant.gold,
              onPressed: soldOut ? null : onRedeem,
            ),
        ],
      ),
    );
  }
}
