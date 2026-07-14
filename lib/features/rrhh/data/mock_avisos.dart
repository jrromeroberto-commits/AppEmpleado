import '../domain/aviso.dart';

/// Avisos provisionales mientras no existe el backend.
class MockAvisos {
  MockAvisos._();

  static final publicados = <Aviso>[
    Aviso(
      id: 'a1',
      titulo: 'New attendance policy',
      resumen:
          'Starting August 1st, the grace period for clocking in will be '
          'five minutes. Please review the full policy in the intranet.',
      tipo: TipoAviso.urgente,
      fecha: DateTime(2025, 7, 8),
      autor: 'Human Resources',
      fijado: true,
    ),
    Aviso(
      id: 'a2',
      titulo: 'Runway 7 anniversary party',
      resumen:
          'Join us on July 25th at 7:00 p. m. to celebrate our anniversary. '
          'Bring a friend!',
      tipo: TipoAviso.evento,
      fecha: DateTime(2025, 7, 7),
      autor: 'Wellness',
    ),
    Aviso(
      id: 'a3',
      titulo: 'Cafeteria menu update',
      resumen:
          'We added vegetarian and gluten-free options to the weekly menu, '
          'based on your suggestions.',
      tipo: TipoAviso.noticia,
      fecha: DateTime(2025, 7, 4),
      autor: 'Administration',
    ),
    Aviso(
      id: 'a4',
      titulo: 'Vacation requests for Q3',
      resumen:
          'Send your vacation requests before July 20th so we can plan '
          'coverage for your team.',
      tipo: TipoAviso.aviso,
      fecha: DateTime(2025, 7, 2),
      autor: 'Human Resources',
    ),
  ];
}
