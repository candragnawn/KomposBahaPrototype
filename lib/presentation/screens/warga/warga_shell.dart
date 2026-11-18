import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/reward_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_bottom_nav.dart';
import '../../widgets/common/kb_widgets.dart';
import '../common/announcements_screen.dart';
import '../common/profile_screen.dart';
import '../shell/role_shell.dart';
import 'complaint_screens.dart';
import 'guide_screen.dart';
import 'history_screen.dart';
import 'rewards_screen.dart';
import 'setor_screen.dart';
import 'warga_home_screen.dart';

class WargaShell extends StatelessWidget {
  const WargaShell({super.key});

  @override
  Widget build(BuildContext context) {
    final redemptionsWaiting = context.select<AppProvider, int>((p) {
      final u = p.currentUser;
      if (u == null) return 0;
      return p.redemptionsOf(u.id).where((r) => r.status == RedemptionStatus.menunggu).length;
    });

    return RoleShell(
      items: [
        const KbNavItem(activeIcon: Icons.home_rounded, inactiveIcon: Icons.home_outlined, label: 'Beranda'),
        const KbNavItem(activeIcon: Icons.add_circle_rounded, inactiveIcon: Icons.add_circle_outline_rounded, label: 'Setor'),
        KbNavItem(
          activeIcon: Icons.card_giftcard_rounded,
          inactiveIcon: Icons.card_giftcard_outlined,
          label: 'Hadiah',
          badge: redemptionsWaiting,
        ),
        const KbNavItem(activeIcon: Icons.receipt_long_rounded, inactiveIcon: Icons.receipt_long_outlined, label: 'Riwayat'),
        const KbNavItem(activeIcon: Icons.person_rounded, inactiveIcon: Icons.person_outline_rounded, label: 'Profil'),
      ],
      pages: const [
        WargaHomeScreen(),
        SetorScreen(),
        RewardsScreen(),
        WargaHistoryScreen(),
        _WargaProfile(),
      ],
    );
  }
}

class _WargaProfile extends StatelessWidget {
  const _WargaProfile();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    return ProfileScreen(
      stats: [
        ProfileStat(Fmt.number(u.points), 'Poin'),
        ProfileStat('${Fmt.kg(app.totalKgOfWarga(u.id))} kg', 'Total kompos'),
        ProfileStat('${app.completedCountOfWarga(u.id)}x', 'Setoran'),
      ],
      extraMenus: [
        KbMenuTile(
          icon: Icons.menu_book_rounded,
          title: 'Panduan membuat kompos',
          subtitle: 'Agar kompos diterima TPS 3R',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideScreen())),
        ),
        KbMenuTile(
          icon: Icons.campaign_rounded,
          title: 'Pengumuman desa',
          color: AppColors.goldDark,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
        ),
        KbMenuTile(
          icon: Icons.support_agent_rounded,
          title: 'Pengaduan saya',
          subtitle: 'Sampaikan keluhan & saran',
          color: AppColors.info,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComplaintListScreen())),
        ),
      ],
    );
  }
}
