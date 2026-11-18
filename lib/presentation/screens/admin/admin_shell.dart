import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/reward_model.dart';
import '../../../data/models/user_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_bottom_nav.dart';
import '../common/profile_screen.dart';
import '../shell/role_shell.dart';
import 'admin_dashboard_screen.dart';
import 'admin_manage_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_users_screen.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = context.select<AppProvider, (int, int)>((p) {
      final waiting = p.orders.where((o) => o.status == OrderStatus.menunggu).length;
      final manage = p.complaints.where((c) => c.status == ComplaintStatus.baru).length +
          p.redemptions.where((r) => r.status == RedemptionStatus.menunggu).length;
      return (waiting, manage);
    });
    return RoleShell(
      items: [
        const KbNavItem(activeIcon: Icons.dashboard_rounded, inactiveIcon: Icons.dashboard_outlined, label: 'Beranda'),
        KbNavItem(
          activeIcon: Icons.receipt_long_rounded,
          inactiveIcon: Icons.receipt_long_outlined,
          label: 'Setoran',
          badge: badges.$1,
        ),
        const KbNavItem(activeIcon: Icons.groups_rounded, inactiveIcon: Icons.groups_outlined, label: 'Pengguna'),
        KbNavItem(activeIcon: Icons.apps_rounded, inactiveIcon: Icons.apps_outlined, label: 'Kelola', badge: badges.$2),
        const KbNavItem(activeIcon: Icons.person_rounded, inactiveIcon: Icons.person_outline_rounded, label: 'Profil'),
      ],
      pages: const [
        AdminDashboardScreen(),
        AdminOrdersScreen(),
        AdminUsersScreen(),
        AdminManageScreen(),
        _AdminProfile(),
      ],
    );
  }
}

class _AdminProfile extends StatelessWidget {
  const _AdminProfile();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final wargaCount = app.users.where((u) => u.role == UserRole.warga).length;
    final m = app.monthStats(DateTime.now());
    return ProfileScreen(stats: [
      ProfileStat('$wargaCount', 'Warga terdaftar'),
      ProfileStat('${Fmt.kg(m.verifiedKg)} kg', 'Kompos bulan ini'),
      ProfileStat(Fmt.number(m.pointsIssued), 'Poin terbit'),
    ]);
  }
}
