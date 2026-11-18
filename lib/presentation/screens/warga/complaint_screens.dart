import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/misc_models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';

/// Daftar pengaduan milik warga.
class ComplaintListScreen extends StatelessWidget {
  const ComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final list = app.complaintsOf(u.id);

    return Scaffold(
      appBar: const KbAppBar(title: 'Pengaduan saya'),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(
          label: 'Buat pengaduan baru',
          icon: Icons.add_comment_rounded,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComplaintFormScreen())),
        ),
      ]),
      body: KbScrollPage(
        children: [
          if (list.isEmpty)
            const EmptyState(
              icon: Icons.forum_outlined,
              title: 'Belum ada pengaduan',
              message: 'Ada kendala penjemputan, poin, atau hadiah? Sampaikan kepada Admin Desa di sini.',
            )
          else
            for (final c in list) ...[
              ComplaintCard(complaint: c),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

/// Kartu pengaduan + balasan admin.
class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback? onTap;
  final bool showName;
  const ComplaintCard({super.key, required this.complaint, this.onTap, this.showName = false});

  @override
  Widget build(BuildContext context) {
    final c = complaint;
    return KbCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  showName ? '${c.code} · ${c.wargaName}' : c.code,
                  style: AppTypography.labelLarge.copyWith(color: AppColors.muted),
                ),
              ),
              StatusPill(label: c.status.label, color: c.status.color, background: c.status.background),
            ],
          ),
          const SizedBox(height: 8),
          Text(c.topic, style: AppTypography.titleMedium),
          if (c.orderCode.isNotEmpty) Text('Setoran ${c.orderCode}', style: AppTypography.bodySmall),
          const SizedBox(height: 6),
          Text(c.description, style: AppTypography.bodyMedium),
          const SizedBox(height: 6),
          Text(Fmt.dateTime(c.createdAt), style: AppTypography.bodySmall),
          if (c.reply.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.reply_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 6),
                      Text('Balasan Admin Desa', style: AppTypography.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(c.reply, style: AppTypography.bodyMedium),
                  if (c.repliedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(Fmt.dateTime(c.repliedAt!), style: AppTypography.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Form pengaduan baru.
class ComplaintFormScreen extends StatefulWidget {
  final String orderCode;
  const ComplaintFormScreen({super.key, this.orderCode = ''});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  String? _topic;
  late String _orderCode = widget.orderCode;
  final _desc = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  void _send() {
    setState(() => _submitted = true);
    if (_topic == null) return;
    final err = context.read<AppProvider>().submitComplaint(
          topic: _topic!,
          description: _desc.text,
          orderCode: _orderCode,
        );
    if (err != null) {
      showKbSnack(context, err, error: true);
      return;
    }
    showKbSnack(context, 'Pengaduan terkirim. Admin Desa akan segera menanggapi.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final orderCodes = ['', ...app.ordersOfWarga(u.id).take(10).map((o) => o.code)];

    return Scaffold(
      appBar: const KbAppBar(title: 'Buat pengaduan'),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(label: 'Kirim pengaduan', icon: Icons.send_rounded, onPressed: _send),
      ]),
      body: KbScrollPage(
        children: [
          Text('Apa masalahnya?', style: AppTypography.titleMedium),
          const SizedBox(height: 10),
          for (final t in Complaint.topics) ...[
            ChoiceTile(label: t, selected: _topic == t, onTap: () => setState(() => _topic = t)),
            const SizedBox(height: 8),
          ],
          if (_submitted && _topic == null)
            Text('Pilih salah satu masalah', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
          const SizedBox(height: 16),
          if (orderCodes.length > 1)
            KbSelectField<String>(
              label: 'Terkait setoran (opsional)',
              value: _orderCode,
              options: orderCodes,
              labelOf: (c) => c.isEmpty ? 'Tidak terkait setoran' : c,
              icon: Icons.receipt_long_rounded,
              onChanged: (v) => setState(() => _orderCode = v),
            ),
          KbTextField(
            label: 'Ceritakan masalahnya',
            hint: 'Tulis dengan jelas agar mudah ditindaklanjuti',
            controller: _desc,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
