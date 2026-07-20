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

  /// Días con registro en el mes.
  int get totalRegistros => tardanzas + asistencias + faltas;

  /// El mes aún no tiene ninguna marca.
  bool get sinRegistros => totalRegistros == 0;

  /// Porcentaje de tardanzas sobre los días con registro del mes.
  double get porcentajeTardanzas {
    if (sinRegistros) return 0;
    return tardanzas / totalRegistros;
  }
}
