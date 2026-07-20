import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../data/mock_asistencia.dart';
import '../domain/dia_asistencia.dart';
import 'asistencia_page.dart';
import 'widgets/estado_dia_visual.dart';


class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {

  static const _estadosVisibles = [
    EstadoDia.aTiempo,
    EstadoDia.tarde,
    EstadoDia.falta,
  ];

  late DateTime _mes = DateTime(
    MockAsistencia.hoy.year,
    MockAsistencia.hoy.month,
  );

  void _cambiarMes(int meses) {
    setState(() => _mes = DateTime(_mes.year, _mes.month + meses));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _selectorMes(),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _cabeceraSemana(),
                    const SizedBox(height: 12),
                    _grilla(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _leyenda(),
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
            color: AppColors.textoFondo,
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

  Widget _cabeceraSemana() {
    const dias = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      children: [
        for (final dia in dias)
          Expanded(
            child: Text(
              dia,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textoS,
              ),
            ),
          ),
      ],
    );
  }

  Widget _grilla() {
    final primerDia = DateTime(_mes.year, _mes.month);

    // `weekday` va de 1 (lunes) a 7 (domingo): restar 1 da las casillas vacías
    // que hay antes del día 1, con la semana empezando en lunes.
    final huecoInicial = primerDia.weekday - 1;

    // El día 0 del mes siguiente es el último del actual.
    final diasDelMes = DateTime(_mes.year, _mes.month + 1, 0).day;

    final celdas = huecoInicial + diasDelMes;
    final semanas = (celdas / 7).ceil();

    return Column(
      children: [
        for (var semana = 0; semana < semanas; semana++) ...[
          if (semana > 0) const SizedBox(height: 6),
          Row(
            children: [
              for (var columna = 0; columna < 7; columna++)
                Expanded(child: _celda(semana * 7 + columna - huecoInicial)),
            ],
          ),
        ],
      ],
    );
  }

  /// [numeroDia] es 1..diasDelMes; fuera de ese rango la casilla va vacía.
  Widget _celda(int numeroDia) {
    final diasDelMes = DateTime(_mes.year, _mes.month + 1, 0).day;

    if (numeroDia < 1 || numeroDia > diasDelMes) {
      return const SizedBox(height: 54);
    }

    final fecha = DateTime(_mes.year, _mes.month, numeroDia);
    final estado = MockAsistencia.estadoDe(fecha);
    final esHoy = fecha == MockAsistencia.hoy;

    // Solo los días tarde o de falta llevan al formulario.
    final justificable =
        estado == EstadoDia.tarde || estado == EstadoDia.falta;

    return InkWell(
      onTap: justificable ? () => _justificar(fecha, estado!) : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: esHoy ? AppColors.primary.withValues(alpha: 0.1) : null,
          border: Border.all(
            color: esHoy ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$numeroDia',
              style: TextStyle(
                fontSize: 14,
                fontWeight: esHoy ? FontWeight.bold : FontWeight.normal,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 4),
            // Altura reservada aunque no haya icono, para que las filas no
            // bailen.
            SizedBox(
              height: 18,
              child: estado == null
                  ? null
                  : Icon(estado.icono, size: 16, color: estado.color),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _justificar(DateTime fecha, EstadoDia estado) {
    return AsistenciaPage.justificarDia(
      context,
      DiaAsistencia(fecha: fecha, estado: estado),
    );
  }

  Widget _leyenda() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            for (final estado in _estadosVisibles)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(estado.icono, size: 16, color: estado.color),
                  const SizedBox(width: 6),
                  Text(
                    estado.etiqueta,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textoS,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
