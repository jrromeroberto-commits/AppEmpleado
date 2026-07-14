import '../domain/cumpleanos.dart';

class MockCumpleanos {
  MockCumpleanos._();

  /// Ordenados por cercanía: el más próximo primero.
  static final proximos = <Cumpleanos>[
    Cumpleanos(
      empleadoId: '2',
      nombre: 'Valeria Torres',
      area: 'Design',
      fecha: DateTime(2025, 7, 8),
    ),
    Cumpleanos(
      empleadoId: '3',
      nombre: 'Carlos Medina',
      area: 'QA',
      fecha: DateTime(2025, 7, 11),
    ),
    Cumpleanos(
      empleadoId: '4',
      nombre: 'Lucia Ramirez',
      area: 'Marketing',
      fecha: DateTime(2025, 7, 19),
    ),
  ];
}
