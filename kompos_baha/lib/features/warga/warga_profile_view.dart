import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_button.dart';

class WargaProfileView extends ConsumerWidget {
  const WargaProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Akun warga', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 2),
          const Text('Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
          const SizedBox(height: 24),
          const Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primaryGreen,
              child: Text('WS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('I Wayan Sudarta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('Warga terverifikasi Â· Desa Baha', style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                _ProfileRow(label: 'Nomor HP', value: '0812 3456 7812'),
                Divider(height: 20, color: AppColors.border),
                _ProfileRow(label: 'Banjar', value: 'Baha Kelod'),
                Divider(height: 20, color: AppColors.border),
                _ProfileRow(label: 'Alamat', value: 'Jl. Baha No. 18'),
                Divider(height: 20, color: AppColors.border),
                _ProfileRow(label: 'Total setoran', value: '42,5 kg'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'Keluar dari akun',
            variant: ButtonVariant.danger,
            icon: LucideIcons.logOut,
            wide: true,
            onPressed: () {
              ref.read(appStateProvider.notifier).setWargaLoggedIn(false);
              ref.read(appStateProvider.notifier).setRole(null);
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
      ],
    );
  }
}

