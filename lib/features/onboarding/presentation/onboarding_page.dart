import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'widgets/onboarding_asistencia.dart';
import 'widgets/onboarding_bienvenida.dart';
import 'widgets/onboarding_indicador.dart';
import 'widgets/onboarding_rrhh.dart';

class _Pagina {
  const _Pagina({
    required this.icono,
    required this.titulo,
    required this.contenido,
    this.descripcion,
  });

  final IconData icono;
  final String titulo;
  final String? descripcion;
  final Widget contenido;
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.siguiente});

  final Widget siguiente;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _actual = 0;

  static const _paginas = <_Pagina>[
    _Pagina(
      icono: Icons.person_outline,
      titulo: 'Welcome to Runway 7 Club',
      descripcion:
          'The app that helps you manage your attendance, punctuality and '
          'internal communication simply and securely.',
      contenido: OnboardingBienvenida(),
    ),
    _Pagina(
      icono: Icons.event_available_outlined,
      titulo: 'Track your attendance',
      contenido: OnboardingAsistencia(),
    ),
    _Pagina(
      icono: Icons.groups_outlined,
      titulo: 'Connect with HR',
      descripcion:
          'Chat with Human Resources / Administration, justify your absences '
          'and send suggestions to improve our workplace.',
      contenido: OnboardingRrhh(),
    ),
  ];

  bool get _esUltima => _actual == _paginas.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _terminar() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => widget.siguiente,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _paginas.length,
                onPageChanged: (i) => setState(() => _actual = i),
                itemBuilder: (context, i) => _vistaPagina(_paginas[i]),
              ),
            ),
            const SizedBox(height: 16),
            OnboardingIndicador(total: _paginas.length, actual: _actual),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: _accion(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accion() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: _esUltima
          ? ElevatedButton(
              onPressed: _terminar,
              // Texto negro sobre el rojo, en vez del blanco del tema.
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.negroSplash,
              ),
              child: const Text(
                'Get started',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          : Center(
              child: TextButton(
                onPressed: _terminar,
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 13, color: AppColors.textoS),
                ),
              ),
            ),
    );
  }

  Widget _vistaPagina(_Pagina pagina) {
    final descripcion = pagina.descripcion;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          // Centra el contenido verticalmente cuando sobra espacio (la página 2
          // no tiene descripción y quedaba pegada arriba). Si el contenido no
          // cabe, el scroll sigue funcionando.
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
            child: Center(child: _contenidoPagina(pagina, descripcion)),
          ),
        );
      },
    );
  }

  Widget _contenidoPagina(_Pagina pagina, String? descripcion) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(pagina.icono, size: 76, color: AppColors.primary),
        const SizedBox(height: 20),
        Text(
          pagina.titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
        if (descripcion != null) ...[
          const SizedBox(height: 10),
          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textoS,
            ),
          ),
        ],
        const SizedBox(height: 24),
        pagina.contenido,
      ],
    );
  }
}
