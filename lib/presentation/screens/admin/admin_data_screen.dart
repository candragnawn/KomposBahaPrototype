import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/seed/seed_data.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../app_root.dart';

/// Data contoh & reset data (Admin).
class AdminDataScreen extends StatelessWidget {
  const AdminDataScreen({super.key});

  Future<void> _loadDemo(BuildContext context) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Isi data contoh?',
      message: 'Menambahkan 5 warga contoh beserta riwayat setoran, poin, pengaduan, dan penukaran. '
          'Cocok untuk latihan atau presentasi. Data asli tidak dihapus.',
      confirmLabel: 'Ya, isi data contoh',
      icon: Icons.science_rounded,
    );
    if (!ok || !context.mounted) return;
    final added = context.read<AppProvider>().loadDemoData();
    showKbSnack(
      context,
      added == 0 ? 'Data contoh sudah pernah dimuat.' : '$added warga contoh berhasil ditambahkan.',
      error: added == 0,
    );
  }

  Future<void> _reset(BuildContext context) async {
    final ok1 = await showConfirmDialog(
      context,
      title: 'Hapus SEMUA data?',
      message: 'Semua warga, setoran, poin, penukaran, pengaduan, dan pengaturan akan dihapus permanen.',
      confirmLabel: 'Lanjutkan',
      danger: true,
    );
    if (!ok1 || !context.mounted) return;
    final ok2 = await showConfirmDialog(
      context,
      title: 'Yakin? Tidak bisa dibatalkan',
      message: 'Aplikasi akan kembali seperti baru dipasang dan Anda akan keluar dari akun.',
      confirmLabel: 'Ya, hapus semua',
      danger: true,
    );
    if (!ok2 || !context.mounted) return;
    final app = context.read<AppProvider>();
    popToRoot(context);
    await app.resetAllData();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: const KbAppBar(title: 'Data aplikasi'),
      body: KbScrollPage(
        children: [
          KbCard(
            child: Column(
              children: [
                InfoRow(label: 'Pengguna', value: '${app.users.length}'),
                InfoRow(label: 'Setoran', value: '${app.orders.length}'),
                InfoRow(label: 'Hadiah', value: '${app.rewards.length}'),
                InfoRow(label: 'Penukaran', value: '${app.redemptions.length}'),
                InfoRow(label: 'Pengaduan', value: '${app.complaints.length}'),
                InfoRow(label: 'Pengumuman', value: '${app.announcements.length}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const InfoBanner(
            title: 'Penyimpanan data',
            message: 'Data tersimpan aman di perangkat ini. Agar warga, driver, TPS, dan admin '
                'bisa memakai HP masing-masing dengan data yang sama, hubungkan aplikasi ke server '
                '(lihat README bagian "Server bersama").',
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Akun bawaan'),
          KbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow(label: 'Admin Desa', value: DefaultAccounts.adminPhone),
                InfoRow(label: 'Petugas TPS 3R', value: DefaultAccounts.tpsPhone),
                InfoRow(label: 'Driver 1', value: DefaultAccounts.driver1Phone),
                InfoRow(label: 'Driver 2', value: DefaultAccounts.driver2Phone),
                InfoRow(label: 'Warga contoh', value: DefaultAccounts.demoWargaPhone),
                const SizedBox(height: 6),
                Text(
                  'PIN awal semua akun bawaan: ${DefaultAccounts.pin}. Segera ganti PIN atau nonaktifkan akun yang tidak dipakai.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          KbButton(
            label: 'Isi data contoh',
            icon: Icons.science_rounded,
            variant: KbButtonVariant.secondary,
            onPressed: () => _loadDemo(context),
          ),
          const SizedBox(height: 12),
          KbButton(
            label: 'Hapus semua data',
            icon: Icons.delete_forever_rounded,
            variant: KbButtonVariant.danger,
            onPressed: () => _reset(context),
          ),
        ],
      ),
    );
  }
}
