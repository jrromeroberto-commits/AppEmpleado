import '../domain/aviso.dart';

/// Avisos provisionales mientras no existe el backend.
///
/// Vacío a propósito: los publicará Recursos Humanos.
class MockAvisos {
  MockAvisos._();

  static final publicados = <Aviso>[];
}
