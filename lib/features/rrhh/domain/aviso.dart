/// Tipo de publicación de RR. HH.
enum TipoAviso {
  noticia(etiqueta: 'News'),
  aviso(etiqueta: 'Notice'),
  evento(etiqueta: 'Event'),
  urgente(etiqueta: 'Urgent');

  const TipoAviso({required this.etiqueta});

  final String etiqueta;
}

/// Noticia o aviso publicado por Recursos Humanos.
class Aviso {
  const Aviso({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.tipo,
    required this.fecha,
    required this.autor,
    this.fijado = false,
  });

  final String id;
  final String titulo;
  final String resumen;
  final TipoAviso tipo;
  final DateTime fecha;
  final String autor;

  /// Los avisos fijados se muestran arriba del todo.
  final bool fijado;
}
