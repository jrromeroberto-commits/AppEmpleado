import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../data/mock_asistencia.dart';
import '../domain/dia_asistencia.dart';
import 'asistencia_page.dart';
import 'widgets/estado_dia_visual.dart';

/// "Full history": todas las marcas del empleado, mes a mes.
///
/// Los días tarde o de falta son pulsables: llevan al formulario de
/// justificación con esa fecha ya puesta.
class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  late DateTime _mes = DateTime(
    MockAsistencia.hoy.year,
    MockAsistencia.hoy.month,
  );

  void _cambiarMes(int meses) {
    setState(() => _mes = DateTime(_mes.year, _mes.month + meses));
  }

  /// Días del mes seleccionado, del más reciente al más antiguo.
  List<DiaAsistencia> get _delMes {
    final dias = MockAsistencia.historial
        .where((d) => d.fecha.year == _mes.year && d.fecha.month == _mes.month)
        .toList();
    dias.sort((a, b) => b.fecha.compareTo(a.fecha));
    return dias;
  }

  @override
  Widget build(BuildContext context) {
    final dias = _delMes;

    return Scaffold(
      appBar: AppBar(title: const Text('Full history')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _selectorMes(),
            const SizedBox(height: 12),
            if (dias.isEmpty) _vacio() else _resumen(dias),
            if (dias.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      for (final (i, dia) in dias.indexed) ...[
                        if (i > 0)
                          const Divider(height: 1, color: AppColors.borde),
                        _fila(dia),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _selectorMes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _cambiarMes(-1),
          icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          tooltip: 'Previous month',
        ),
        Text(
          DateFormat('MMMM yyyy', 'en_US').format(_mes),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.texto,
          ),
        ),
        IconButton(
          onPressed: () => _cambiarMes(1),
          icon: const Icon(Icons.chevron_right, color: AppColors.primary),
          tooltip: 'Next month',
        ),
      ],
    );
  }

  /// Cuántos días hubo de cada estado en el mes.
  Widget _resumen(List<DiaAsistencia> dias) {
    int contar(EstadoDia estado) =>
        dias.where((d) => d.estado == estado).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (final (i, estado) in const [
                EstadoDia.aTiempo,
                EstadoDia.tarde,
                EstadoDia.falta,
              ].indexed) ...[
                if (i > 0)
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColors.borde,
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(estado.icono, size: 22, color: estado.color),
                      const SizedBox(height: 8),
                      Text(
                        '${contar(estado)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.texto,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        estado.etiqueta,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textoS,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _vacio() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'No punches this month',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your punches for '
              '${DateFormat('MMMM', 'en_US').format(_mes)} will show up here.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textoS),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(DiaAsistencia dia) {
    final justificable =
        dia.estado == EstadoDia.tarde || dia.estado == EstadoDia.falta;

    return InkWell(
      onTap: justificable
          ? () => AsistenciaPage.justificarDia(context, dia)
          : null,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(dia.estado.icono, size: 20, color: dia.estado.color),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEE dd', 'en_US').format(dia.fecha),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.texto,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dia.estado.etiqueta,
                    style: TextStyle(fontSize: 11, color: dia.estado.color),
                  ),
                ],
              ),
            ),
            Expanded(flex: 2, child: _hora('In', dia.entrada)),
            Expanded(flex: 2, child: _hora('Out', dia.salida)),
            SizedBox(
              width: 18,
              child: justificable
                  ? const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.primary,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _hora(String etiqueta, DateTime? valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(fontSize: 10, color: AppColors.textoS),
        ),
        const SizedBox(height: 2),
        Text(
          valor == null ? '—' : DateFormat('HH:mm').format(valor),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valor == null ? AppColors.textoS : AppColors.texto,
          ),
        ),
      ],
    );
  }
}
