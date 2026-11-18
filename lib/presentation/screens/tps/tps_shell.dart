import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_bottom_nav.dart';
import '../../widgets/common/kb_widgets.dart';
import '../admin/settings_screens.dart';
import '../common/profile_screen.dart';
import '../shell/role_shell.dart';
import 'tps_assign_screen.dart';
import 'tps_home_screen.dart';
import 'tps_recap_screen.dart';

class TpsShell extends StatelessWidget {
  const TpsShell({super.key});

  @override
  Widget build(BuildContext context) {
    final counts = context.select<AppProvider, (int, int)>((p) {
      int waiting = 0, toVerify = 0;
      for (final o in p.orders) {
        if (o.status == OrderStatus.menunggu) waiting++;
        if (o.status == OrderStatus.diantar) toVerify++;
      }
      return (waiting, toVerify);
    });
    return RoleShell(
      items: [
        KbNavItem(activeIcon: Icons.scale_rounded, inactiveIcon: Icons.scale_outlined, label: 'Timbang', badge: counts.$2),
        KbNavItem(
          activeIcon: Icons.assignment_ind_rounded,
          inactiveIcon: Icons.assignment_ind_outlined,
          label: 'Penugasan',
          badge: counts.$1,
        ),
        const KbNavItem(activeIcon: Icons.bar_chart_rounded, inactiveIcon: Icons.bar_chart_outlined, label: 'Rekap'),
        const KbNavItem(activeIcon: Icons.person_rounded, inactiveIcon: Icons.person_outline_rounded, label: 'Profil'),
      ],
      pages: const [TpsHomeScreen(), TpsAssignScreen(), TpsRecapScreen(), _TpsProfile()],
    );
  }
}

class _TpsProfile extends StatelessWidget {
  const _TpsProfile();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final m = app.monthStats(DateTime.now());
    return ProfileScreen(
      stats: [
        ProfileStat('${Fmt.kg(m.verifiedKg)} kg', 'Diterima bulan ini'),
        ProfileStat('${m.verifiedCount}', 'Setoran'),
        ProfileStat('${Fmt.kg(app.settings.dailyQuotaKg)} kg', 'Kuota/hari'),
      ],
      extraTitle: 'Operasional TPS 3R',
      extraMenus: [
        KbMenuTile(
          icon: Icons.tune_rounded,
          title: 'Kuota & jadwal layanan',
          subtitle: 'Kuota harian, jam, hari layanan',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuotaSettingsScreen())),
        ),
        KbMenuTile(
          icon: Icons.rule_rounded,
          title: 'Tarif poin aktif',
          subtitle: '${app.settings.pointsPerKg} poin/kg · Cukup ${app.settings.cukupPercent}%',
          color: AppColors.goldDark,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PointRateScreen(readOnly: true))),
        ),
      ],
    );
  }
}
