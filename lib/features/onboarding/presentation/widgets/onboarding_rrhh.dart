import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Vista previa de chats y solicitudes (tercera página del onboarding).
///
/// Los datos son de ejemplo: es una ilustración, no consume el repositorio.
class OnboardingRrhh extends StatelessWidget {
  const OnboardingRrhh({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titulo('Chat'),
                const SizedBox(height: 12),
                _chat(
                  icono: Icons.person_outline,
                  nombre: 'Human Resources',
                  mensaje: 'Hi, how can we help you?',
                  hora: '10:30',
                  noLeidos: 2,
                ),
                const SizedBox(height: 10),
                _chat(
                  icono: Icons.shield_outlined,
                  nombre: 'Administration',
                  mensaje: 'Reminder: Team meeting today.',
                  hora: '09:15',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titulo('My requests'),
                const SizedBox(height: 12),
                _solicitud(
                  icono: Icons.description_outlined,
                  titulo: 'Absence justification',
                  detalle: 'May 14, 2025',
                  estado: 'Pending',
                  colorEstado: AppColors.ambar,
                ),
                const Divider(height: 24),
                _solicitud(
                  icono: Icons.lightbulb_outline,
                  titulo: 'Suggestion',
                  detalle: 'Cafeteria improvement',
                  estado: 'Approved',
                  colorEstado: AppColors.verde,
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _chat({
    required IconData icono,
    required String nombre,
    required String mensaje,
    required String hora,
    int noLeidos = 0,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
          child: Icon(icono, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.texto,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                mensaje,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: AppColors.textoS),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              hora,
              style: const TextStyle(fontSize: 10, color: AppColors.textoS),
            ),
            const SizedBox(height: 4),
            if (noLeidos > 0)
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Text(
                  '$noLeidos',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texto,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _solicitud({
    required IconData icono,
    required String titulo,
    required String detalle,
    required String estado,
    required Color colorEstado,
  }) {
    return Row(
      children: [
        Icon(icono, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.texto,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detalle,
                style: const TextStyle(fontSize: 11, color: AppColors.textoS),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colorEstado.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorEstado.withValues(alpha: 0.5)),
          ),
          child: Text(
            estado,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorEstado,
            ),
          ),
        ),
        const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.textoS,
        ),
      ],
    );
  }
}
