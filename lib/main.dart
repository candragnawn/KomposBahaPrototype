import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/app_provider.dart';
import 'presentation/screens/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ChangeNotifierProvider<AppProvider>(
      // Ganti `AppProvider()` dengan `AppProvider(database: ServerDatabaseService())`
      // jika nanti memakai server bersama.
      create: (_) => AppProvider()..init(),
      child: const KomposBahaApp(),
    ),
  );
}

class KomposBahaApp extends StatelessWidget {
  const KomposBahaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appScale = context.select<AppProvider, double>((p) => p.textScale);

    return MaterialApp(
      title: 'Kompos Baha',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Ukuran huruf: gabungan pengaturan HP & pengaturan di aplikasi,
      // dibatasi agar tata letak tetap rapi.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final system = mq.textScaler.scale(16) / 16;
        final scale = (system * appScale).clamp(1.0, 1.45);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AppRoot(),
    );
  }
}
