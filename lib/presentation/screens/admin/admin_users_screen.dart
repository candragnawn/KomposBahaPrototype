import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/contact_service.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';

/// Daftar semua pengguna (Admin).
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _search = TextEditingController();
  int _role = 0;

  static const _roles = <(String, UserRole?)>[
    ('Semua', null),
    ('Warga', UserRole.warga),
    ('Driver', UserRole.driver),
    ('TPS 3R', UserRole.tps),
    ('Admin', UserRole.admin),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final me = app.currentUser;
    if (me == null) return const SizedBox.shrink();
    final q = _search.text.trim().toLowerCase();
    final role = _roles[_role].$2;
    final list = app.users.where((u) {
      if (role != null && u.role != role) return false;
      if (q.isNotEmpty && !u.name.toLowerCase().contains(q) && !u.phone.contains(q) && !u.banjar.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
        final r = a.role.index.compareTo(b.role.index);
        return r != 0 ? r : a.name.compareTo(b.name);
      });

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Pengguna',
          subtitle: '${app.users.length} akun terdaftar',
          userName: me.name,
          notifCount: app.unreadCount(me.id),
          onNotifTap: () => NotificationsScreen.open(context),
        ),
        SliverToBoxAdapter(
          child: KbResponsive(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KbButton(
                    label: 'Tambah pengguna',
                    icon: Icons.person_add_alt_1_rounded,
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UserFormScreen())),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _search,
                    style: AppTypography.bodyLarge,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Cari nama, nomor HP, banjar',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  KbFilterChips(
                    labels: _roles.map((e) => e.$1).toList(),
                    index: _role,
                    onChanged: (i) => setState(() => _role = i),
                  ),
                  const SizedBox(height: 16),
                  if (list.isEmpty)
                    const EmptyState(icon: Icons.person_search_rounded, title: 'Tidak ditemukan', message: 'Coba kata kunci lain.')
                  else
                    KbMenuGroup(children: [
                      for (final u in list)
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => UserDetailScreen(userId: u.id)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                KbAvatar(
                                  name: u.name,
                                  size: 48,
                                  color: !u.isActive ? AppColors.mutedLight : _roleColor(u.role),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        u.name,
                                        style: AppTypography.titleSmall.copyWith(
                                          color: u.isActive ? AppColors.dark : AppColors.mutedLight,
                                        ),
                                      ),
                                      Text(
                                        '${u.role.label} · ${Fmt.phone(u.phone)}${u.banjar.isEmpty ? '' : ' · ${u.banjar}'}',
                                        style: AppTypography.bodySmall,
                                      ),
                                      if (!u.isActive)
                                        Text('Nonaktif', style: AppTypography.labelMedium.copyWith(color: AppColors.error)),
                                    ],
                                  ),
                                ),
                                if (u.role == UserRole.warga)
                                  Text('${Fmt.number(u.points)} poin', style: AppTypography.labelLarge.copyWith(color: AppColors.goldText)),
                                const Icon(Icons.chevron_right_rounded, color: AppColors.mutedLight),
                              ],
                            ),
                          ),
                        ),
                    ]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Color _roleColor(UserRole r) => switch (r) {
      UserRole.warga => AppColors.primary,
      UserRole.driver => AppColors.info,
      UserRole.tps => AppColors.soil,
      UserRole.admin => AppColors.goldDark,
    };

/// Detail pengguna + aksi admin.
class UserDetailScreen extends StatelessWidget {
  final String userId;
  const UserDetailScreen({super.key, required this.userId});

