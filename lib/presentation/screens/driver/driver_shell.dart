import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_bottom_nav.dart';
import '../common/profile_screen.dart';
import '../shell/role_shell.dart';
import 'driver_history_screen.dart';
import 'driver_tasks_screen.dart';

class DriverShell extends StatelessWidget {
  const DriverShell({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingCount = context.select<AppProvider, int>((p) {
      final u = p.currentUser;
      if (u == null) return 0;
      return p.ordersOfDriver(u.id).where((o) => o.status == OrderStatus.ditugaskan || o.status == OrderStatus.dijemput).length;
    });
    return RoleShell(
      items: [
        KbNavItem(
          activeIcon: Icons.local_shipping_rounded,
          inactiveIcon: Icons.local_shipping_outlined,
          label: 'Tugas',
          badge: pendingCount,
        ),
        const KbNavItem(activeIcon: Icons.history_rounded, inactiveIcon: Icons.history_outlined, label: 'Riwayat'),
        const KbNavItem(activeIcon: Icons.person_rounded, inactiveIcon: Icons.person_outline_rounded, label: 'Profil'),
      ],
      pages: const [DriverTasksScreen(), DriverHistoryScreen(), _DriverProfile()],
    );
  }
}

class _DriverProfile extends StatelessWidget {
  const _DriverProfile();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final mine = app.ordersOfDriver(u.id);
    final doneMonth = mine.where((o) {
      final t = o.timeOf(OrderStatus.diantar);
      return t != null && t.year == now.year && t.month == now.month;
    }).toList();
    double kg = 0;
    for (final o in doneMonth) {
      kg += o.officialKg ?? o.estimatedKg;
    }
    return ProfileScreen(stats: [
      ProfileStat('${doneMonth.length}', 'Tugas bulan ini'),
      ProfileStat('${Fmt.kg(kg)} kg', 'Kompos diantar'),
      ProfileStat(u.vehicle.isEmpty ? '-' : u.vehicle, 'Kendaraan'),
    ]);
  }
}
