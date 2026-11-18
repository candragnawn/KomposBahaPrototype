import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/reward_model.dart';
import '../../../data/models/user_model.dart';
import '../../providers/app_provider.dart';
import '../common/custom_button.dart';
import '../common/kb_widgets.dart';

/// Tiket kode penukaran — ditunjukkan ke petugas Kantor Desa.
Future<void> showRedemptionTicket(BuildContext context, Redemption r) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final app = ctx.watch<AppProvider>();
      final current = app.redemptions.firstWhere((e) => e.id == r.id, orElse: () => r);
      final me = app.currentUser;
      final canCancel = current.status == RedemptionStatus.menunggu && me?.role == UserRole.warga;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Kode penukaran', style: AppTypography.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: current.status == RedemptionStatus.menunggu ? AppColors.goldGradient : null,
                  color: current.status == RedemptionStatus.menunggu ? null : AppColors.sageLight,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Text(current.rewardName, style: AppTypography.titleMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: SelectableText(
                        current.code,
                        style: AppTypography.displayLarge.copyWith(letterSpacing: 4, color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(height: 12),
                    StatusPill(label: current.status.label, color: current.status.color, background: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InfoRow(label: 'Harga', value: '${Fmt.number(current.price)} poin'),
              InfoRow(label: 'Ditukar', value: Fmt.dateTime(current.createdAt)),
              if (current.status == RedemptionStatus.menunggu)
                InfoRow(label: 'Berlaku sampai', value: Fmt.date(current.expiresAt), valueColor: AppColors.error),
              if (current.completedAt != null && current.status == RedemptionStatus.diambil)
                InfoRow(label: 'Diambil', value: Fmt.dateTime(current.completedAt!)),
              const SizedBox(height: 12),
              if (current.status == RedemptionStatus.menunggu)
                InfoBanner(
                  title: 'Cara mengambil hadiah',
                  message: '1. Datang ke ${app.settings.officeAddress.split(',').first}.\n'
                      '2. Tunjukkan kode ini dan KTP kepada petugas.\n'
                      '3. Jam layanan: ${app.settings.officeHours}.',
                ),
              const SizedBox(height: 16),
              KbButton(
                label: 'Salin kode',
                icon: Icons.copy_rounded,
                variant: KbButtonVariant.soft,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: current.code));
                  showKbSnack(ctx, 'Kode disalin');
                },
              ),
              if (canCancel) ...[
                const SizedBox(height: 10),
                KbButton(
                  label: 'Batalkan penukaran',
                  icon: Icons.undo_rounded,
                  variant: KbButtonVariant.ghost,
                  onPressed: () async {
                    final ok = await showConfirmDialog(
                      ctx,
                      title: 'Batalkan penukaran?',
                      message: '${Fmt.number(current.price)} poin akan dikembalikan ke saldo Anda.',
                      confirmLabel: 'Ya, batalkan',
                      danger: true,
                    );
                    if (!ok || !ctx.mounted) return;
                    final err = ctx.read<AppProvider>().cancelRedemption(current.id);
                    if (err != null) {
                      showKbSnack(ctx, err, error: true);
                    } else {
                      Navigator.of(ctx).pop();
                      showKbSnack(context, 'Penukaran dibatalkan, poin dikembalikan');
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

/// Kartu tiket kecil (kode aktif).
class RedemptionTicketCard extends StatelessWidget {
  final Redemption redemption;
  final VoidCallback onTap;
  const RedemptionTicketCard({super.key, required this.redemption, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = redemption;
    final daysLeft = r.expiresAt.difference(DateTime.now()).inDays;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.confirmation_number_rounded, color: AppColors.goldDark, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.rewardName, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(r.code, style: AppTypography.titleLarge.copyWith(letterSpacing: 2, color: AppColors.primaryDeep)),
                  Text(
                    daysLeft <= 0 ? 'Berakhir hari ini' : 'Berlaku $daysLeft hari lagi',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.goldText),
                  ),
                ],
              ),
            ),
            const Icon(Icons.qr_code_2_rounded, color: AppColors.dark, size: 34),
          ],
        ),
      ),
    );
  }
}
