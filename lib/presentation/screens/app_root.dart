import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/user_model.dart';
import '../providers/app_provider.dart';
import 'admin/admin_shell.dart';
import 'auth/login_screen.dart';
import 'driver/driver_shell.dart';
import 'onboarding/onboarding_screen.dart';
import 'splash/splash_screen.dart';
import 'tps/tps_shell.dart';
import 'warga/warga_shell.dart';

/// Menentukan layar utama berdasarkan status aplikasi & peran pengguna.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    final Widget page;
    final String key;
    if (!app.isReady) {
      page = const SplashScreen();
      key = 'splash';
    } else if (!app.onboardingSeen) {
      page = const OnboardingScreen();
      key = 'onboarding';
    } else if (app.currentUser == null) {
      page = const LoginScreen();
      key = 'login';
    } else {
      final u = app.currentUser!;
      key = 'shell-${u.id}-${u.role.name}';
      page = switch (u.role) {
        UserRole.warga => const WargaShell(),
        UserRole.driver => const DriverShell(),
        UserRole.tps => const TpsShell(),
        UserRole.admin => const AdminShell(),
      };
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: KeyedSubtree(key: ValueKey(key), child: page),
    );
  }
}

/// Kembali ke halaman paling awal (dipakai setelah login/daftar/keluar).
void popToRoot(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
