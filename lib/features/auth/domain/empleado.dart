
enum RolUsuario {
  empleado(etiqueta: 'Employee'),
  rrhh(etiqueta: 'Human Resources'),
  administracion(etiqueta: 'Administration');

  const RolUsuario({required this.etiqueta});

  final String etiqueta;
}

/// Usuario autenticado.
class Empleado {
  const Empleado({
    required this.id,
    required this.nombre,
    required this.rol,
  });

  final String id;
  final String nombre;
  final RolUsuario rol;

  /// Iniciales para el avatar cuando no hay foto.
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) {
      final unica = partes.first;
      final largo = unica.length < 2 ? unica.length : 2;
      return unica.substring(0, largo).toUpperCase();
    }
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }
}
