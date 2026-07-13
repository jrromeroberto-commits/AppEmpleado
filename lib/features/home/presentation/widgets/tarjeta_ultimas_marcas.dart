import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../asistencia/data/mock_asistencia.dart';
import '../../../asistencia/domain/marca.dart';

/// Tarjeta "Latest punches": las últimas marcas de entrada y salida.
class TarjetaUltimasMarcas extends StatelessWidget {
  const TarjetaUltimasMarcas({super.key, required this.marcas});

  final List<Marca> marcas;

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
                  'Latest punches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.texto,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'View all',
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
            if (marcas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No punches recorded yet.',
                  style: TextStyle(fontSize: 14, color: AppColors.textoS),
                ),
              )
            else
              for (final (i, marca) in marcas.indexed) ...[
                if (i > 0) const SizedBox(height: 14),
                _fila(marca),
              ],
          ],
        ),
      ),
    );
  }

  Widget _fila(Marca marca) {
    final esEntrada = marca.tipo == TipoMarca.entrada;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            esEntrada ? Icons.login : Icons.logout,
            size: 22,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEE dd MMM', 'en_US').format(marca.fechaHora),
                style: const TextStyle(fontSize: 15, color: AppColors.texto),
              ),
              const SizedBox(height: 2),
              Text(
                marca.tipo.etiqueta,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Container(width: 1, height: 40, color: AppColors.borde),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('HH:mm').format(marca.fechaHora),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${DateFormat('hh:mm a', 'en_US').format(marca.fechaHora)} '
              '(${MockAsistencia.zonaHoraria})',
              style: const TextStyle(fontSize: 12, color: AppColors.textoS),
            ),
          ],
        ),
      ],
    );
  }
}
