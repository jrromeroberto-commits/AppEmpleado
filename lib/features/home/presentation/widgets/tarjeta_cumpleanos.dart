import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../asistencia/data/mock_asistencia.dart';
import '../../../empleados/domain/cumpleanos.dart';

/// Tarjeta "Upcoming birthdays": los próximos cumpleaños de los compañeros.
///
/// Con [oscuro] la tarjeta usa la paleta oscura (para la pestaña de HR, cuyas
/// tarjetas son negras); sin él, la clara (para el Home).
class TarjetaCumpleanos extends StatelessWidget {
  const TarjetaCumpleanos({
    super.key,
    required this.cumpleanos,
    this.onVerTodos,
    this.oscuro = false,
  });

  final List<Cumpleanos> cumpleanos;

  /// Lleva a la pestaña de RR. HH.
  final VoidCallback? onVerTodos;

  final bool oscuro;

  Color get _colorTexto => oscuro ? AppColors.textoClaro : AppColors.texto;
  Color get _colorTextoS => oscuro ? AppColors.textoClaroS : AppColors.textoS;
  Color get _colorBorde => oscuro ? AppColors.bordeOscuro : AppColors.borde;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: oscuro ? AppColors.superficie : AppColors.tarjeta,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: _colorBorde),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cake_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Upcoming birthdays',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _colorTexto,
                  ),
                ),
                const Spacer(),
                if (onVerTodos != null)
                  TextButton(
                    onPressed: onVerTodos,
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
            if (cumpleanos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No birthdays coming up.',
                  style: TextStyle(fontSize: 14, color: _colorTextoS),
                ),
              )
            else
              for (final (i, cumple) in cumpleanos.indexed) ...[
                if (i > 0) Divider(height: 24, color: _colorBorde),
                _fila(cumple),
              ],
          ],
        ),
      ),
    );
  }

  Widget _fila(Cumpleanos cumple) {
    final esHoy = cumple.esHoy(MockAsistencia.hoy);
    final dias = cumple.diasRestantes(MockAsistencia.hoy);

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: esHoy ? 1 : 0.15),
          ),
          child: Text(
            cumple.iniciales,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: esHoy ? AppColors.negroSplash : AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cumple.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _colorTexto,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                cumple.area,
                style: TextStyle(fontSize: 12, color: _colorTextoS),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _chipFecha(cumple, esHoy, dias),
      ],
    );
  }

  /// El cumpleaños de hoy se resalta en dorado; los demás muestran la fecha.
  Widget _chipFecha(Cumpleanos cumple, bool esHoy, int dias) {
    if (esHoy) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Today 🎉',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.negroSplash,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('dd MMM', 'en_US').format(cumple.fecha),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          dias == 1 ? 'in 1 day' : 'in $dias days',
          style: TextStyle(fontSize: 11, color: _colorTextoS),
        ),
      ],
    );
  }
}
