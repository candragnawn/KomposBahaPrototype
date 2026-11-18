import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/contact_service.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_image.dart';
import '../../widgets/common/kb_widgets.dart';
import '../app_root.dart';
import 'notifications_screen.dart';

class ProfileStat {
  final String value;
  final String label;
  const ProfileStat(this.value, this.label);
}

/// Halaman profil bersama untuk semua peran.
class ProfileScreen extends StatelessWidget {
  final List<ProfileStat> stats;
  final List<Widget> extraMenus;
  final String extraTitle;

  const ProfileScreen({
    super.key,
    this.stats = const [],
    this.extraMenus = const [],
    this.extraTitle = 'Layanan',
  });

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Profil Saya',
          subtitle: u.role.label,
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
                  _ProfileHeaderCard(user: u, stats: stats),
                  const SizedBox(height: 24),
                  if (extraMenus.isNotEmpty) ...[
                    Text(extraTitle, style: AppTypography.titleMedium),
                    const SizedBox(height: 10),
                    KbMenuGroup(children: extraMenus),
                    const SizedBox(height: 24),
                  ],
                  Text('Akun', style: AppTypography.titleMedium),
                  const SizedBox(height: 10),
                  KbMenuGroup(children: [
                    KbMenuTile(
                      icon: Icons.edit_rounded,
                      title: 'Ubah data diri',
                      subtitle: 'Nama, alamat, banjar',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    ),
                    KbMenuTile(
                      icon: Icons.lock_reset_rounded,
                      title: 'Ganti PIN',
                      subtitle: 'Demi keamanan akun',
                      color: AppColors.soil,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePinScreen())),
                    ),
                    KbMenuTile(
                      icon: Icons.format_size_rounded,
                      title: 'Ukuran huruf',
                      subtitle: _scaleLabel(app.textScale),
                      color: AppColors.goldDark,
                      onTap: () => showTextSizeSheet(context),
                    ),
                    KbMenuTile(
                      icon: Icons.notifications_rounded,
                      title: 'Notifikasi',
                      color: AppColors.info,
                      badge: app.unreadCount(u.id),
                      onTap: () => NotificationsScreen.open(context),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Text('Bantuan', style: AppTypography.titleMedium),
                  const SizedBox(height: 10),
                  KbMenuGroup(children: [
                    KbMenuTile(
                      icon: Icons.chat_rounded,
                      title: 'Chat Admin Desa (WhatsApp)',
                      subtitle: Fmt.phone(app.settings.adminPhone),
                      color: AppColors.success,
                      onTap: () async {
                        final ok = await ContactService.whatsapp(app.settings.adminPhone,
                            message: 'Halo Admin Desa, saya ${u.name} (${u.role.label}) pengguna Kompos Baha.');
                        if (!ok && context.mounted) showKbSnack(context, 'WhatsApp tidak dapat dibuka.', error: true);
                      },
                    ),
                    KbMenuTile(
                      icon: Icons.call_rounded,
                      title: 'Telepon Admin Desa',
                      color: AppColors.primary,
                      onTap: () => ContactService.call(app.settings.adminPhone),
                    ),
                    KbMenuTile(
                      icon: Icons.apartment_rounded,
                      title: 'Kantor Desa Baha',
                      subtitle: '${app.settings.officeAddress}\n${app.settings.officeHours}',
                      color: AppColors.soil,
                      trailing: const Icon(Icons.map_rounded, color: AppColors.primary),
                      onTap: () => ContactService.openMap(app.settings.officeAddress),
                    ),
                    KbMenuTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Tentang aplikasi',
                      subtitle: 'Kompos Baha versi 1.0.0',
                      color: AppColors.primaryDark,
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: 'Kompos Baha',
                        applicationVersion: '1.0.0',
                        applicationIcon: const KbImage(AppAssets.logo, width: 56, height: 56, fit: BoxFit.contain),
                        children: const [
                          Text('Layanan setor kompos, poin, dan hadiah untuk warga Desa Baha.'),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  KbButton(
                    label: 'Keluar dari akun',
                    icon: Icons.logout_rounded,
                    variant: KbButtonVariant.danger,
                    onPressed: () async {
                      final ok = await showConfirmDialog(
                        context,
                        title: 'Keluar dari akun?',
                        message: 'Anda perlu memasukkan nomor HP dan PIN lagi untuk masuk.',
                        confirmLabel: 'Ya, keluar',
                        danger: true,
                        icon: Icons.logout_rounded,
                      );
                      if (ok && context.mounted) {
                        popToRoot(context);
                        await context.read<AppProvider>().logout();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _scaleLabel(double s) {
    if (s >= 1.25) return 'Sangat besar';
    if (s >= 1.1) return 'Besar';
    return 'Normal';
  }
}

Future<void> showTextSizeSheet(BuildContext context) {
  final app = context.read<AppProvider>();
  return showModalBottomSheet<void>(
    context: context,
    builder: (ctx) {
      final current = ctx.watch<AppProvider>().textScale;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Ukuran huruf', style: AppTypography.titleLarge),
              const SizedBox(height: 4),
              Text('Pilih ukuran yang paling nyaman dibaca.', style: AppTypography.bodySmall),
              const SizedBox(height: 16),
              for (final opt in const [(1.0, 'Normal'), (1.15, 'Besar'), (1.3, 'Sangat besar')]) ...[
                ChoiceTile(
                  label: opt.$2,
                  description: 'Contoh tulisan Kompos Baha',
                  icon: Icons.text_fields_rounded,
                  selected: (current - opt.$1).abs() < 0.01,
                  onTap: () => app.setTextScale(opt.$1),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _ProfileHeaderCard extends StatelessWidget {
  final AppUser user;
  final List<ProfileStat> stats;
  const _ProfileHeaderCard({required this.user, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: KbImage(
              AppAssets.bg3,
              fallback: Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryDeep.withValues(alpha: 0.9),
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -24,
            right: -24,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.6), width: 3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: KbAvatar(name: user.name, size: 76, color: AppColors.gold, assetPath: AppAssets.avatar),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTypography.titleLarge.copyWith(color: Colors.white)),
                          const SizedBox(height: 2),
                          Text(Fmt.phone(user.phone), style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(99)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(user.role.icon, size: 16, color: AppColors.dark),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    user.banjar.isEmpty ? user.role.label : '${user.role.label} · ${user.banjar}',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelMedium.copyWith(color: AppColors.dark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (stats.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < stats.length; i++) ...[
                          if (i > 0) Container(width: 1, height: 36, color: Colors.white24),
                          Expanded(
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    stats[i].value,
                                    style: AppTypography.titleLarge.copyWith(color: Colors.white),
                                  ),
                                ),
                                Text(
                                  stats[i].label,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ubah data diri ─────────────────────────────────────────────────────────

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _vehicle;
  late final TextEditingController _phone;
  String? _banjar;

  @override
  void initState() {
    super.initState();
    final u = context.read<AppProvider>().currentUser;
    _name = TextEditingController(text: u?.name ?? '');
    _address = TextEditingController(text: u?.address ?? '');
    _vehicle = TextEditingController(text: u?.vehicle ?? '');
    _phone = TextEditingController(text: Fmt.phone(u?.phone ?? ''));
    _banjar = (u?.banjar.isEmpty ?? true) ? null : u!.banjar;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _vehicle.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final app = context.read<AppProvider>();
    final err = app.updateProfile(
      name: _name.text,
      address: _address.text,
      banjar: _banjar,
      vehicle: _vehicle.text,
    );
    if (err != null) {
      showKbSnack(context, err, error: true);
      return;
    }
    showKbSnack(context, 'Data diri berhasil disimpan');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final banjars = [...app.settings.banjarList];
    if (_banjar != null && !banjars.contains(_banjar)) banjars.add(_banjar!);
    final isWarga = u.role == UserRole.warga;
    final isDriver = u.role == UserRole.driver;

    return Scaffold(
      appBar: const KbAppBar(title: 'Ubah data diri'),
      body: Form(
        key: _formKey,
        child: KbScrollPage(
          children: [
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
              enabled: false,
              prefixIcon: Icons.phone_android_rounded,
              helper: 'Nomor HP hanya bisa diubah oleh Admin Desa.',
            ),
            if (isWarga || isDriver)
              KbSelectField<String>(
                label: 'Banjar',
                value: _banjar,
                options: banjars,
                labelOf: (b) => b,
                icon: Icons.location_city_rounded,
                onChanged: (v) => setState(() => _banjar = v),
              ),
            KbTextField(
              label: isWarga ? 'Alamat rumah (untuk penjemputan)' : 'Alamat',
              controller: _address,
              maxLines: 2,
              prefixIcon: Icons.home_rounded,
              textCapitalization: TextCapitalization.sentences,
              validator: isWarga ? (v) => Validators.required(v, label: 'Alamat') : null,
            ),
            if (isDriver)
              KbTextField(
                label: 'Nomor kendaraan',
                controller: _vehicle,
                prefixIcon: Icons.two_wheeler_rounded,
                textCapitalization: TextCapitalization.characters,
              ),
            const SizedBox(height: 8),
            KbButton(label: 'Simpan', icon: Icons.save_rounded, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

// ─── Ganti PIN ──────────────────────────────────────────────────────────────

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _new2 = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _new2.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final err = context.read<AppProvider>().changePin(_old.text, _new.text);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    showKbSnack(context, 'PIN berhasil diganti');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = [FilteringTextInputFormatter.digitsOnly];
    return Scaffold(
      appBar: const KbAppBar(title: 'Ganti PIN'),
      body: Form(
        key: _formKey,
        child: KbScrollPage(
          children: [
            const InfoBanner(message: 'PIN terdiri dari 6 angka. Hindari tanggal lahir atau angka berurutan seperti 123456.'),
            const SizedBox(height: 20),
            KbTextField(
              label: 'PIN lama',
              controller: _old,
              obscure: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: fmt,
              prefixIcon: Icons.lock_outline_rounded,
              validator: Validators.pin,
            ),
            KbTextField(
              label: 'PIN baru',
              controller: _new,
              obscure: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: fmt,
              prefixIcon: Icons.lock_rounded,
              validator: Validators.pin,
            ),
            KbTextField(
              label: 'Ulangi PIN baru',
              controller: _new2,
              obscure: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: fmt,
              prefixIcon: Icons.lock_rounded,
              validator: (v) => v != _new.text ? 'PIN tidak sama' : null,
            ),
            if (_error != null) ...[InfoBanner.error(message: _error!), const SizedBox(height: 16)],
            KbButton(label: 'Simpan PIN baru', icon: Icons.check_rounded, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
