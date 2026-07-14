import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Vista previa de la pantalla de asistencia (segunda página del onboarding).
///
/// Los datos son de ejemplo: es una ilustración, no consume el repositorio.
class OnboardingAsistencia extends StatelessWidget {
  const OnboardingAsistencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo("Today's summary"),
            const SizedBox(height: 12),
            _panel(
              child: Row(
                children: [
                  Expanded(
                    child: _marca(
                      icono: Icons.login,
                      etiqueta: 'Clock in',
                      hora: '08:02',
                      detalle: 'Entry time',
                    ),
                  ),
                  Container(width: 1, height: 44, color: AppColors.borde),
                  Expanded(
                    child: _marca(
                      icono: Icons.logout,
                      etiqueta: 'Clock out',
                      hora: '17:31',
                      detalle: 'Exit time',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _panel(
              child: Row(
                children: [
                  Expanded(child: _puntualidad()),
                  Container(width: 1, height: 76, color: AppColors.borde),
                  Expanded(child: _tardanzas()),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _panel(child: _resumenSemanal()),
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.texto,
      ),
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.negroSplash,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borde),
      ),
      child: child,
    );
  }

  Widget _marca({
    required IconData icono,
    required String etiqueta,
    required String hora,
    required String detalle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              etiqueta,
              style: const TextStyle(fontSize: 12, color: AppColors.textoS),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          hora,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
        Text(
          detalle,
          style: const TextStyle(fontSize: 10, color: AppColors.textoS),
        ),
      ],
    );
  }

  Widget _puntualidad() {
    return Column(
      children: [
        const Text(
          'Punctuality this month',
          style: TextStyle(fontSize: 11, color: AppColors.textoS),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 58,
          height: 58,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 58,
                height: 58,
                child: CircularProgressIndicator(
                  value: 0.92,
                  strokeWidth: 5,
                  backgroundColor: AppColors.borde,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const Text(
                '92%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Excellent',
          style: TextStyle(fontSize: 10, color: AppColors.textoS),
        ),
      ],
    );
  }

  Widget _tardanzas() {
    return const Column(
      children: [
        Text(
          'Late arrivals',
          style: TextStyle(fontSize: 11, color: AppColors.textoS),
        ),
        SizedBox(height: 14),
        Text(
          '2',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'This month',
          style: TextStyle(fontSize: 10, color: AppColors.textoS),
        ),
      ],
    );
  }

  Widget _resumenSemanal() {
    const dias = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
   
    const estados = [
      Icons.check_circle_outline,
      Icons.check_circle_outline,
      Icons.check_circle_outline,
      Icons.check_circle_outline,
      Icons.check_circle_outline,
      Icons.check_circle_outline,
      Icons.circle_outlined,
    ];
    const colores = [
      AppColors.verde,
      AppColors.verde,
      AppColors.verde,
      AppColors.verde,
      AppColors.verde,
      AppColors.ambar,
      AppColors.borde,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly summary',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.texto,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dias.length, (i) {
            return Column(
              children: [
                Text(
                  dias[i],
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textoS,
                  ),
                ),
                const SizedBox(height: 6),
                Icon(estados[i], size: 18, color: colores[i]),
              ],
            );
          }),
        ),
      ],
    );
  }
}
