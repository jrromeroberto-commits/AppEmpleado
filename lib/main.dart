import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_PE', null);
  runApp(const ProviderScope(child: MiApp()));
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Asistencia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const PantallaProvisional(),
    );
  }
}

/// Pantalla temporal para verificar que el tema se aplica.
/// Se elimina en la Fase 4, cuando exista la navegación real.
class PantallaProvisional extends StatelessWidget {
  const PantallaProvisional({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'App Asistencia',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fase 0 completada',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Botón de prueba'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
