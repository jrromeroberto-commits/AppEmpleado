import '../../asistencia/domain/dia_asistencia.dart';

/// Qué se justifica.
enum TipoJustificacion {
  tardanza(etiqueta: 'Late arrival'),
  falta(etiqueta: 'Absence'),
  salidaAnticipada(etiqueta: 'Early leave');

  const TipoJustificacion({required this.etiqueta});

  final String etiqueta;

  /// Tipo que corresponde al estado de un día, para pre-rellenar el formulario
  /// cuando se justifica desde el calendario o la tabla de marcas.
  static TipoJustificacion? desdeEstado(EstadoDia estado) => switch (estado) {
    EstadoDia.tarde => TipoJustificacion.tardanza,
    EstadoDia.falta => TipoJustificacion.falta,
    // Un día a tiempo o sin marcar no tiene nada que justificar.
    EstadoDia.aTiempo || EstadoDia.pendiente => null,
  };
}

/// Motivo de la justificación.
enum MotivoJustificacion {
  medico(etiqueta: 'Medical'),
  emergenciaFamiliar(etiqueta: 'Family emergency'),
  transporte(etiqueta: 'Transport'),
  personal(etiqueta: 'Personal'),
  otro(etiqueta: 'Other');

  const MotivoJustificacion({required this.etiqueta});

  final String etiqueta;
}

/// Estado de la revisión por parte de RR. HH.
enum EstadoJustificacion {
  pendiente(etiqueta: 'Pending'),
  aprobada(etiqueta: 'Approved'),
  rechazada(etiqueta: 'Rejected');

  const EstadoJustificacion({required this.etiqueta});

  final String etiqueta;
}

/// Una justificación enviada por el empleado a RR. HH.
class Justificacion {
  const Justificacion({
    required this.id,
    required this.tipo,
    required this.motivo,
    required this.fecha,
    required this.descripcion,
    required this.estado,
    required this.enviadaEl,
    this.adjuntos = 0,
  });

  final String id;
  final TipoJustificacion tipo;
  final MotivoJustificacion motivo;

  /// Día que se justifica.
  final DateTime fecha;

  final String descripcion;
  final EstadoJustificacion estado;
  final DateTime enviadaEl;

  /// Cuántas pruebas se adjuntaron.
  final int adjuntos;
}
