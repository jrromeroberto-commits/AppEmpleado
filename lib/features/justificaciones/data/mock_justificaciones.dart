import '../domain/justificacion.dart';

/// Justificaciones provisionales mientras no existe el backend.
///
/// Vacío a propósito: se llena con lo que el empleado envíe.
class MockJustificaciones {
  MockJustificaciones._();

  /// De la más reciente a la más antigua.
  static final enviadas = <Justificacion>[];
}
