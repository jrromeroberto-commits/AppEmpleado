import '../domain/sugerencia.dart';

/// Sugerencias provisionales mientras no existe el backend.
class MockSugerencias {
  MockSugerencias._();

  static final recientes = <Sugerencia>[
    Sugerencia(
      id: 's1',
      asunto: 'Improve the lunch menu',
      categoria: 'Cafeteria',
      fecha: DateTime(2025, 7, 8),
      estado: EstadoSugerencia.enRevision,
    ),
    Sugerencia(
      id: 's2',
      asunto: 'Add more active breaks',
      categoria: 'Wellness',
      fecha: DateTime(2025, 7, 5),
      estado: EstadoSugerencia.aprobada,
    ),
    Sugerencia(
      id: 's3',
      asunto: 'Flexible working hours',
      categoria: 'Schedule',
      fecha: DateTime(2025, 7, 2),
      estado: EstadoSugerencia.desaprobada,
    ),
  ];
}
