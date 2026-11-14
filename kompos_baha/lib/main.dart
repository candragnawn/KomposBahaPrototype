import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme/app_theme.dart';
import 'core/models/role.dart';
import 'core/providers/app_state_provider.dart';
import 'features/auth/start_screen.dart';
import 'features/auth/warga_login_screen.dart';
import 'features/warga/warga_screen.dart';
import 'features/driver/driver_screen.dart';
import 'features/tps/tps_screen.dart';
import 'features/admin/admin_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: KomposBahaApp(),
    ),
  );
}

class KomposBahaApp extends ConsumerWidget {
  const KomposBahaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);

    Widget home;
    if (state.role == null) {
      home = const StartScreen();
    } else if (state.role == UserRole.warga && !state.wargaLoggedIn) {
      home = const WargaLoginScreen();
    } else if (state.role == UserRole.warga) {
      home = const WargaScreen();
    } else if (state.role == UserRole.driver) {
      home = const DriverScreen();
    } else if (state.role == UserRole.tps) {
      home = const TpsScreen();
    } else {
      home = const AdminScreen();
    }

    return MaterialApp(
      title: 'Kompos Baha',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: home,
    );
  }
}
