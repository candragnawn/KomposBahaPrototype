import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/common/kb_bottom_nav.dart';

/// Memberi akses ke perpindahan tab dari halaman mana pun di dalam shell.
class ShellScope extends InheritedWidget {
  final ValueChanged<int> goTo;
  final int index;

  const ShellScope({super.key, required this.goTo, required this.index, required super.child});

  static ShellScope? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ShellScope>();

  @override
  bool updateShouldNotify(ShellScope oldWidget) => oldWidget.index != index;
}

/// Kerangka utama tiap peran: halaman per tab + bottom nav ala CulTask.
class RoleShell extends StatefulWidget {
  final List<KbNavItem> items;
  final List<Widget> pages;

  const RoleShell({super.key, required this.items, required this.pages});

  @override
  State<RoleShell> createState() => _RoleShellState();
}

class _RoleShellState extends State<RoleShell> {
  int _index = 0;

  void _goTo(int i) {
    if (i < 0 || i >= widget.pages.length) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Tombol kembali di tab lain → kembali ke Beranda dulu.
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _index != 0) _goTo(0);
      },
      child: ShellScope(
        goTo: _goTo,
        index: _index,
        child: Scaffold(
          backgroundColor: AppColors.surface,
          body: IndexedStack(index: _index, children: widget.pages),
          bottomNavigationBar: KbBottomNav(items: widget.items, currentIndex: _index, onTap: _goTo),
        ),
      ),
    );
  }
}
