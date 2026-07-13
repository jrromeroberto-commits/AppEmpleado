/// Estado de asistencia del día en curso.
enum EstadoHoy {
  presente(etiqueta: 'Present'),
  ausente(etiqueta: 'Absent'),
  sinMarcar(etiqueta: 'Not marked');

  const EstadoHoy({required this.etiqueta});

  final String etiqueta;
}

class ResumenMensual {
  const ResumenMensual({
    required this.mes,
    required this.faltas,
    required this.tardanzas,
    required this.asistencias,
    required this.estadoHoy,
    this.horaMarcaHoy,
  });

  final DateTime mes;
  final int faltas;
  final int tardanzas;
  final int asistencias;
  final EstadoHoy estadoHoy;

  /// Hora de la primera marca de hoy. `null` si aún no ha marcado.
  final DateTime? horaMarcaHoy;

  /// Porcentaje de tardanzas sobre los días con registro del mes.
  double get porcentajeTardanzas {
    final total = tardanzas + asistencias + faltas;
    if (total == 0) return 0;
    return tardanzas / total;
  }
}
