import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}
