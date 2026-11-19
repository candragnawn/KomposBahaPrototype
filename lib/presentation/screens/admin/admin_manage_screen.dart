import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/models/reward_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../common/notifications_screen.dart';
import 'admin_assign_page.dart';
import 'admin_content_screens.dart';
import 'admin_data_screen.dart';
import 'admin_reports_screen.dart';
import 'admin_reward_screens.dart';
import 'settings_screens.dart';

class _Module {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;
  final int badge;
  const _Module(this.title, this.subtitle, this.icon, this.color, this.page, {this.badge = 0});
}

/// Menu semua modul admin (ala grid menu CulTask).
class AdminManageScreen extends StatelessWidget {
  const AdminManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final pendingRedeem = app.redemptions.where((r) => r.status == RedemptionStatus.menunggu).length;
    final newComplaints = app.complaints.where((c) => c.status == ComplaintStatus.baru).length;
    final lowStock = app.rewards.where((r) => r.isActive && r.stock <= 2).length;

    final groups = <(String, List<_Module>)>[
      (
        'Operasional',
        [
          const _Module('Penugasan driver', 'Atur siapa menjemput', Icons.assignment_ind_rounded, AppColors.primary, AdminAssignPage()),
          _Module('Serahkan hadiah', 'Cek kode penukaran', Icons.confirmation_number_rounded, AppColors.goldDark,
              const AdminRedemptionsScreen(), badge: pendingRedeem),
          _Module('Pengaduan', 'Tanggapi keluhan warga', Icons.support_agent_rounded, AppColors.info,
              const AdminComplaintsScreen(), badge: newComplaints),
          const _Module('Pengumuman', 'Kabar untuk warga', Icons.campaign_rounded, AppColors.soil, AdminAnnouncementsScreen()),
        ]
      ),
      (
        'Poin & hadiah',
        [
          _Module('Katalog hadiah', 'Tambah, ubah, stok', Icons.card_giftcard_rounded, AppColors.goldDark,
              const AdminRewardsScreen(), badge: lowStock),
          const _Module('Tarif poin', 'Poin per kg & bonus', Icons.rule_rounded, AppColors.primaryDark, PointRateScreen()),
        ]
      ),
      (
        'Pengaturan & laporan',
        [
          const _Module('Kuota & jadwal', 'Kuota, jam, banjar', Icons.tune_rounded, AppColors.primary, QuotaSettingsScreen()),
          const _Module('Laporan bulanan', 'Rekap & ekspor CSV', Icons.insert_chart_rounded, AppColors.soil, AdminReportsScreen()),
          const _Module('Data aplikasi', 'Data contoh & reset', Icons.storage_rounded, AppColors.muted, AdminDataScreen()),
        ]
      ),
    ];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Kelola Layanan',
          subtitle: 'Semua pengaturan GOBAHA',
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
                  for (final g in groups) ...[
                    Text(g.$1, style: AppTypography.titleMedium),
                    const SizedBox(height: 10),
                    KbMenuGroup(children: [
                      for (final m in g.$2)
                        KbMenuTile(
                          icon: m.icon,
                          title: m.title,
                          subtitle: m.subtitle,
                          color: m.color,
                          badge: m.badge,
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => m.page)),
                        ),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
