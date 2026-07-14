import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Tarjeta con título usada por las tres secciones del perfil
/// (información, seguridad y about).
class SeccionPerfil extends StatelessWidget {
  const SeccionPerfil({
    super.key,
    required this.titulo,
    required this.icono,
    required this.children,
  });

  final String titulo;
  final IconData icono;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(icono, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textoFondo,
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
