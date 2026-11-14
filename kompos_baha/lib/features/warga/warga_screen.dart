import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/mobile_shell.dart';
import 'warga_home_view.dart';
import 'warga_offer_view.dart';
import 'warga_rewards_view.dart';
import 'warga_history_view.dart';
import 'warga_profile_view.dart';

class WargaScreen extends ConsumerStatefulWidget {
  const WargaScreen({super.key});

  @override
  ConsumerState<WargaScreen> createState() => _WargaScreenState();
}

class _WargaScreenState extends ConsumerState<WargaScreen> {
  int _tabIndex = 0;
  bool _isOfferDetail = false;

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_tabIndex) {
      case 0:
        body = WargaHomeView(
          onNavigateTab: (index) => setState(() {
            _tabIndex = index;
            _isOfferDetail = false;
          }),
          onOpenDetail: () => setState(() {
            _tabIndex = 2; // Setor tab
            _isOfferDetail = true;
          }),
        );
        break;
      case 1:
        body = const WargaRewardsView();
        break;
      case 2:
        body = WargaOfferView(
          isDetail: _isOfferDetail,
          onBack: () => setState(() {
            if (_isOfferDetail) {
              _isOfferDetail = false;
            } else {
              _tabIndex = 0;
            }
          }),
          onOpenDetail: () => setState(() => _isOfferDetail = true),
        );
        break;
      case 3:
        body = WargaHistoryView(
          onSelectOrder: () => setState(() {
            _tabIndex = 2;
            _isOfferDetail = true;
          }),
        );
        break;
      case 4:
      default:
        body = const WargaProfileView();
        break;
    }

    return MobileShell(
      title: 'Portal Warga',
      selectedIndex: _tabIndex,
      onTabSelected: (idx) => setState(() {
        _tabIndex = idx;
        _isOfferDetail = false;
      }),
      onExitRole: () {
        ref.read(appStateProvider.notifier).setRole(null);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.gift), label: 'Hadiah'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.plusCircle), label: 'Setor'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profil'),
      ],
      child: SafeArea(child: body),
    );
  }
}

