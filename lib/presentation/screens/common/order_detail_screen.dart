import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/contact_service.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/common/photo_picker.dart';
import '../../widgets/order/driver_picker.dart';
import '../../widgets/order/order_widgets.dart';
import '../tps/verify_screen.dart';
import '../warga/complaint_screens.dart';
import '../warga/setor_screen.dart';

/// Detail setoran — tampilan & tombol aksi menyesuaikan peran pengguna.
class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  static Future<void> open(BuildContext context, String orderId) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
      );

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String? _pickupPhoto;

  void _result(String? err, String success) {
    if (!mounted) return;
    if (err != null) {
      showKbSnack(context, err, error: true);
    } else {
      showKbSnack(context, success);
    }
  }

  // ─── Aksi ──────────────────────────────────────────────────────────────
  Future<void> _cancel(PickupOrder o) async {
    final isWarga = context.read<AppProvider>().currentUser?.role == UserRole.warga;
    final reason = await showTextInputDialog(
      context,
      title: 'Batalkan setoran ${o.code}?',
      label: 'Alasan pembatalan',
      confirmLabel: 'Ya, batalkan setoran',
      danger: true,
      quickOptions: isWarga
          ? const ['Kompos belum siap', 'Saya tidak di rumah', 'Salah memasukkan data']
          : const ['Atas permintaan warga', 'Kuota TPS 3R penuh', 'Data setoran tidak valid'],
    );
    if (reason == null || !mounted) return;
    _result(context.read<AppProvider>().cancelOrder(o.id, reason), 'Setoran dibatalkan');
  }

  Future<void> _assign(PickupOrder o) async {
    final id = await pickDriver(context, o);
    if (id == null || !mounted) return;
    _result(context.read<AppProvider>().assignDriver(o.id, id), 'Driver berhasil ditugaskan');
  }

  Future<void> _start(PickupOrder o) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Mulai penjemputan?',
      message: 'Warga akan diberi tahu bahwa Anda sedang menuju rumahnya.',
      confirmLabel: 'Ya, mulai jemput',
      icon: Icons.local_shipping_rounded,
    );
    if (!ok || !mounted) return;
    _result(context.read<AppProvider>().startPickup(o.id), 'Penjemputan dimulai. Hati-hati di jalan!');
  }

  void _collected(PickupOrder o) {
    _result(context.read<AppProvider>().confirmCollected(o.id, _pickupPhoto), 'Kompos sudah diambil');
  }

  Future<void> _delivered(PickupOrder o) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Sudah sampai di TPS 3R?',
      message: 'Pastikan kompos sudah diserahkan ke petugas TPS 3R.',
      confirmLabel: 'Ya, sudah diantar',
      icon: Icons.warehouse_rounded,
    );
    if (!ok || !mounted) return;
    _result(context.read<AppProvider>().confirmDelivered(o.id), 'Terima kasih! Kompos menunggu ditimbang.');
  }

  Future<void> _fail(PickupOrder o) async {
    final reason = await showTextInputDialog(
      context,
      title: 'Laporkan gagal jemput',
      label: 'Alasan',
      confirmLabel: 'Kirim laporan',
      danger: true,
      quickOptions: const [
        'Warga tidak di tempat',
        'Kompos belum siap',
        'Alamat tidak ditemukan',
        'Kompos tercampur sampah plastik',
      ],
    );
    if (reason == null || !mounted) return;
    _result(context.read<AppProvider>().failPickup(o.id, reason), 'Laporan gagal jemput terkirim');
  }

  Future<void> _reject(PickupOrder o) async {
    final reason = await showTextInputDialog(
      context,
      title: 'Tolak kompos ${o.code}',
      label: 'Alasan penolakan',
      confirmLabel: 'Tolak kompos',
      danger: true,
      quickOptions: const [
        'Tercampur sampah plastik / anorganik',
        'Kompos belum matang (masih berbau busuk)',
        'Kadar air terlalu tinggi (becek)',
        'Berat tidak sesuai / terlalu sedikit',
      ],
    );
    if (reason == null || !mounted) return;
    _result(context.read<AppProvider>().rejectOrder(o.id, reason), 'Kompos ditolak, warga sudah diberi tahu');
  }

  // ─── UI ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final o = app.orderById(widget.orderId);
    final me = app.currentUser;

    if (o == null || me == null) {
      return const Scaffold(
        appBar: KbAppBar(title: 'Detail setoran'),
        body: KbScrollPage(children: [
          EmptyState(icon: Icons.search_off_rounded, title: 'Data tidak ditemukan', message: 'Setoran ini mungkin sudah dihapus.'),
        ]),
      );
    }

    final driver = app.userById(o.driverId);
    final isWarga = me.role == UserRole.warga;
    final isDriver = me.role == UserRole.driver;
    final isStaff = me.role == UserRole.tps || me.role == UserRole.admin;

    final actions = <Widget>[];
    if (isWarga && (o.status == OrderStatus.menunggu || o.status == OrderStatus.ditugaskan)) {
      actions.add(KbButton(
        label: 'Batalkan setoran',
        icon: Icons.cancel_rounded,
        variant: KbButtonVariant.danger,
        onPressed: () => _cancel(o),
      ));
    }
    if (isWarga && (o.status == OrderStatus.gagal || o.status == OrderStatus.ditolak || o.status == OrderStatus.dibatalkan)) {
      actions.add(KbButton(
        label: 'Setor ulang',
        icon: Icons.add_circle_rounded,
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SetorScreen(standalone: true)),
        ),
      ));
    }
    if (isDriver && o.driverId == me.id) {
      if (o.status == OrderStatus.ditugaskan) {
        actions.add(KbButton(label: 'Mulai jemput', icon: Icons.play_arrow_rounded, onPressed: () => _start(o)));
      } else if (o.status == OrderStatus.dijemput && !o.collected) {
        actions.add(KbButton(
          label: 'Kompos sudah diambil',
          icon: Icons.inventory_2_rounded,
          onPressed: _pickupPhoto == null ? null : () => _collected(o),
        ));
      } else if (o.status == OrderStatus.dijemput && o.collected) {
        actions.add(KbButton(
          label: 'Sudah diantar ke TPS 3R',
          icon: Icons.warehouse_rounded,
          variant: KbButtonVariant.gold,
          onPressed: () => _delivered(o),
        ));
      }
      if (o.status == OrderStatus.ditugaskan || (o.status == OrderStatus.dijemput && !o.collected)) {
        actions.add(KbButton(
          label: 'Gagal jemput',
          icon: Icons.report_rounded,
          variant: KbButtonVariant.danger,
          onPressed: () => _fail(o),
        ));
      }
    }
    if (isStaff) {
      if (o.status == OrderStatus.diantar) {
        actions.add(KbButton(
          label: 'Timbang & verifikasi',
          icon: Icons.scale_rounded,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => VerifyScreen(orderId: o.id))),
        ));
        actions.add(KbButton(
          label: 'Tolak kompos',
          icon: Icons.block_rounded,
          variant: KbButtonVariant.danger,
          onPressed: () => _reject(o),
        ));
      }
      if (o.status == OrderStatus.menunggu || o.status == OrderStatus.ditugaskan) {
        actions.add(KbButton(
          label: o.driverId == null ? 'Tugaskan driver' : 'Ganti driver',
          icon: Icons.assignment_ind_rounded,
          onPressed: () => _assign(o),
        ));
        actions.add(KbButton(
          label: 'Batalkan setoran',
          icon: Icons.cancel_rounded,
          variant: KbButtonVariant.ghost,
          onPressed: () => _cancel(o),
        ));
      }
    }

    return Scaffold(
      appBar: KbAppBar(title: 'Setoran ${o.code}', subtitle: Fmt.dateLong(o.pickupDate)),
      bottomNavigationBar: actions.isEmpty ? null : KbBottomActionBar(children: actions),
      body: KbScrollPage(
        children: [
          // ── Status ──
          KbCard(
            color: o.status.background,
            borderColor: o.status.color.withValues(alpha: 0.3),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: Icon(o.status.icon, color: o.status.color, size: 32),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.status.label, style: AppTypography.titleLarge.copyWith(color: o.status.color)),
                      const SizedBox(height: 4),
                      Text(o.status.explanation, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (o.rejectionReason != null && o.status == OrderStatus.ditolak) ...[
            const SizedBox(height: 12),
            InfoBanner.error(title: 'Alasan ditolak', message: o.rejectionReason!),
          ],
          if (o.failureReason != null && o.status == OrderStatus.gagal) ...[
            const SizedBox(height: 12),
            InfoBanner.error(title: 'Alasan gagal jemput', message: o.failureReason!),
          ],
          if (o.cancelReason != null && o.status == OrderStatus.dibatalkan) ...[
            const SizedBox(height: 12),
            InfoBanner.warning(title: 'Alasan dibatalkan', message: o.cancelReason!),
          ],

          // ── Hasil verifikasi ──
          if (o.status == OrderStatus.selesai) ...[
            const SizedBox(height: 16),
            KbCard(
              color: AppColors.goldLight,
              borderColor: AppColors.gold.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: AppColors.goldDark, size: 28),
                      const SizedBox(width: 10),
                      Expanded(child: Text('Hasil timbang TPS 3R', style: AppTypography.titleMedium)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InfoRow(label: 'Berat resmi', value: '${Fmt.kg(o.officialKg ?? 0)} kg'),
                  InfoRow(label: 'Kualitas', value: o.quality?.label ?? '-'),
                  InfoRow(label: 'Poin dasar', value: '+${Fmt.number(o.pointsEarned)}'),
                  if (o.bonusPoints > 0) InfoRow(label: 'Bonus', value: '+${Fmt.number(o.bonusPoints)}'),
                  const Divider(height: 20),
                  Row(
                    children: [
                      Expanded(child: Text('Total poin', style: AppTypography.titleMedium)),
                      Text(
                        '+${Fmt.number(o.totalPoints)}',
                        style: AppTypography.displaySmall.copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                  if (o.checklist.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final c in o.checklist)
                          StatusPill(label: c, color: AppColors.success, background: AppColors.white, icon: Icons.check_rounded),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          // ── Timeline ──
          const SizedBox(height: 20),
          const SectionHeader(title: 'Perjalanan setoran'),
          KbCard(child: StatusTimeline(order: o)),

          // ── Info penjemputan ──
          const SizedBox(height: 20),
          const SectionHeader(title: 'Info penjemputan'),
          KbCard(
            child: Column(
              children: [
                InfoRow(icon: Icons.event_rounded, label: 'Tanggal', value: Fmt.relativeDay(o.pickupDate)),
                InfoRow(icon: Icons.schedule_rounded, label: 'Jam', value: '${o.timeSlot} WITA'),
                InfoRow(icon: Icons.scale_rounded, label: 'Perkiraan berat', value: '±${Fmt.kg(o.estimatedKg)} kg'),
                InfoRow(icon: Icons.location_city_rounded, label: 'Banjar', value: o.banjar),
                InfoRow(icon: Icons.home_rounded, label: 'Alamat', value: o.address),
                if (o.notes.isNotEmpty) InfoRow(icon: Icons.sticky_note_2_rounded, label: 'Catatan', value: o.notes),
              ],
            ),
          ),

          // ── Kontak warga (driver/staff) ──
          if (!isWarga) ...[
            const SizedBox(height: 20),
            const SectionHeader(title: 'Warga'),
            _PersonCard(
              name: o.wargaName,
              subtitle: '${Fmt.phone(o.wargaPhone)} · Banjar ${o.banjar}',
              phone: o.wargaPhone,
              address: o.address,
            ),
          ],

          // ── Driver ──
          if (o.driverName != null && !isDriver) ...[
            const SizedBox(height: 20),
            const SectionHeader(title: 'Driver penjemput'),
            _PersonCard(
              name: o.driverName!,
              subtitle: driver == null ? 'Driver Desa Baha' : '${driver.vehicle.isEmpty ? 'Driver Desa Baha' : driver.vehicle} · ${Fmt.phone(driver.phone)}',
              phone: driver?.phone,
            ),
          ],

          // ── Foto ──
          const SizedBox(height: 20),
          const SectionHeader(title: 'Foto'),
          KbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PhotoPreview(label: 'Foto dari warga', path: o.photoWarga),
                if (o.photoPickup != null) ...[
                  const SizedBox(height: 14),
                  PhotoPreview(label: 'Foto saat diambil driver', path: o.photoPickup),
                ],
                if (o.photoTps != null) ...[
                  const SizedBox(height: 14),
                  PhotoPreview(label: 'Foto di TPS 3R', path: o.photoTps),
                ],
              ],
            ),
          ),

          // ── Driver: foto pengambilan ──
          if (isDriver && o.driverId == me.id && o.status == OrderStatus.dijemput && !o.collected) ...[
            const SizedBox(height: 20),
            const InfoBanner(
              title: 'Langkah berikutnya',
              message: 'Foto kompos saat Anda mengambilnya, lalu tekan "Kompos sudah diambil".',
            ),
            const SizedBox(height: 14),
            PhotoPickerTile(
              label: 'Foto bukti pengambilan',
              path: _pickupPhoto,
              onPicked: (p) => setState(() => _pickupPhoto = p),
              onRemove: () => setState(() => _pickupPhoto = null),
            ),
          ],

          // ── Warga: laporkan masalah ──
          if (isWarga) ...[
            const SizedBox(height: 20),
            KbMenuGroup(children: [
              KbMenuTile(
                icon: Icons.support_agent_rounded,
                title: 'Ada masalah dengan setoran ini?',
                subtitle: 'Kirim pengaduan ke Admin Desa',
                color: AppColors.info,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ComplaintFormScreen(orderCode: o.code)),
                ),
              ),
            ]),
          ],
          const SizedBox(height: 8),
          Text('Dibuat ${Fmt.dateTime(o.createdAt)}', textAlign: TextAlign.center, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? phone;
  final String? address;

  const _PersonCard({required this.name, required this.subtitle, this.phone, this.address});

  @override
  Widget build(BuildContext context) {
    final p = phone;
    final a = address;
    return KbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              KbAvatar(name: name, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.titleMedium),
                    Text(subtitle, style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (p != null || a != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (p != null) ...[
                  Expanded(
                    child: KbButton(
                      label: 'Telepon',
                      icon: Icons.call_rounded,
                      compact: true,
                      variant: KbButtonVariant.soft,
                      onPressed: () => ContactService.call(p),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: KbButton(
                      label: 'WhatsApp',
                      icon: Icons.chat_rounded,
                      compact: true,
                      variant: KbButtonVariant.soft,
                      onPressed: () => ContactService.whatsapp(p),
                    ),
                  ),
                ],
                if (a != null) ...[
                  if (p != null) const SizedBox(width: 8),
                  Expanded(
                    child: KbButton(
                      label: 'Peta',
                      icon: Icons.map_rounded,
                      compact: true,
                      variant: KbButtonVariant.soft,
                      onPressed: () => ContactService.openMap('$a, Desa Baha, Mengwi, Badung, Bali'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
