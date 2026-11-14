import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app/constants/app_colors.dart';

class DesktopShellItem {
  final String id;
  final String label;
  final IconData icon;

  const DesktopShellItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class DesktopShell extends StatelessWidget {
  final String roleTitle;
  final String roleSubtitle;
  final String userName;
  final String userRoleTitle;
  final String userInitials;
  final List<DesktopShellItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onExit;
  final Widget content;

  const DesktopShell({
    super.key,
    required this.roleTitle,
    required this.roleSubtitle,
    required this.userName,
    required this.userRoleTitle,
    required this.userInitials,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onExit,
    required this.content,
  });

  Widget _buildSidebarContent(BuildContext context, {bool isDrawer = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'KB',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.ink,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      roleSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
        // Navigation items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = index == selectedIndex;
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surfaceMint : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    item.icon,
                    size: 18,
                    color: isSelected ? AppColors.primaryGreen : AppColors.muted,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.primaryGreen : AppColors.ink,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    onItemSelected(index);
                    if (isDrawer) {
                      Navigator.pop(context);
                    }
                  },
                ),
              );
            },
          ),
        ),
        // Exit role button
        const Divider(height: 1, color: AppColors.border),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              side: const BorderSide(color: AppColors.border),
              foregroundColor: AppColors.muted,
            ),
            icon: const Icon(LucideIcons.logOut, size: 16),
            label: const Text('Ganti peran'),
            onPressed: onExit,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    if (isMobile) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(LucideIcons.menu, color: AppColors.ink),
              tooltip: 'Menu',
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'KB',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  roleTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(LucideIcons.logOut, size: 18, color: AppColors.muted),
                tooltip: 'Ganti peran',
                onPressed: onExit,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: _buildSidebarContent(context, isDrawer: true),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      );
    }

    // Wide / Desktop layout
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 260,
            color: Colors.white,
            child: _buildSidebarContent(context, isDrawer: false),
          ),
          const VerticalDivider(width: 1, color: AppColors.border),
          // Main Body
          Expanded(
            child: Column(
              children: [
                // Topbar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.mapPin, size: 16, color: AppColors.muted),
                          SizedBox(width: 6),
                          Text(
                            'Desa Baha, Mengwi',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                userRoleTitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.surfaceMint,
                            child: Text(
                              userInitials,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                // Dynamic Content View
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
