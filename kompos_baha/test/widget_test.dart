import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompos_baha/core/models/role.dart';
import 'package:kompos_baha/core/providers/app_state_provider.dart';
import 'package:kompos_baha/main.dart';

void main() {
  testWidgets('KomposBahaApp smoke test renders StartScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: KomposBahaApp(),
      ),
    );

    expect(find.text('Kompos Baha'), findsOneWidget);
    expect(find.text('Layanan Desa Baha'), findsOneWidget);
    expect(find.text('Warga'), findsOneWidget);
  });

  testWidgets('TpsScreen renders responsively on mobile phone size without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    container.read(appStateProvider.notifier).setRole(UserRole.tps);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KomposBahaApp(),
      ),
    );

    expect(find.text('Kompos Baha'), findsWidgets);
    expect(find.text('Kompos Masuk'), findsOneWidget);
  });
}
