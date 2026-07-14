import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../sugerencias/domain/sugerencia.dart';

/// Tarjeta "Recent suggestions": las últimas sugerencias enviadas a RR. HH.
class TarjetaSugerencias extends StatelessWidget {
  const TarjetaSugerencias({
    super.key,
    required this.sugerencias,
    this.onVerTodas,
  });

  final List<Sugerencia> sugerencias;
  final VoidCallback? onVerTodas;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Recent suggestions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.texto,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onVerTodas,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Go to HR',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (sugerencias.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "You haven't sent any suggestions yet.",
                  style: TextStyle(fontSize: 14, color: AppColors.textoS),
                ),
              )
            else
              for (final (i, sugerencia) in sugerencias.indexed) ...[
                if (i > 0) const Divider(height: 24, color: AppColors.borde),
                _fila(sugerencia),
              ],
          ],
        ),
      ),
    );
  }

  Widget _fila(Sugerencia sugerencia) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sugerencia.asunto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.texto,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sugerencia.categoria,
                style: const TextStyle(fontSize: 12, color: AppColors.textoS),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _chipEstado(sugerencia.estado),
      ],
    );
  }

  Widget _chipEstado(EstadoSugerencia estado) {
    final color = switch (estado) {
      EstadoSugerencia.enRevision => AppColors.ambar,
      EstadoSugerencia.aprobada => AppColors.verde,
      EstadoSugerencia.desaprobada => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        estado.etiqueta,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
