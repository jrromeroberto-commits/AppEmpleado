import '../../auth/domain/empleado.dart';
import '../domain/dia_asistencia.dart';
import '../domain/marca.dart';
import '../domain/resumen_mensual.dart';

/// Fuente de datos provisional mientras no existe el backend.
///
/// **Está vacía a propósito**: así se ve la app tal como la encontraría un
/// empleado recién registrado, y se puede revisar que cada pantalla tenga un
/// estado vacío decente.
///
/// Se sustituye en la Fase D.1 por el repositorio real; la UI no cambia porque
/// consume estos mismos tipos de dominio.
class MockAsistencia {
  MockAsistencia._();

  /// Usuario de la sesión. No es "contenido": viene de la autenticación, así
  /// que se mantiene aunque no haya datos de asistencia.
  static const empleado = Empleado(
    id: '1',
    nombre: 'Mitchell Santos',
    rol: RolUsuario.empleado,
  );

  /// Fecha de referencia. Cuando haya backend será `DateTime.now()`.
  static final _hoy = DateTime(2026, 7, 20);

  /// Resumen del mes: sin registros todavía.
  static final resumen = ResumenMensual(
    mes: DateTime(2026, 7),
    faltas: 0,
    tardanzas: 0,
    asistencias: 0,
    estadoHoy: EstadoHoy.sinMarcar,
  );

  static final ultimasMarcas = <Marca>[];

  /// Los últimos 7 días.
  static final ultimosDias = <DiaAsistencia>[];

  /// Todas las marcas registradas, para el historial completo.
  static final historial = <DiaAsistencia>[];

  /// Estado de cada día del mes, para el calendario.
  static final estadosDelMes = <DateTime, EstadoDia>{};

  /// Busca el estado de un día, ignorando la hora.
  static EstadoDia? estadoDe(DateTime fecha) {
    return estadosDelMes[DateTime(fecha.year, fecha.month, fecha.day)];
  }

  /// Horario laboral de la empresa. Será configurable desde el panel de
  /// administración (ver ARQUITECTURA.md, sección 6.C.6).
  static const horaEntrada = '9:00 a. m.';
  static const horaSalida = '6:00 p. m.';
  static const zonaHoraria = 'Peru';

  static DateTime get hoy => _hoy;
}
