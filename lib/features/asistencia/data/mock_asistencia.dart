import '../../auth/domain/empleado.dart';
import '../domain/dia_asistencia.dart';
import '../domain/marca.dart';
import '../domain/resumen_mensual.dart';

class MockAsistencia {
  MockAsistencia._();

  static const empleado = Empleado(
    id: '1',
    nombre: 'El elemento',
    rol: RolUsuario.empleado,
  );

  /// Fecha de referencia de los datos de ejemplo (lunes 8 de julio).
  static final _hoy = DateTime(2025, 7, 8);

  static final resumen = ResumenMensual(
    mes: DateTime(2025, 7),
    faltas: 1,
    tardanzas: 2,
    asistencias: 22,
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
      fechaHora: DateTime(2025, 7, 8, 18, 7),
      tipo: TipoMarca.salida,
    ),
  ];

  static final ultimosDias = <DiaAsistencia>[
    DiaAsistencia(
      fecha: DateTime(2025, 7, 2),
      entrada: DateTime(2025, 7, 2, 8, 58),
      salida: DateTime(2025, 7, 2, 18, 5),
    ),
    DiaAsistencia(
      fecha: DateTime(2025, 7, 3),
      entrada: DateTime(2025, 7, 3, 9, 2),
      salida: DateTime(2025, 7, 3, 18, 6),
    ),
    DiaAsistencia(
      fecha: DateTime(2025, 7, 4),
      entrada: DateTime(2025, 7, 4, 8, 57),
      salida: DateTime(2025, 7, 4, 18, 3),
    ),
    DiaAsistencia(
      fecha: DateTime(2025, 7, 5),
      entrada: DateTime(2025, 7, 5, 8, 59),
      salida: DateTime(2025, 7, 5, 18, 4),
    ),
    DiaAsistencia(
      fecha: DateTime(2025, 7, 8),
      entrada: DateTime(2025, 7, 8, 8, 56),
      salida: DateTime(2025, 7, 8, 18, 7),
      esHoy: true,
    ),
  ];
  static const horaEntrada = '9:00 a. m.';
  static const zonaHoraria = 'Peru';

  static DateTime get hoy => _hoy;
}
