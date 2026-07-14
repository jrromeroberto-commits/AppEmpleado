/// Estado de un día de asistencia.
///
/// Sin iconos ni colores: el dominio no sabe de UI. El mapeo visual vive en
/// `presentation/widgets/estado_dia_visual.dart`.
enum EstadoDia {
  aTiempo(etiqueta: 'On time'),
  tarde(etiqueta: 'Late'),
  falta(etiqueta: 'Absent'),
  pendiente(etiqueta: 'Pending');

  const EstadoDia({required this.etiqueta});

  final String etiqueta;
}

/// Resumen de un día para la tira de "Last 7 days".
class DiaAsistencia {
  const DiaAsistencia({
    required this.fecha,
    required this.estado,
    this.entrada,
    this.salida,
    this.esHoy = false,
  });

  final DateTime fecha;
  final EstadoDia estado;

  /// `null` si ese día no hubo marca.
  final DateTime? entrada;
  final DateTime? salida;

  final bool esHoy;
}
