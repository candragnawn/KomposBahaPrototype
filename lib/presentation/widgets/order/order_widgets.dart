import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/theme/card_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../common/kb_widgets.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return StatusPill(label: status.label, color: status.color, background: status.background, icon: status.icon);
  }
}

/// Kartu ringkas satu setoran.
class OrderCard extends StatelessWidget {
  final PickupOrder order;
  final VoidCallback? onTap;

  /// Tampilkan nama warga (untuk driver/TPS/admin).
  final bool showWarga;
  final Widget? footer;

  const OrderCard({super.key, required this.order, this.onTap, this.showWarga = false, this.footer});

  @override
  Widget build(BuildContext context) {
    final o = order;
    final kgText = o.officialKg != null ? '${Fmt.kg(o.officialKg!)} kg (resmi)' : '±${Fmt.kg(o.estimatedKg)} kg';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppCardTheme.radiusMedium),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: o.status.color.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppCardTheme.radiusMedium),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: o.status.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(o.status.icon, color: o.status.color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showWarga ? o.wargaName : 'Setoran ${o.code}',
                            style: AppTypography.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            showWarga ? '${o.code} · Banjar ${o.banjar}' : kgText,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (onTap != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 14),
                        child: Icon(Icons.chevron_right_rounded, color: AppColors.mutedLight, size: 28),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    _Meta(icon: Icons.event_rounded, text: Fmt.relativeDay(o.pickupDate)),
                    _Meta(icon: Icons.schedule_rounded, text: o.timeSlot),
                    if (showWarga) _Meta(icon: Icons.scale_rounded, text: kgText),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(child: OrderStatusBadge(status: o.status)),
                    const Spacer(),
                    if (o.status == OrderStatus.selesai)
                      Text(
                        '+${Fmt.number(o.totalPoints)} poin',
                        style: AppTypography.titleSmall.copyWith(color: AppColors.success),
                      ),
                  ],
                ),
                if (footer != null) ...[const SizedBox(height: 12), footer!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.dark)),
      ],
    );
  }
}

/// Timeline 5 langkah setoran — jelas dengan tanggal & jam.
class StatusTimeline extends StatelessWidget {
  final PickupOrder order;
  const StatusTimeline({super.key, required this.order});

  static const _steps = [
    (OrderStatus.menunggu, 'Setoran diajukan'),
    (OrderStatus.ditugaskan, 'Driver ditugaskan'),
    (OrderStatus.dijemput, 'Dijemput driver'),
    (OrderStatus.diantar, 'Tiba di TPS 3R'),
    (OrderStatus.selesai, 'Ditimbang & poin masuk'),
  ];

  @override
  Widget build(BuildContext context) {
    final s = order.status;
    final terminalBad = s == OrderStatus.ditolak || s == OrderStatus.gagal || s == OrderStatus.dibatalkan;

    // Langkah terakhir yang tercapai
    int reached = s.stepIndex;
    if (terminalBad) {
      reached = -1;
      for (int i = 0; i < _steps.length; i++) {
        if (order.timeOf(_steps[i].$1) != null) reached = i;
      }
    }

    final rows = <Widget>[];
    for (int i = 0; i < _steps.length; i++) {
      final (st, label) = _steps[i];
      final done = i <= reached;
      final isCurrent = i == reached && !terminalBad && s != OrderStatus.selesai;
      final time = order.timeOf(st);
      rows.add(_TimelineRow(
        label: label,
        time: time,
        done: done,
        current: isCurrent,
        isLast: i == _steps.length - 1 && !terminalBad,
        color: done ? AppColors.primary : AppColors.disabled,
      ));
      if (terminalBad && i == reached) break;
    }
    if (terminalBad) {
      rows.add(_TimelineRow(
        label: s.label,
        time: order.timeOf(s),
        done: true,
        current: true,
        isLast: true,
        color: s.color,
        icon: s.icon,
      ));
    }
    return Column(children: rows);
  }
}

class _TimelineRow extends StatelessWidget {
  final String label;
  final DateTime? time;
  final bool done;
  final bool current;
  final bool isLast;
  final Color color;
  final IconData? icon;

  const _TimelineRow({
    required this.label,
    required this.time,
    required this.done,
    required this.current,
    required this.isLast,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: done ? color : AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: done ? color : AppColors.disabled, width: 2.5),
                    boxShadow: current
                        ? [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, spreadRadius: 2)]
                        : null,
                  ),
                  child: Icon(
                    icon ?? (done ? Icons.check_rounded : Icons.circle),
                    size: done ? 20 : 8,
                    color: done ? Colors.white : AppColors.disabled,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: done ? color.withValues(alpha: 0.5) : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.titleSmall.copyWith(
                      color: done ? (icon != null ? color : AppColors.dark) : AppColors.mutedLight,
                    ),
                  ),
                  if (time != null)
                    Text(Fmt.dateTime(time!), style: AppTypography.bodySmall)
                  else if (!done)
                    Text('Belum', style: AppTypography.bodySmall.copyWith(color: AppColors.mutedLight)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