  Future<void> _resetPin(BuildContext context, AppUser u) async {
    final pin = await showTextInputDialog(
      context,
      title: 'Atur ulang PIN ${u.name}',
      label: 'PIN baru (6 angka)',
      hint: 'Contoh: 482915',
      confirmLabel: 'Simpan PIN baru',
      keyboardType: TextInputType.number,
      maxLines: 1,
    );
    if (pin == null || !context.mounted) return;
    final v = Validators.pin(pin);
    if (v != null) {
      showKbSnack(context, v, error: true);
      return;
    }
    final err = context.read<AppProvider>().resetPin(u.id, pin);
    showKbSnack(context, err ?? 'PIN diatur ulang. Beri tahu pengguna PIN barunya.', error: err != null);
  }

  Future<void> _adjust(BuildContext context, AppUser u) async {
    final amount = await showTextInputDialog(
      context,
      title: 'Koreksi poin ${u.name}',
      label: 'Jumlah poin (pakai tanda minus untuk mengurangi)',
      hint: 'Contoh: 50 atau -20',
      confirmLabel: 'Lanjut',
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      maxLines: 1,
    );
    if (amount == null || !context.mounted) return;
    final delta = int.tryParse(amount.replaceAll(' ', '').replaceAll('+', ''));
    if (delta == null || delta == 0) {
      showKbSnack(context, 'Jumlah poin tidak valid.', error: true);
      return;
    }
    final reason = await showTextInputDialog(
      context,
      title: 'Alasan koreksi',
      label: 'Alasan',
      confirmLabel: 'Simpan koreksi',
      quickOptions: const ['Salah input timbangan', 'Bonus kegiatan desa', 'Penyesuaian data lama'],
    );
    if (reason == null || !context.mounted) return;
    final err = context.read<AppProvider>().adjustPoints(u.id, delta, reason);
    showKbSnack(context, err ?? 'Poin dikoreksi ${Fmt.signedPoints(delta)}', error: err != null);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.userById(userId);
    final me = app.currentUser;
    if (u == null || me == null) {
      return const Scaffold(appBar: KbAppBar(title: 'Pengguna'), body: SizedBox.shrink());
    }
    final isSelf = u.id == me.id;
    final orders = u.role == UserRole.warga
        ? app.ordersOfWarga(u.id)
        : u.role == UserRole.driver
            ? app.ordersOfDriver(u.id).reversed.toList()
            : <PickupOrder>[];

    return Scaffold(
      appBar: KbAppBar(
        title: u.name,
        subtitle: u.role.label,
        trailing: IconButton(
          tooltip: 'Ubah data',
          icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 26),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserFormScreen(user: u))),
        ),
      ),
      body: KbScrollPage(
        children: [
          KbCard(
            child: Column(
              children: [
                KbAvatar(name: u.name, size: 76, color: u.isActive ? _roleColor(u.role) : AppColors.mutedLight),
                const SizedBox(height: 10),
                Text(u.name, style: AppTypography.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 6),
                StatusPill(
                  label: u.isActive ? 'Aktif' : 'Nonaktif',
                  color: u.isActive ? AppColors.success : AppColors.error,
                  background: u.isActive ? AppColors.successLight : AppColors.errorLight,
                ),
                const SizedBox(height: 12),
                InfoRow(label: 'Peran', value: u.role.label),
                InfoRow(label: 'Nomor HP', value: Fmt.phone(u.phone)),
                if (u.banjar.isNotEmpty) InfoRow(label: 'Banjar', value: u.banjar),
                if (u.address.isNotEmpty) InfoRow(label: 'Alamat', value: u.address),
                if (u.role == UserRole.driver) InfoRow(label: 'Kendaraan', value: u.vehicle.isEmpty ? '-' : u.vehicle),
                if (u.role == UserRole.driver) InfoRow(label: 'Status', value: u.isAvailable ? 'Siap bertugas' : 'Libur'),
                if (u.role == UserRole.warga) ...[
                  InfoRow(label: 'Saldo poin', value: Fmt.number(u.points), valueColor: AppColors.goldText),
                  InfoRow(label: 'Total kompos', value: '${Fmt.kg(app.totalKgOfWarga(u.id))} kg'),
                ],
                InfoRow(label: 'Terdaftar', value: Fmt.date(u.createdAt)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: KbButton(
                        label: 'Telepon',
                        icon: Icons.call_rounded,
                        compact: true,
                        variant: KbButtonVariant.soft,
                        onPressed: () => ContactService.call(u.phone),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: KbButton(
                        label: 'WhatsApp',
                        icon: Icons.chat_rounded,
                        compact: true,
                        variant: KbButtonVariant.soft,
                        onPressed: () => ContactService.whatsapp(u.phone),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Tindakan'),
          KbMenuGroup(children: [
            KbMenuTile(
              icon: Icons.edit_rounded,
              title: 'Ubah data pengguna',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserFormScreen(user: u))),
            ),
            KbMenuTile(
              icon: Icons.lock_reset_rounded,
              title: 'Atur ulang PIN',
              subtitle: 'Jika pengguna lupa PIN',
              color: AppColors.soil,
              onTap: () => _resetPin(context, u),
            ),
            if (u.role == UserRole.warga)
              KbMenuTile(
                icon: Icons.exposure_rounded,
                title: 'Koreksi poin',
                subtitle: 'Tambah / kurangi poin dengan alasan',
                color: AppColors.goldDark,
                onTap: () => _adjust(context, u),
              ),
            if (!isSelf)
              KbMenuTile(
                icon: u.isActive ? Icons.person_off_rounded : Icons.person_rounded,
                title: u.isActive ? 'Nonaktifkan akun' : 'Aktifkan kembali',
                subtitle: u.isActive ? 'Pengguna tidak bisa masuk' : 'Pengguna bisa masuk lagi',
                color: u.isActive ? AppColors.error : AppColors.success,
                onTap: () async {
                  final ok = await showConfirmDialog(
                    context,
                    title: u.isActive ? 'Nonaktifkan ${u.name}?' : 'Aktifkan ${u.name}?',
                    message: u.isActive
                        ? 'Akun tidak bisa dipakai masuk sampai diaktifkan kembali. Data & poin tetap tersimpan.'
                        : 'Akun bisa dipakai masuk kembali.',
                    danger: u.isActive,
                    confirmLabel: u.isActive ? 'Ya, nonaktifkan' : 'Ya, aktifkan',
                  );
                  if (!ok || !context.mounted) return;
                  final err = context.read<AppProvider>().setUserActive(u.id, !u.isActive);
                  showKbSnack(context, err ?? 'Status akun diperbarui', error: err != null);
                },
              ),
          ]),
          if (u.role == UserRole.warga) ...[
            const SizedBox(height: 20),
            const SectionHeader(title: 'Mutasi poin terakhir'),
            Builder(builder: (_) {
              final ledger = app.ledgerOf(u.id).take(8).toList();
              if (ledger.isEmpty) {
                return Text('Belum ada mutasi poin.', style: AppTypography.bodySmall);
              }
              return KbMenuGroup(children: [
                for (final e in ledger)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.description, style: AppTypography.titleSmall),
                              Text(Fmt.dateTime(e.createdAt), style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                        Text(
                          Fmt.signedPoints(e.delta),
                          style: AppTypography.titleSmall.copyWith(color: e.delta >= 0 ? AppColors.success : AppColors.error),
                        ),
                      ],
                    ),
                  ),
              ]);
            }),
          ],
          if (orders.isNotEmpty) ...[
            const SizedBox(height: 20),
            SectionHeader(title: u.role == UserRole.driver ? 'Tugas terakhir' : 'Setoran terakhir'),
            for (final o in orders.take(5)) ...[
              OrderCard(order: o, showWarga: u.role == UserRole.driver, onTap: () => OrderDetailScreen.open(context, o.id)),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

/// Form tambah / ubah pengguna.
class UserFormScreen extends StatefulWidget {
  final AppUser? user;
  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.user?.name ?? '');
  late final TextEditingController _phone = TextEditingController(text: widget.user?.phone ?? '');
  late final TextEditingController _address = TextEditingController(text: widget.user?.address ?? '');
  late final TextEditingController _vehicle = TextEditingController(text: widget.user?.vehicle ?? '');
  final _pin = TextEditingController();
  late UserRole _role = widget.user?.role ?? UserRole.driver;
  late String? _banjar = (widget.user?.banjar.isEmpty ?? true) ? null : widget.user!.banjar;

  bool get _isEdit => widget.user != null;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _vehicle.dispose();
    _pin.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_role == UserRole.warga && _banjar == null) {
      showKbSnack(context, 'Pilih banjar untuk warga.', error: true);
      return;
    }
    final app = context.read<AppProvider>();
    final String? err;
    if (_isEdit) {
      err = app.updateUser(
        widget.user!.id,
        name: _name.text,
        phone: _phone.text,
        role: _role,
        banjar: _banjar ?? '',
        address: _address.text,
        vehicle: _vehicle.text,
      );
    } else {
      err = app.addUser(
        name: _name.text,
        phone: _phone.text,
        role: _role,
        pin: _pin.text,
        banjar: _banjar ?? '',
        address: _address.text,
        vehicle: _vehicle.text,
      );
    }
    if (err != null) {
      showKbSnack(context, err, error: true);
      return;
    }
    showKbSnack(context, _isEdit ? 'Data pengguna disimpan' : 'Pengguna ${_name.text.trim()} ditambahkan');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final banjars = [...app.settings.banjarList];
    final b = _banjar;
    if (b != null && !banjars.contains(b)) banjars.add(b);

    return Scaffold(
      appBar: KbAppBar(title: _isEdit ? 'Ubah pengguna' : 'Tambah pengguna'),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(label: _isEdit ? 'Simpan perubahan' : 'Tambah pengguna', icon: Icons.save_rounded, onPressed: _save),
      ]),
      body: Form(
        key: _formKey,
        child: KbScrollPage(
          children: [
            Text('Peran', style: AppTypography.titleSmall),
            const SizedBox(height: 8),
            for (final r in UserRole.values) ...[
              ChoiceTile(
                label: r.label,
                description: r.description,
                icon: r.icon,
                selected: _role == r,
                onTap: () => setState(() => _role = r),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 12),
            KbTextField(
              label: 'Nama lengkap',
              controller: _name,
              prefixIcon: Icons.person_rounded,
              validator: Validators.name,
              textCapitalization: TextCapitalization.words,
            ),
            KbTextField(
              label: 'Nomor HP',
              controller: _phone,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_android_rounded,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
              validator: Validators.phone,
            ),
            KbSelectField<String>(
              label: _role == UserRole.warga ? 'Banjar' : 'Banjar / wilayah (opsional)',
              value: _banjar,
              options: banjars,
              labelOf: (x) => x,
              icon: Icons.location_city_rounded,
              onChanged: (v) => setState(() => _banjar = v),
            ),
            KbTextField(
              label: 'Alamat',
              controller: _address,
              maxLines: 2,
              prefixIcon: Icons.home_rounded,
              textCapitalization: TextCapitalization.sentences,
              validator: _role == UserRole.warga ? (v) => Validators.required(v, label: 'Alamat') : null,
            ),
            if (_role == UserRole.driver)
              KbTextField(
                label: 'Nomor kendaraan',
                controller: _vehicle,
                prefixIcon: Icons.two_wheeler_rounded,
                textCapitalization: TextCapitalization.characters,
              ),
            if (!_isEdit)
              KbTextField(
                label: 'PIN awal (6 angka)',
                helper: 'Berikan PIN ini kepada pengguna. Minta mereka menggantinya setelah masuk.',
                controller: _pin,
                keyboardType: TextInputType.number,
                maxLength: 6,
                prefixIcon: Icons.lock_rounded,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.pin,
              ),
          ],
        ),
      ),
    );
  }
}
