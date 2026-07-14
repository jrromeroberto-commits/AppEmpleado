import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Placeholder para las secciones que aún no se han construido.
class PaginaPendiente extends StatelessWidget {
  const PaginaPendiente({
    super.key,
    required this.titulo,
    required this.icono,
    required this.fase,
  });

  final String titulo;
  final IconData icono;

  /// Fase del plan en la que se construirá (ver GUIA_DESARROLLO.md).
  final String fase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: 56, color: AppColors.primary),
              const SizedBox(height: 20),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texto,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming in phase $fase',
                style: const TextStyle(fontSize: 14, color: AppColors.textoS),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
