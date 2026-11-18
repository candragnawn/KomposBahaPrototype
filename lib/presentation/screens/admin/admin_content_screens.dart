import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/id_generator.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/misc_models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../common/announcements_screen.dart';
import '../warga/complaint_screens.dart';

// ─── Pengaduan ──────────────────────────────────────────────────────────────

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  int _filter = 0;

  Future<void> _respond(Complaint c) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ReplySheet(complaint: c),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final all = app.complaintsSorted;
    final list = switch (_filter) {
      1 => all.where((c) => c.status == ComplaintStatus.baru).toList(),
      2 => all.where((c) => c.status == ComplaintStatus.diproses).toList(),
      3 => all.where((c) => c.status == ComplaintStatus.selesai).toList(),
      _ => all,
    };
    final newCount = all.where((c) => c.status == ComplaintStatus.baru).length;

    return Scaffold(
      appBar: KbAppBar(title: 'Pengaduan warga', subtitle: '$newCount pengaduan baru'),
      body: KbScrollPage(
        children: [
          KbFilterChips(
            labels: const ['Semua', 'Baru', 'Diproses', 'Selesai'],
            index: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 16),
          if (list.isEmpty)
            const EmptyState(icon: Icons.forum_outlined, title: 'Tidak ada pengaduan', message: 'Belum ada pengaduan pada kategori ini.')
          else
            for (final c in list) ...[
              ComplaintCard(complaint: c, showName: true, onTap: () => _respond(c)),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _ReplySheet extends StatefulWidget {
  final Complaint complaint;
  const _ReplySheet({required this.complaint});

  @override
  State<_ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends State<_ReplySheet> {
  late final TextEditingController _reply = TextEditingController(text: widget.complaint.reply);
  late ComplaintStatus _status =
      widget.complaint.status == ComplaintStatus.baru ? ComplaintStatus.diproses : widget.complaint.status;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  void _send() {
    final err = context.read<AppProvider>().replyComplaint(widget.complaint.id, _reply.text, _status);
    if (err != null) {
      showKbSnack(context, err, error: true);
      return;
    }
    showKbSnack(context, 'Tanggapan terkirim ke ${widget.complaint.wargaName}');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.complaint;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${c.code} · ${c.topic}', style: AppTypography.titleLarge),
              Text('Dari ${c.wargaName}${c.orderCode.isEmpty ? '' : ' · Setoran ${c.orderCode}'}', style: AppTypography.bodySmall),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.sageLight, borderRadius: BorderRadius.circular(14)),
                child: Text(c.description, style: AppTypography.bodyMedium),
              ),
              const SizedBox(height: 16),
              KbTextField(
                label: 'Balasan resmi Admin Desa',
                hint: 'Tulis tanggapan untuk warga',
                controller: _reply,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
              Text('Status', style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              for (final s in ComplaintStatus.values) ...[
                ChoiceTile(label: s.label, selected: _status == s, onTap: () => setState(() => _status = s)),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              KbButton(label: 'Kirim tanggapan', icon: Icons.send_rounded, onPressed: _send),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pengumuman ─────────────────────────────────────────────────────────────

class AdminAnnouncementsScreen extends StatelessWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final list = [...app.announcements]
      ..sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.createdAt.compareTo(a.createdAt);
      });

    return Scaffold(
      appBar: const KbAppBar(title: 'Pengumuman'),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(
          label: 'Buat pengumuman',
          icon: Icons.add_rounded,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementFormScreen())),
        ),
      ]),
      body: KbScrollPage(
        children: [
          if (list.isEmpty)
            const EmptyState(icon: Icons.campaign_outlined, title: 'Belum ada pengumuman', message: 'Buat pengumuman untuk warga.')
          else
            for (final a in list) ...[
              AnnouncementCard(
                announcement: a,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnnouncementFormScreen(announcement: a))),
                trailing: const Icon(Icons.edit_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class AnnouncementFormScreen extends StatefulWidget {
  final Announcement? announcement;
  const AnnouncementFormScreen({super.key, this.announcement});

  @override
  State<AnnouncementFormScreen> createState() => _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState extends State<AnnouncementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title = TextEditingController(text: widget.announcement?.title ?? '');
  late final TextEditingController _body = TextEditingController(text: widget.announcement?.body ?? '');
  late bool _active = widget.announcement?.isActive ?? true;
  late bool _pinned = widget.announcement?.isPinned ?? false;
  bool _broadcast = true;

  bool get _isEdit => widget.announcement != null;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final base = widget.announcement;
    final a = base == null
        ? Announcement(
            id: IdGen.id(),
            title: _title.text.trim(),
            body: _body.text.trim(),
            isActive: _active,
            isPinned: _pinned,
            createdAt: DateTime.now(),
          )
        : base.copyWith(title: _title.text.trim(), body: _body.text.trim(), isActive: _active, isPinned: _pinned);
    final err = context.read<AppProvider>().upsertAnnouncement(a, broadcast: !_isEdit && _broadcast);
    if (err != null) {
      showKbSnack(context, err, error: true);
      return;
    }
    showKbSnack(context, 'Pengumuman disimpan');
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus pengumuman?',
      message: 'Pengumuman akan hilang dari aplikasi warga.',
      danger: true,
      confirmLabel: 'Ya, hapus',
    );
    if (!ok || !mounted) return;
    context.read<AppProvider>().deleteAnnouncement(widget.announcement!.id);
    showKbSnack(context, 'Pengumuman dihapus');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KbAppBar(
        title: _isEdit ? 'Ubah pengumuman' : 'Pengumuman baru',
        trailing: _isEdit
            ? IconButton(
                tooltip: 'Hapus',
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 28),
                onPressed: _delete,
              )
            : null,
      ),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(label: 'Simpan', icon: Icons.save_rounded, onPressed: _save),
      ]),
      body: Form(
        key: _formKey,
        child: KbScrollPage(
          children: [
            KbTextField(
              label: 'Judul',
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => Validators.required(v, label: 'Judul'),
            ),
            KbTextField(
              label: 'Isi pengumuman',
              controller: _body,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => Validators.required(v, label: 'Isi'),
            ),
            ChoiceTile(
              label: 'Tampilkan ke warga',
              description: _active ? 'Pengumuman terlihat di aplikasi' : 'Disembunyikan',
              icon: Icons.visibility_rounded,
              selected: _active,
              onTap: () => setState(() => _active = !_active),
            ),
            const SizedBox(height: 10),
            ChoiceTile(
              label: 'Sematkan di atas',
              description: 'Tampil paling atas dengan warna emas',
              icon: Icons.push_pin_rounded,
              selected: _pinned,
              onTap: () => setState(() => _pinned = !_pinned),
            ),
            if (!_isEdit) ...[
              const SizedBox(height: 10),
              ChoiceTile(
                label: 'Kirim notifikasi',
                description: 'Beri tahu semua warga & driver',
                icon: Icons.notifications_active_rounded,
                selected: _broadcast,
                onTap: () => setState(() => _broadcast = !_broadcast),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
