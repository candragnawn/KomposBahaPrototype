import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/desktop_shell.dart';
import 'tps_incoming_view.dart';
import 'tps_assign_view.dart';
import 'tps_suppliers_and_quota_views.dart';

class TpsScreen extends ConsumerStatefulWidget {
  const TpsScreen({super.key});

  @override
  ConsumerState<TpsScreen> createState() => _TpsScreenState();
}

class _TpsScreenState extends ConsumerState<TpsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = const TpsIncomingView();
        break;
      case 1:
        content = const TpsAssignView();
        break;
      case 2:
        content = const TpsSuppliersView();
        break;
      case 3:
      default:
        content = const TpsQuotaView();
        break;
    }

    return DesktopShell(
      roleTitle: 'Kompos Baha',
      roleSubtitle: 'TPS 3R Desa Baha',
      userName: 'I Made Sutama',
      userRoleTitle: 'Petugas TPS 3R',
      userInitials: 'MS',
      selectedIndex: _selectedIndex,
      onItemSelected: (idx) => setState(() => _selectedIndex = idx),
      onExit: () {
        ref.read(appStateProvider.notifier).setRole(null);
      },
      items: const [
        DesktopShellItem(id: 'incoming', label: 'Kompos masuk', icon: LucideIcons.box),
        DesktopShellItem(id: 'assign', label: 'Penugasan driver', icon: LucideIcons.truck),
        DesktopShellItem(id: 'suppliers', label: 'Rekap pemasok', icon: LucideIcons.users),
        DesktopShellItem(id: 'quota', label: 'Pengaturan kuota', icon: LucideIcons.settings),
      ],
      content: content,
    );
  }
}

