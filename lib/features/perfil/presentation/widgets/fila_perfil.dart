import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Fila con acción: navega a otra pantalla o muestra un control (switch).
class FilaAccion extends StatelessWidget {
  const FilaAccion({
    super.key,
    required this.icono,
    required this.titulo,
    this.subtitulo,
    this.onTap,
    this.trailing,
    this.esUltima = false,
    this.destructiva = false,
  });

  final IconData icono;
  final String titulo;
  final String? subtitulo;
  final VoidCallback? onTap;

  /// Control a la derecha (p. ej. un Switch). Si es `null` se muestra un chevron.
  final Widget? trailing;

  final bool esUltima;

  /// Pinta la fila en rojo: para acciones como cerrar sesión.
  final bool destructiva;

  @override
  Widget build(BuildContext context) {
    final color = destructiva ? AppColors.primary : AppColors.texto;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(
                  icono,
                  size: 20,
                  color: destructiva ? AppColors.primary : AppColors.textoS,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(fontSize: 15, color: color),
                      ),
                      if (subtitulo != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitulo!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textoS,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                trailing ??
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.textoS,
                    ),
              ],
            ),
          ),
        ),
        if (!esUltima) const Divider(height: 1, color: AppColors.borde),
      ],
    );
  }
}
