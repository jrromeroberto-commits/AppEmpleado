/// Resumen de un día para la tira de "Recent days".
class DiaAsistencia {
  const DiaAsistencia({
    required this.fecha,
    this.entrada,
    this.salida,
    this.esHoy = false,
  });

  final DateTime fecha;

  /// `null` si ese día no hubo marca.
  final DateTime? entrada;
  final DateTime? salida;

  final bool esHoy;
}
