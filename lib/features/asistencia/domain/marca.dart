/// Tipo de marca registrada en el lector.
enum TipoMarca {
  entrada(etiqueta: 'Clock in'),
  salida(etiqueta: 'Clock out');

  const TipoMarca({required this.etiqueta});

  final String etiqueta;
}

/// Una marca de asistencia leída del terminal facial.
class Marca {
  const Marca({
    required this.id,
    required this.fechaHora,
    required this.tipo,
  });

  final String id;
  final DateTime fechaHora;
  final TipoMarca tipo;
}
