import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app/constants/app_colors.dart';

class MobileShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onExitRole;
  final List<BottomNavigationBarItem> items;
  final String title;

  const MobileShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onExitRole,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMint,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: child,
              ),
              Positioned(
                top: 8,
                right: 12,
                child: SafeArea(
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      icon: const Icon(LucideIcons.logOut, size: 18, color: AppColors.muted),
                      tooltip: 'Ganti peran',
                      onPressed: onExitRole,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B7A5C), Color(0xFF19B28D)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            heightFactor: 1.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: onTabSelected,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  items: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

