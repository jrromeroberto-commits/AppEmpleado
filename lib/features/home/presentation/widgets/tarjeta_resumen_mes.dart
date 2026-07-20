import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../asistencia/data/mock_asistencia.dart';
import '../../../asistencia/domain/resumen_mensual.dart';
import 'anillo_tardanzas.dart';

/// Tarjeta "Monthly attendance": anillo de tardanzas, horario de ingreso y los
/// cuatro contadores del mes.
class TarjetaResumenMes extends StatelessWidget {
  const TarjetaResumenMes({super.key, required this.resumen});

  final ResumenMensual resumen;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 8),
            _selectorMes(),
            const SizedBox(height: 16),
            _anilloYMensaje(),
            const SizedBox(height: 20),
            _contadores(),
          ],
        ),
      ),
    );
  }

  /// El mes del resumen.
  ///
  /// Sin chevron: es una etiqueta, no un selector. El cambio de mes vive en el
  /// calendario y en el historial; un desplegable aquí prometería una acción
  /// que esta tarjeta no hace.
  Widget _selectorMes() {
    final mes = DateFormat('MMMM yyyy', 'en_US').format(resumen.mes);

    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: AppColors.textoS,
        ),
        const SizedBox(width: 8),
        Text(
          mes,
          style: const TextStyle(fontSize: 15, color: AppColors.textoS),
        ),
      ],
    );
  }

  Widget _anilloYMensaje() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnilloTardanzas(porcentaje: resumen.porcentajeTardanzas),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _mensaje(),
              const SizedBox(height: 14),
              _chipHorario(),
            ],
          ),
        ),
      ],
    );
  }

  /// Sin registros no se puede felicitar a nadie por su puntualidad: se explica
  /// qué va a aparecer ahí.
  Widget _mensaje() {
    if (resumen.sinRegistros) {
      return const Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 15,
            height: 1.4,
            color: AppColors.textoS,
          ),
          children: [
            TextSpan(
              text: 'No records yet. ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
            TextSpan(text: 'Your attendance will show up here.'),
          ],
        ),
      );
    }

    return const Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w600,
          color: AppColors.texto,
        ),
        children: [
          TextSpan(text: "You're doing well, keep up your "),
          TextSpan(
            text: 'punctuality.',
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _chipHorario() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.campo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borde),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Entry time:',
                  style: TextStyle(fontSize: 12, color: AppColors.textoS),
                ),
                Text(
                  '${MockAsistencia.horaEntrada} '
                  '(${MockAsistencia.zonaHoraria})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.texto,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contadores() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.campo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borde),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _contador(
                icono: Icons.person_off_outlined,
                etiqueta: 'Absences',
                valor: '${resumen.faltas}',
              ),
            ),
            _divisor(),
            Expanded(
              child: _contador(
                icono: Icons.schedule,
                etiqueta: 'Late',
                valor: '${resumen.tardanzas}',
              ),
            ),
            _divisor(),
            Expanded(
              child: _contador(
                icono: Icons.check_circle_outline,
                etiqueta: 'Present',
                valor: '${resumen.asistencias}',
              ),
            ),
            _divisor(),
            Expanded(child: _estadoHoy()),
          ],
        ),
      ),
    );
  }

  Widget _divisor() =>
      const VerticalDivider(width: 1, thickness: 1, color: AppColors.borde);

  Widget _contador({
    required IconData icono,
    required String etiqueta,
    required String valor,
  }) {
    return Column(
      children: [
        Icon(icono, size: 24, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          etiqueta,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.textoS),
        ),
        const SizedBox(height: 6),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
      ],
    );
  }

  Widget _estadoHoy() {
    final hora = resumen.horaMarcaHoy;

    return Column(
      children: [
        const Icon(
          Icons.radio_button_checked,
          size: 24,
          color: AppColors.primary,
        ),
        const SizedBox(height: 8),
        const Text(
          'Today',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textoS),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            resumen.estadoHoy.etiqueta,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        if (hora != null)
          Text(
            DateFormat('hh:mm a', 'en_US').format(hora),
            style: const TextStyle(fontSize: 11, color: AppColors.textoS),
          ),
      ],
    );
  }
}
