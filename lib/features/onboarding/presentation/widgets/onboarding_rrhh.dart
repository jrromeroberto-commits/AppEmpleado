import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Vista previa de la pantalla de HR (tercera página del onboarding): un aviso
/// de Recursos Humanos y los próximos cumpleaños.
///
/// Los datos son de ejemplo: es una ilustración, no consume el repositorio.
class OnboardingRrhh extends StatelessWidget {
  const OnboardingRrhh({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tarjeta(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _chipTipo('Urgent', AppColors.rojo),
                  const Spacer(),
                  const Icon(
                    Icons.push_pin,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '08 Jul',
                    style: TextStyle(fontSize: 11, color: AppColors.textoClaroS),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'New attendance policy',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoClaro,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'The grace period will be five minutes starting August 1st.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: AppColors.textoClaroS,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _tarjeta(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cake_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _titulo('Upcoming birthdays'),
                ],
              ),
              const SizedBox(height: 12),
              _cumple(
                iniciales: 'VT',
                nombre: 'Valeria Torres',
                area: 'Design',
                esHoy: true,
              ),
              const Divider(height: 20, color: AppColors.bordeOscuro),
              _cumple(
                iniciales: 'CM',
                nombre: 'Carlos Medina',
                area: 'QA',
                fecha: '11 Jul',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjeta({required Widget child}) {
    return Card(
      color: AppColors.superficie,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: AppColors.bordeOscuro),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textoClaro,
      ),
    );
  }

  Widget _chipTipo(String texto, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _cumple({
    required String iniciales,
    required String nombre,
    required String area,
    bool esHoy = false,
    String? fecha,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: esHoy ? 1 : 0.15),
          ),
          child: Text(
            iniciales,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: esHoy ? AppColors.negroSplash : AppColors.primary,
            ),
          ),
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
                  color: AppColors.textoClaro,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                area,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textoClaroS,
                ),
              ),
            ],
          ),
        ),
        if (esHoy)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Today 🎉',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.negroSplash,
              ),
            ),
          )
        else
          Text(
            fecha ?? '',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}
