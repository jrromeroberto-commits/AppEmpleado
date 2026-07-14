/// Cumpleaños de un compañero, para el recuadro del Home.
///
/// Solo aparecen los empleados registrados en la app que han completado su
/// fecha de nacimiento en el perfil.
class Cumpleanos {
  const Cumpleanos({
    required this.empleadoId,
    required this.nombre,
    required this.area,
    required this.fecha,
  });

  final String empleadoId;
  final String nombre;
  final String area;

  /// Día y mes del cumpleaños. El año es el de la próxima celebración.
  final DateTime fecha;

  /// Iniciales para el avatar cuando no hay foto.
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.length < 2) {
      final unica = partes.first;
      return unica.substring(0, unica.length < 2 ? unica.length : 2)
          .toUpperCase();
    }
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }

  /// Días que faltan, contando desde [hoy].
  int diasRestantes(DateTime hoy) {
    final soloDia = DateTime(hoy.year, hoy.month, hoy.day);
    return fecha.difference(soloDia).inDays;
  }

  bool esHoy(DateTime hoy) => diasRestantes(hoy) == 0;
}