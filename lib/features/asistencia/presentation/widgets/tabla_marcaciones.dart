import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/dia_asistencia.dart';
import 'estado_dia_visual.dart';

/// Tabla "All punches": día, entrada y salida de cada jornada.
class TablaMarcaciones extends StatelessWidget {
  const TablaMarcaciones({super.key, required this.dias});

  final List<DiaAsistencia> dias;

  @override
  Widget build(BuildContext context) {
    // Se muestran los días con registro, del más reciente al más antiguo.
    final conRegistro = dias
        .where((d) => d.estado != EstadoDia.pendiente)
        .toList()
        .reversed
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All punches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 16),
            _cabecera(),
            const SizedBox(height: 8),
            for (final (i, dia) in conRegistro.indexed) ...[
              if (i > 0) const Divider(height: 1, color: AppColors.borde),
              _fila(dia),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cabecera() {
    const estilo = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textoS,
    );

    return const Row(
      children: [
        Expanded(flex: 4, child: Text('Day', style: estilo)),
        Expanded(flex: 3, child: Text('In', style: estilo)),
        Expanded(flex: 3, child: Text('Out', style: estilo)),
      ],
    );
  }

  Widget _fila(DiaAsistencia dia) {
    final esFalta = dia.estado == EstadoDia.falta;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Icon(dia.estado.icono, size: 16, color: dia.estado.color),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    dia.esHoy
                        ? 'Today'
                        : DateFormat('EEE dd MMM', 'en_US').format(dia.fecha),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: dia.esHoy
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: AppColors.texto,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: _hora(dia.entrada, esFalta)),
          Expanded(flex: 3, child: _hora(dia.salida, esFalta)),
        ],
      ),
    );
  }

  /// Una salida sin marcar aún está "Pending"; en una falta simplemente no hubo.
  Widget _hora(DateTime? valor, bool esFalta) {
    if (valor != null) {
      return Text(
        DateFormat('hh:mm a', 'en_US').format(valor),
        style: const TextStyle(fontSize: 14, color: AppColors.texto),
      );
    }

    return Text(
      esFalta ? '—' : 'Pending',
      style: TextStyle(
        fontSize: 14,
        color: esFalta ? AppColors.textoS : AppColors.ambar,
      ),
    );
  }
}
