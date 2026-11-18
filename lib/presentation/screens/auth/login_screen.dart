import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../data/services/contact_service.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_widgets.dart';
import 'auth_header.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  bool _showPin = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await context.read<AppProvider>().login(_phone.text, _pin.text);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = err;
    });
  }

  void _forgotPin() {
    final admin = context.read<AppProvider>().settings.adminPhone;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 44),
        title: const Text('Lupa PIN?', textAlign: TextAlign.center),
        content: const Text(
          'Demi keamanan, PIN hanya bisa diatur ulang oleh Admin Desa. '
          'Hubungi Admin Desa lewat WhatsApp, sebutkan nama dan nomor HP Anda.',
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              KbButton(
                label: 'Chat Admin Desa',
                icon: Icons.chat_rounded,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ContactService.whatsapp(admin, message: 'Halo Admin Desa, saya lupa PIN aplikasi Kompos Baha. Nomor HP saya: ${_phone.text}');
                },
              ),
              const SizedBox(height: 8),
              KbButton(label: 'Tutup', variant: KbButtonVariant.ghost, onPressed: () => Navigator.of(ctx).pop()),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeroHeader(subtitle: 'Sampah jadi berkah untuk Desa Baha'),
            KbResponsive(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Masuk ke akun Anda', style: AppTypography.displaySmall),
                      const SizedBox(height: 4),
                      Text(
                        'Gunakan nomor HP dan PIN 6 angka yang sudah didaftarkan.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
                      ),
                      const SizedBox(height: 24),
                      KbTextField(
                        label: 'Nomor HP',
                        hint: 'Contoh: 0812 3456 7890',
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_android_rounded,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
                        validator: Validators.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      KbTextField(
                        label: 'PIN (6 angka)',
                        hint: '••••••',
                        controller: _pin,
                        obscure: !_showPin,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        prefixIcon: Icons.lock_rounded,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: Validators.pin,
                        textInputAction: TextInputAction.done,
                        suffix: IconButton(
                          tooltip: _showPin ? 'Sembunyikan PIN' : 'Lihat PIN',
                          icon: Icon(_showPin ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                          onPressed: () => setState(() => _showPin = !_showPin),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: _forgotPin, child: const Text('Lupa PIN?')),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        InfoBanner.error(message: _error!),
                      ],
                      const SizedBox(height: 16),
                      KbButton(label: 'Masuk', icon: Icons.login_rounded, loading: _loading, onPressed: _submit),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Warga baru?', style: AppTypography.bodySmall),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      KbButton(
                        label: 'Daftar sebagai warga',
                        icon: Icons.person_add_alt_1_rounded,
                        variant: KbButtonVariant.secondary,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Akun Driver, Petugas TPS 3R, dan Admin dibuat oleh Admin Desa.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
