import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/dia_asistencia.dart';
import 'estado_dia_visual.dart';

/// Tarjeta "Last 7 days": el estado de cada día con su leyenda.
class TarjetaUltimosDias extends StatelessWidget {
  const TarjetaUltimosDias({super.key, required this.dias});

  final List<DiaAsistencia> dias;

  @override
  Widget build(BuildContext context) {
    final recientesPrimero = dias.reversed.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last 7 days',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 18),
            // Scroll horizontal: en pantallas estrechas 7 días no caben.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final (i, dia) in recientesPrimero.indexed) ...[
                    if (i > 0) const SizedBox(width: 6),
                    _columnaDia(dia),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, color: AppColors.borde),
            const SizedBox(height: 14),
            _leyenda(),
          ],
        ),
      ),
    );
  }

  Widget _columnaDia(DiaAsistencia dia) {
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Solo el día de hoy lleva fondo, para localizarlo de un vistazo.
        color: dia.esHoy ? AppColors.primary.withValues(alpha: 0.1) : null,
        border: Border.all(
          color: dia.esHoy ? AppColors.primary : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEE', 'en_US').format(dia.fecha),
            style: const TextStyle(fontSize: 13, color: AppColors.textoS),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('dd').format(dia.fecha),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 10),
          Icon(dia.estado.icono, size: 26, color: dia.estado.color),
          const SizedBox(height: 8),
          Text(
            dia.estado.etiqueta,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: dia.estado.color),
          ),
        ],
      ),
    );
  }

  Widget _leyenda() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final estado in EstadoDia.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: estado.color,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                estado.etiqueta,
                style: const TextStyle(fontSize: 12, color: AppColors.textoS),
              ),
            ],
          ),
      ],
    );
  }
}
