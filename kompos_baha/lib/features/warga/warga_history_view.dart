import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/constants/app_colors.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_badge.dart';

class WargaHistoryView extends ConsumerStatefulWidget {
  final VoidCallback onSelectOrder;

  const WargaHistoryView({super.key, required this.onSelectOrder});

  @override
  ConsumerState<WargaHistoryView> createState() => _WargaHistoryViewState();
}

class _WargaHistoryViewState extends ConsumerState<WargaHistoryView> {
  int _tabIndex = 0; // 0: Setoran, 1: Mutasi poin

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Aktivitas Anda',
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const SizedBox(height: 2),
          const Text(
            'Riwayat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
          const SizedBox(height: 16),

          // Segmented Tabs
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _tabIndex == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Setoran',
                        style: TextStyle(
                          fontWeight: _tabIndex == 0 ? FontWeight.bold : FontWeight.w500,
                          color: _tabIndex == 0 ? AppColors.primaryGreen : AppColors.muted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _tabIndex == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Mutasi poin',
                        style: TextStyle(
                          fontWeight: _tabIndex == 1 ? FontWeight.bold : FontWeight.w500,
                          color: _tabIndex == 1 ? AppColors.primaryGreen : AppColors.muted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_tabIndex == 0) ...[
            ...state.orders.map((order) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: widget.onSelectOrder,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
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
                            Text(
                              order.code,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${order.date} · ${order.estimatedWeight} kg',
                              style: const TextStyle(fontSize: 12, color: AppColors.muted),
                            ),
                          ],
                        ),
                        AppBadge(label: order.status),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ] else ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.ledger.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
                itemBuilder: (context, index) {
                  final item = state.ledger[index];
                  final isPositive = item.points.startsWith('+');
                  return Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 54,
                          child: Text(
                            item.date,
                            style: const TextStyle(fontSize: 12, color: AppColors.muted),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.description,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.ink),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Saldo setelah ${item.balanceAfter}',
                                style: const TextStyle(fontSize: 11, color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item.points,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isPositive ? AppColors.primaryGreen : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

