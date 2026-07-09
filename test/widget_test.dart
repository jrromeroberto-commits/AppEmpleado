import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_asistencia/main.dart';

void main() {
  testWidgets('La app arranca y muestra la pantalla provisional', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MiApp()));

    expect(find.text('App Asistencia'), findsOneWidget);
    expect(find.text('Fase 0 completada'), findsOneWidget);
  });
}
