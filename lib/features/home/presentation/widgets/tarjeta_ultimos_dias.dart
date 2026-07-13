import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../asistencia/domain/dia_asistencia.dart';

/// Tarjeta "Recent days": tira de tarjetas con la entrada y salida de cada día.
class TarjetaUltimosDias extends StatelessWidget {
  const TarjetaUltimosDias({super.key, required this.dias});

  final List<DiaAsistencia> dias;

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
                  'Recent days',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.texto,
                  ),
                ),
                const Spacer(),
                _leyenda(AppColors.verde, 'In'),
                const SizedBox(width: 12),
                _leyenda(AppColors.primary, 'Out'),
              ],
            ),
            const SizedBox(height: 16),
            // Scroll horizontal: con muchos días no cabrían todos a la vez.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final (i, dia) in dias.indexed) ...[
                    if (i > 0) const SizedBox(width: 10),
                    _tarjetaDia(dia),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leyenda(Color color, String texto) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          texto,
          style: const TextStyle(fontSize: 12, color: AppColors.textoS),
        ),
      ],
    );
  }

  Widget _tarjetaDia(DiaAsistencia dia) {
    return Container(
      width: 86,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.negroSplash,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          // El día de hoy se resalta con el borde de acento.
          color: dia.esHoy ? AppColors.primary : AppColors.borde,
          width: dia.esHoy ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEE', 'en_US').format(dia.fecha),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('dd MMM', 'en_US').format(dia.fecha),
            style: const TextStyle(fontSize: 12, color: AppColors.textoS),
          ),
          const SizedBox(height: 10),
          _hora(dia.entrada, AppColors.verde),
          const SizedBox(height: 4),
          _hora(dia.salida, AppColors.primary),
        ],
      ),
    );
  }

  Widget _hora(DateTime? valor, Color color) {
    return Text(
      valor == null ? '--:--' : DateFormat('HH:mm').format(valor),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: valor == null ? AppColors.textoS : color,
      ),
    );
  }
}
