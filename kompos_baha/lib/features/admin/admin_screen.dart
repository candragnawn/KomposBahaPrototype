import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/desktop_shell.dart';
import 'admin_summary_view.dart';
import 'admin_transactions_view.dart';
import 'admin_users_view.dart';
import 'admin_points_view.dart';
import 'admin_complaints_and_reports_views.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = AdminSummaryView(
          onNavigateToTransactions: () => setState(() => _selectedIndex = 1),
        );
        break;
      case 1:
        content = const AdminTransactionsView();
        break;
      case 2:
        content = const AdminUsersView();
        break;
      case 3:
        content = const AdminPointsView();
        break;
      case 4:
        content = const AdminComplaintsView();
        break;
      case 5:
      default:
        content = const AdminReportsView();
        break;
    }

    return DesktopShell(
      roleTitle: 'Kompos Baha',
      roleSubtitle: 'Admin Desa Baha',
      userName: 'Ni Luh Sri Wahyuni',
      userRoleTitle: 'Administrator',
      userInitials: 'SW',
      selectedIndex: _selectedIndex,
      onItemSelected: (idx) => setState(() => _selectedIndex = idx),
      onExit: () {
        ref.read(appStateProvider.notifier).setRole(null);
      },
      items: const [
        DesktopShellItem(id: 'summary', label: 'Ringkasan', icon: LucideIcons.home),
        DesktopShellItem(id: 'transactions', label: 'Transaksi', icon: LucideIcons.history),
        DesktopShellItem(id: 'users', label: 'Pengguna', icon: LucideIcons.users),
        DesktopShellItem(id: 'points', label: 'Poin dan hadiah', icon: LucideIcons.gift),
        DesktopShellItem(id: 'complaints', label: 'Pengaduan', icon: LucideIcons.messageSquare),
        DesktopShellItem(id: 'reports', label: 'Laporan', icon: LucideIcons.fileText),
      ],
      content: content,
    );
  }
}

