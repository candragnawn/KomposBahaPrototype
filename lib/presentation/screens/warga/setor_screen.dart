import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/common/photo_picker.dart';
import '../../widgets/order/weight_stepper.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';
import 'guide_screen.dart';

/// Form setor kompos. Bisa sebagai tab (standalone=false) atau halaman sendiri.
class SetorScreen extends StatefulWidget {
  final bool standalone;
  const SetorScreen({super.key, this.standalone = false});

  @override
  State<SetorScreen> createState() => _SetorScreenState();
}

class _SetorScreenState extends State<SetorScreen> {
  double _kg = 10;
  DateTime? _date;
  String? _slot;
  String? _photo;
  final _address = TextEditingController();
  final _notes = TextEditingController();
  bool _submitted = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _address.text = context.read<AppProvider>().currentUser?.address ?? '';
  }

  @override
  void dispose() {
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _kg = 10;
      _date = null;
      _slot = null;
      _photo = null;
      _notes.clear();
      _submitted = false;
    });
    _address.text = context.read<AppProvider>().currentUser?.address ?? '';
  }

  String? get _addressError => _submitted && _address.text.trim().isEmpty ? 'Alamat wajib diisi' : null;

  Future<void> _submit() async {
    setState(() => _submitted = true);
    final app = context.read<AppProvider>();
    if (_date == null || _slot == null || _photo == null || _address.text.trim().isEmpty) {
      showKbSnack(context, 'Mohon lengkapi bagian yang bertanda merah.', error: true);
      return;
    }
    final ok = await showConfirmDialog(
      context,
      title: 'Kirim setoran?',
      message: '±${Fmt.kg(_kg)} kg kompos akan dijemput ${Fmt.relativeDay(_date!).toLowerCase()}, '
          'pukul $_slot WITA.\n\nAlamat: ${_address.text.trim()}',
      confirmLabel: 'Ya, kirim setoran',
      icon: Icons.send_rounded,
    );
    if (!ok || !mounted) return;
    setState(() => _loading = true);
    final res = app.createOrder(
      estimatedKg: _kg,
      pickupDate: _date!,
      timeSlot: _slot!,
      address: _address.text,
      notes: _notes.text,
      photoPath: _photo,
    );
    setState(() => _loading = false);
    if (!res.isOk) {
      showKbSnack(context, res.error!, error: true);
      return;
    }
    final order = res.data!;
    _reset();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: Container(
          width: 84,
          height: 84,
          decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: AppColors.success, size: 52),
        ),
        title: const Text('Setoran terkirim!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Kode setoran Anda:', textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(14)),
              child: Text(order.code, style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark, letterSpacing: 2)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kami akan memberi tahu Anda saat driver sudah ditugaskan.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              KbButton(
                label: 'Lihat status setoran',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (widget.standalone) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: order.id)),
                    );
                  } else {
                    OrderDetailScreen.open(context, order.id);
                  }
                },
              ),
              const SizedBox(height: 8),
              KbButton(
                label: 'Selesai',
                variant: KbButtonVariant.ghost,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (widget.standalone) Navigator.of(context).maybePop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepTitle(int n, String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Text('$n', style: AppTypography.titleMedium.copyWith(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                if (subtitle != null) Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _form(AppProvider app) {
    final u = app.currentUser!;
    final s = app.settings;
    final active = app.activeOrdersOfWarga(u.id);
    final blocked = active.length >= s.maxActiveOrders;
    final dates = app.availablePickupDates();
    final (base, bonus) = app.calculatePoints(_kg, CompostQuality.baik);

    return [
      if (blocked) ...[
        InfoBanner.warning(
          title: 'Setoran sedang berjalan',
          message: 'Anda masih punya ${active.length} setoran yang belum selesai. '
              'Setoran baru bisa dibuat setelah salah satunya selesai.',
        ),
        const SizedBox(height: 12),
        for (final o in active) ...[
          KbButton(
            label: 'Lihat ${o.code} (${o.status.label})',
            variant: KbButtonVariant.soft,
            icon: Icons.visibility_rounded,
            onPressed: () => OrderDetailScreen.open(context, o.id),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
      ],
      KbCard(
        color: AppColors.goldLight,
        borderColor: AppColors.gold.withValues(alpha: 0.5),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideScreen())),
        child: Row(
          children: [
            const Icon(Icons.tips_and_updates_rounded, color: AppColors.goldDark, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Kompos diterima jika: sudah matang, tidak becek, dan tidak bercampur plastik. Ketuk untuk panduan.',
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),

      _stepTitle(1, 'Perkiraan berat kompos', subtitle: 'Tidak perlu tepat, nanti ditimbang di TPS 3R'),
      WeightStepper(value: _kg, onChanged: (v) => setState(() => _kg = v)),
      const SizedBox(height: 8),
      Text(
        'Perkiraan poin: ±${Fmt.number(base + bonus)} poin (jika kualitas Baik)',
        textAlign: TextAlign.center,
        style: AppTypography.labelLarge,
      ),
      const SizedBox(height: 20),

      _stepTitle(2, 'Tanggal penjemputan', subtitle: 'Pilih hari. Angka hijau = sisa kuota TPS 3R'),
      SizedBox(
        height: 128,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) {
            final d = dates[i];
            final remaining = app.quotaRemaining(d);
            final enough = remaining >= _kg;
            final sel = _date != null && Fmt.sameDay(_date!, d);
            return GestureDetector(
              onTap: enough ? () => setState(() => _date = d) : () => showKbSnack(
                    context,
                    remaining <= 0 ? 'Kuota tanggal ini sudah penuh.' : 'Kuota tanggal ini tinggal ${Fmt.kg(remaining)} kg.',
                    error: true,
                  ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 96,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                  color: !enough ? AppColors.sageLight : (sel ? AppColors.primary : AppColors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: sel ? AppColors.primary : (_submitted && _date == null ? AppColors.error : AppColors.border),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      i == 0 && Fmt.sameDay(d, DateTime.now()) ? 'Hari ini' : Fmt.dayName(d),
                      style: AppTypography.labelMedium.copyWith(color: sel ? Colors.white : AppColors.muted),
                    ),
                    Text(
                      '${d.day}',
                      style: AppTypography.displaySmall.copyWith(color: sel ? Colors.white : (enough ? AppColors.dark : AppColors.mutedLight)),
                    ),
                    Text(
                      enough ? 'sisa ${Fmt.kg(remaining)}kg' : 'Penuh',
                      style: AppTypography.labelSmall.copyWith(
                        color: sel ? AppColors.goldLight : (enough ? AppColors.success : AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      if (_submitted && _date == null)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('Pilih tanggal penjemputan', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
        ),
      const SizedBox(height: 16),
      Text('Jam penjemputan', style: AppTypography.titleSmall),
      const SizedBox(height: 8),
      for (final slot in s.timeSlots) ...[
        ChoiceTile(
          label: '$slot WITA',
          icon: Icons.schedule_rounded,
          selected: _slot == slot,
          onTap: () => setState(() => _slot = slot),
        ),
        const SizedBox(height: 8),
      ],
      if (_submitted && _slot == null)
        Text('Pilih jam penjemputan', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
      const SizedBox(height: 20),

      _stepTitle(3, 'Alamat penjemputan'),
      TextField(
        controller: _address,
        maxLines: 2,
        style: AppTypography.bodyLarge,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (_) {
          if (_submitted) setState(() {});
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.home_rounded),
          hintText: 'Nama jalan, nomor rumah, patokan',
          errorText: _addressError,
        ),
      ),
      const SizedBox(height: 6),
      Text('Banjar ${u.banjar}', style: AppTypography.bodySmall),
      const SizedBox(height: 20),

      _stepTitle(4, 'Foto kompos', subtitle: 'Agar driver & petugas tahu kondisi kompos'),
      PhotoPickerTile(
        label: 'Foto kompos Anda',
        path: _photo,
        onPicked: (p) => setState(() => _photo = p),
        onRemove: () => setState(() => _photo = null),
        errorText: _submitted && _photo == null ? 'Foto kompos wajib ditambahkan' : null,
      ),

      _stepTitle(5, 'Catatan untuk driver', subtitle: 'Boleh dikosongkan'),
      TextField(
        controller: _notes,
        maxLines: 3,
        style: AppTypography.bodyLarge,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Contoh: kompos di karung putih dekat pintu samping',
          prefixIcon: Icon(Icons.sticky_note_2_rounded),
        ),
      ),
      const SizedBox(height: 28),
      KbButton(
        label: 'Kirim setoran',
        icon: Icons.send_rounded,
        loading: _loading,
        onPressed: blocked ? null : _submit,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    if (widget.standalone) {
      return Scaffold(
        appBar: const KbAppBar(title: 'Setor Kompos'),
        body: KbScrollPage(children: _form(app)),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Setor Kompos',
          subtitle: 'Isi 5 langkah mudah di bawah ini',
          userName: u.name,
          notifCount: app.unreadCount(u.id),
          onNotifTap: () => NotificationsScreen.open(context),
        ),
        SliverToBoxAdapter(
          child: KbResponsive(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _form(app)),
            ),
          ),
        ),
      ],
    );
  }
}
