import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/reward_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../../widgets/order/reward_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';
import '../shell/role_shell.dart';

class WargaHistoryScreen extends StatefulWidget {
  const WargaHistoryScreen({super.key});

  @override
  State<WargaHistoryScreen> createState() => _WargaHistoryScreenState();
}

class _WargaHistoryScreenState extends State<WargaHistoryScreen> {
  int _tab = 0;
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Riwayat',
          subtitle: 'Setoran, poin, dan penukaran',
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
                  KbSegmented(
                    labels: const ['Setoran', 'Poin', 'Hadiah'],
                    index: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                  const SizedBox(height: 16),
                  if (_tab == 0) ..._orders(app, u.id),
                  if (_tab == 1) ..._ledger(app, u.id),
                  if (_tab == 2) ..._redemptions(app, u.id),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _orders(AppProvider app, String uid) {
    final all = app.ordersOfWarga(uid);
    final filtered = switch (_filter) {
      1 => all.where((o) => o.status.isActive).toList(),
      2 => all.where((o) => o.status == OrderStatus.selesai).toList(),
      3 => all.where((o) => !o.status.isActive && o.status != OrderStatus.selesai).toList(),
      _ => all,
    };
    final shell = ShellScope.maybeOf(context);
    return [
      KbFilterChips(
        labels: const ['Semua', 'Berjalan', 'Selesai', 'Batal/Ditolak'],
        index: _filter,
        onChanged: (i) => setState(() => _filter = i),
      ),
      const SizedBox(height: 16),
      if (filtered.isEmpty)
        EmptyState(
          icon: Icons.inventory_2_outlined,
          title: 'Belum ada setoran',
          message: all.isEmpty ? 'Ayo setor kompos pertama Anda!' : 'Tidak ada setoran pada kategori ini.',
          actionLabel: all.isEmpty ? 'Setor kompos' : null,
          onAction: () => shell?.goTo(1),
        )
      else
        for (final o in filtered) ...[
          OrderCard(order: o, onTap: () => OrderDetailScreen.open(context, o.id)),
          const SizedBox(height: 12),
        ],
    ];
  }

  List<Widget> _ledger(AppProvider app, String uid) {
    final list = app.ledgerOf(uid);
    final u = app.currentUser!;
    int inSum = 0, outSum = 0;
    for (final e in list) {
      if (e.delta >= 0) {
        inSum += e.delta;
      } else {
        outSum += -e.delta;
      }
    }
    return [
      Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.south_west_rounded,
              iconColor: AppColors.success,
              iconBg: AppColors.successLight,
              value: '+${Fmt.number(inSum)}',
              label: 'Poin masuk',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.north_east_rounded,
              iconColor: AppColors.error,
              iconBg: AppColors.errorLight,
              value: '−${Fmt.number(outSum)}',
              label: 'Poin keluar',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: AppColors.goldDark,
              iconBg: AppColors.goldLight,
              value: Fmt.number(u.points),
              label: 'Saldo',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      if (list.isEmpty)
        const EmptyState(
          icon: Icons.stars_outlined,
          title: 'Belum ada mutasi poin',
          message: 'Poin akan masuk setelah kompos Anda ditimbang TPS 3R.',
        )
      else
        KbMenuGroup(children: [
          for (final e in list)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: e.delta >= 0 ? AppColors.successLight : AppColors.errorLight,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      switch (e.type) {
                        'setor' => Icons.eco_rounded,
                        'tukar' => Icons.card_giftcard_rounded,
                        'refund' => Icons.undo_rounded,
                        _ => Icons.edit_note_rounded,
                      },
                      color: e.delta >= 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.description, style: AppTypography.titleSmall),
                        Text('${Fmt.date(e.createdAt)} · Saldo ${Fmt.number(e.balanceAfter)}', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  Text(
                    Fmt.signedPoints(e.delta),
                    style: AppTypography.titleMedium.copyWith(color: e.delta >= 0 ? AppColors.success : AppColors.error),
                  ),
                ],
              ),
            ),
        ]),
    ];
  }

  List<Widget> _redemptions(AppProvider app, String uid) {
    final list = app.redemptionsOf(uid);
    if (list.isEmpty) {
      return [
        EmptyState(
          icon: Icons.card_giftcard_outlined,
          title: 'Belum pernah menukar hadiah',
          message: 'Kumpulkan poin dan tukar dengan hadiah menarik.',
          actionLabel: 'Lihat hadiah',
          onAction: () => ShellScope.maybeOf(context)?.goTo(2),
        ),
      ];
    }
    return [
      for (final r in list) ...[
        KbCard(
          onTap: () => showRedemptionTicket(context, r),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: r.status.background, borderRadius: BorderRadius.circular(14)),
                child: Icon(Icons.confirmation_number_rounded, color: r.status.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.rewardName, style: AppTypography.titleSmall),
                    Text('${r.code} · ${Fmt.date(r.createdAt)}', style: AppTypography.bodySmall),
                    const SizedBox(height: 6),
                    StatusPill(label: r.status.label, color: r.status.color, background: r.status.background),
                  ],
                ),
              ),
              Text('−${Fmt.number(r.price)}', style: AppTypography.titleSmall.copyWith(color: AppColors.goldText)),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    ];
  }
}
