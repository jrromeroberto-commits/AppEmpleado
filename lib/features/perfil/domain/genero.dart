/// Opciones del campo "Gender" del perfil.
enum Genero {
  masculino(etiqueta: 'Male'),
  femenino(etiqueta: 'Female'),
  otro(etiqueta: 'Other'),
  prefiereNoDecir(etiqueta: 'Prefer not to say');

  const Genero({required this.etiqueta});

  final String etiqueta;
}
