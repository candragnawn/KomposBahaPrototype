import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_button.dart';

class WargaLoginScreen extends ConsumerStatefulWidget {
  const WargaLoginScreen({super.key});

  @override
  ConsumerState<WargaLoginScreen> createState() => _WargaLoginScreenState();
}

class _WargaLoginScreenState extends ConsumerState<WargaLoginScreen> {
  final _phoneController = TextEditingController(text: '0812 3456 7812');
  final _passController = TextEditingController(text: 'komposbaha');
  bool _showPassword = false;
  bool _isLoading = false;
  String _error = '';

  void _submit() {
    if (_phoneController.text.trim().isEmpty || _passController.text.length < 6) {
      setState(() => _error = 'Nomor HP atau kata sandi salah');
      return;
    }
    setState(() {
      _error = '';
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        ref.read(appStateProvider.notifier).setWargaLoggedIn(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMint,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Green Brand Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                        onPressed: () {
                          ref.read(appStateProvider.notifier).setRole(null);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(LucideIcons.leaf, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kompos Baha',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Layanan kompos Desa Baha',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Form Sheet
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Portal Warga',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Selamat datang kembali',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Masuk untuk mengatur penjemputan kompos dan poin Anda.',
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                      const SizedBox(height: 20),
                      if (_error.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.statusFailedBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.error),
                          ),
                          child: Text(
                            _error,
                            style: const TextStyle(color: AppColors.error, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Nomor HP',
                          hintText: '08xx xxxx xxxx',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: 'Kata sandi',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                              size: 18,
                              color: AppColors.muted,
                            ),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: _isLoading ? 'Sedang masuk...' : 'Masuk',
                        variant: ButtonVariant.primary,
                        wide: true,
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text.rich(
                            TextSpan(
                              text: 'Belum punya akun? ',
                              style: TextStyle(color: AppColors.muted, fontSize: 13),
                              children: [
                                TextSpan(
                                  text: 'Daftar lewat kader banjar',
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

