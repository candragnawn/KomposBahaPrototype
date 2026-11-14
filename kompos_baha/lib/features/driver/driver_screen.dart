import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/mobile_shell.dart';
import 'driver_tasks_view.dart';
import 'driver_detail_view.dart';
import 'driver_history_view.dart';
import 'driver_profile_view.dart';

class DriverScreen extends ConsumerStatefulWidget {
  const DriverScreen({super.key});

  @override
  ConsumerState<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends ConsumerState<DriverScreen> {
  int _tabIndex = 0;
  bool _isDetail = false;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_tabIndex == 0 && _isDetail) {
      body = DriverDetailView(onBack: () => setState(() => _isDetail = false));
    } else if (_tabIndex == 0) {
      body = DriverTasksView(onOpenDetail: () => setState(() => _isDetail = true));
    } else if (_tabIndex == 1) {
      body = const DriverHistoryView();
    } else {
      body = const DriverProfileView();
    }

    return MobileShell(
      title: 'Portal Driver',
      selectedIndex: _tabIndex,
      onTabSelected: (idx) => setState(() {
        _tabIndex = idx;
        _isDetail = false;
      }),
      onExitRole: () {
        ref.read(appStateProvider.notifier).setRole(null);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(LucideIcons.truck), label: 'Tugas'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profil'),
      ],
      child: SafeArea(child: body),
    );
  }
}

