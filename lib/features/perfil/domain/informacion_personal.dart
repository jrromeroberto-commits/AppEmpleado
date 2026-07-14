import 'dart:io';

import 'genero.dart';

/// Datos personales del empleado.
class InformacionPersonal {
  const InformacionPersonal({
    required this.nombre,
    required this.apellido,
    required this.nacimiento,
    required this.genero,
    required this.correo,
    required this.area,
    required this.cargo,
    this.foto,
  });

  final String nombre;
  final String apellido;
  final DateTime nacimiento;
  final Genero genero;
  final String correo;
  final String area;
  final String cargo;

  /// Foto de perfil. `null` si el empleado no ha subido ninguna.
  final File? foto;

  String get nombreCompleto => '$nombre $apellido';

  int get edad {
    final ahora = DateTime.now();
    var edad = ahora.year - nacimiento.year;
    final yaCumplio =
        ahora.month > nacimiento.month ||
        (ahora.month == nacimiento.month && ahora.day >= nacimiento.day);
    if (!yaCumplio) edad--;
    return edad;
  }
}
