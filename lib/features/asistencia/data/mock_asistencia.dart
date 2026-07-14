import '../../auth/domain/empleado.dart';
import '../domain/dia_asistencia.dart';
import '../domain/marca.dart';
import '../domain/resumen_mensual.dart';


class MockAsistencia {
  MockAsistencia._();

  static const empleado = Empleado(
    id: '1',
    nombre: 'Mitchell Santos',
    rol: RolUsuario.empleado,
  );

  static final _hoy = DateTime(2025, 7, 8);

  static final resumen = ResumenMensual(
    mes: DateTime(2025, 7),
    faltas: 1,
    tardanzas: 4,
    asistencias: 20,
    estadoHoy: EstadoHoy.presente,
    horaMarcaHoy: DateTime(2025, 7, 8, 8, 56),
  );

  static final ultimasMarcas = <Marca>[
    Marca(
      id: 'm1',
      fechaHora: DateTime(2025, 7, 8, 8, 56),
      tipo: TipoMarca.entrada,
    ),
    Marca(
      id: 'm2',
      fechaHora: DateTime(2025, 7, 7, 18, 7),
      tipo: TipoMarca.salida,
    ),
  ];

  /// Los últimos 7 días, con los cuatro estados posibles representados.
  static final ultimosDias = <DiaAsistencia>[
    DiaAsistencia(
      fecha: DateTime(2025, 7, 2),
      estado: EstadoDia.aTiempo,
      entrada: DateTime(2025, 7, 2, 8, 58),
      salida: DateTime(2025, 7, 2, 18, 5),
    ),
    DiaAsistencia(
      fecha: DateTime(2025, 7, 3),
      estado: EstadoDia.tarde,
      entrada: DateTime(2025, 7, 3, 9, 2),
      salida: DateTime(2025, 7, 3, 18, 6),
    ),
    DiaAsistencia(
      fecha: DateTime(2025, 7, 4),
      estado: EstadoDia.aTiempo,
      entrada: DateTime(2025, 7, 4, 8, 57),
      salida: DateTime(2025, 7, 4, 18, 3),
    ),
    // Fin de semana: no laborable.
    DiaAsistencia(fecha: DateTime(2025, 7, 5), estado: EstadoDia.pendiente),
    DiaAsistencia(fecha: DateTime(2025, 7, 6), estado: EstadoDia.pendiente),
    DiaAsistencia(fecha: DateTime(2025, 7, 7), estado: EstadoDia.falta),
    DiaAsistencia(
      fecha: DateTime(2025, 7, 8),
      estado: EstadoDia.aTiempo,
      entrada: DateTime(2025, 7, 8, 8, 56),
      esHoy: true,
    ),
  ];

  static final estadosDelMes = <DateTime, EstadoDia>{
    DateTime(2025, 7, 1): EstadoDia.aTiempo,
    DateTime(2025, 7, 2): EstadoDia.aTiempo,
    DateTime(2025, 7, 3): EstadoDia.tarde,
    DateTime(2025, 7, 4): EstadoDia.aTiempo,
    DateTime(2025, 7, 7): EstadoDia.falta,
    DateTime(2025, 7, 8): EstadoDia.aTiempo,
  };

  /// Busca el estado de un día, ignorando la hora.
  static EstadoDia? estadoDe(DateTime fecha) {
    return estadosDelMes[DateTime(fecha.year, fecha.month, fecha.day)];
  }

  static const horaEntrada = '9:00 a. m.';
  static const horaSalida = '6:00 p. m.';
  static const zonaHoraria = 'Peru';

  static DateTime get hoy => _hoy;
}
