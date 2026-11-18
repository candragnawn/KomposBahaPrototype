import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_widgets.dart';
import '../app_root.dart';
import 'auth_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _pin = TextEditingController();
  final _pin2 = TextEditingController();
  String? _banjar;
  String? _banjarError;
  bool _agree = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _pin.dispose();
    _pin2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState!.validate();
    setState(() => _banjarError = _banjar == null ? 'Pilih banjar Anda' : null);
    if (!valid || _banjar == null) return;
    if (!_agree) {
      setState(() => _error = 'Mohon centang persetujuan terlebih dahulu.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await context.read<AppProvider>().register(
          name: _name.text,
          phone: _phone.text,
          pin: _pin.text,
          banjar: _banjar!,
          address: _address.text,
        );
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _loading = false;
        _error = err;
      });
      return;
    }
    popToRoot(context);
  }

  @override
  Widget build(BuildContext context) {
    final banjars = context.select<AppProvider, List<String>>((p) => p.settings.banjarList);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeroHeader(subtitle: 'Daftar akun warga Desa Baha', showBack: true),
            KbResponsive(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Buat akun baru', style: AppTypography.displaySmall),
                      const SizedBox(height: 4),
                      Text(
                        'Isi data diri Anda. Data ini dipakai driver untuk menjemput kompos.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
                      ),
                      const SizedBox(height: 24),
                      KbTextField(
                        label: 'Nama lengkap',
                        hint: 'Contoh: I Wayan Sudarta',
                        controller: _name,
                        prefixIcon: Icons.person_rounded,
                        validator: Validators.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                      ),
                      KbTextField(
                        label: 'Nomor HP (WhatsApp)',
                        hint: 'Contoh: 0812 3456 7890',
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_android_rounded,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
                        validator: Validators.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      KbSelectField<String>(
                        label: 'Banjar',
                        value: _banjar,
                        options: banjars,
                        labelOf: (b) => b,
                        icon: Icons.location_city_rounded,
                        hint: 'Pilih banjar',
                        errorText: _banjarError,
                        onChanged: (v) => setState(() {
                          _banjar = v;
                          _banjarError = null;
                        }),
                      ),
                      KbTextField(
                        label: 'Alamat rumah',
                        hint: 'Nama jalan, nomor rumah, patokan',
                        controller: _address,
                        maxLines: 2,
                        prefixIcon: Icons.home_rounded,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (v) => Validators.required(v, label: 'Alamat'),
                      ),
                      KbTextField(
                        label: 'Buat PIN (6 angka)',
                        helper: 'PIN dipakai setiap kali masuk. Jangan beritahu orang lain.',
                        controller: _pin,
                        obscure: true,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        prefixIcon: Icons.lock_rounded,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: Validators.pin,
                      ),
                      KbTextField(
                        label: 'Ulangi PIN',
                        controller: _pin2,
                        obscure: true,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        prefixIcon: Icons.lock_outline_rounded,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) => v != _pin.text ? 'PIN tidak sama' : null,
                      ),
                      InkWell(
                        onTap: () => setState(() => _agree = !_agree),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: Checkbox(
                                  value: _agree,
                                  onChanged: (v) => setState(() => _agree = v ?? false),
                                  activeColor: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Saya setuju data saya dipakai untuk layanan penjemputan kompos Desa Baha.',
                                  style: AppTypography.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        InfoBanner.error(message: _error!),
                      ],
                      const SizedBox(height: 20),
                      KbButton(label: 'Daftar & masuk', icon: Icons.check_rounded, loading: _loading, onPressed: _submit),
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
