/// Estado de una sugerencia enviada a RR. HH.
enum EstadoSugerencia {
  enRevision(etiqueta: 'In review'),
  aprobada(etiqueta: 'Approved'),
  desaprobada(etiqueta: 'Rejected');

  const EstadoSugerencia({required this.etiqueta});

  final String etiqueta;
}

/// Una sugerencia enviada por el empleado.
class Sugerencia {
  const Sugerencia({
    required this.id,
    required this.asunto,
    required this.categoria,
    required this.fecha,
    required this.estado,
  });

  final String id;
  final String asunto;
  final String categoria;
  final DateTime fecha;
  final EstadoSugerencia estado;
}
