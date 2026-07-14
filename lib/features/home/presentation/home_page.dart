import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../asistencia/data/mock_asistencia.dart';
import '../../empleados/data/mock_cumpleanos.dart';
import 'widgets/home_encabezado.dart';
import 'widgets/tarjeta_cumpleanos.dart';
import 'widgets/tarjeta_resumen_mes.dart';
import 'widgets/tarjeta_ultimas_marcas.dart';

/// Home del empleado: una tarjeta por cada sección, con acceso a su pestaña.
class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onIrAAsistencia, this.onIrARrhh});

  final VoidCallback? onIrAAsistencia;
  final VoidCallback? onIrARrhh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // La cabecera (avatar + nombre + campana) es alta: el AppBar por
        // defecto (56) la recortaría.
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: const HomeEncabezado(
          empleado: MockAsistencia.empleado,
          hayNotificaciones: false,
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.tarjeta,
        onRefresh: _refrescar,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            TarjetaResumenMes(resumen: MockAsistencia.resumen),
            const SizedBox(height: 16),
            TarjetaUltimasMarcas(
              marcas: MockAsistencia.ultimasMarcas,
              onVerTodas: onIrAAsistencia,
            ),
            const SizedBox(height: 16),
            // Va al final de la pantalla, como último bloque.
            TarjetaCumpleanos(
              cumpleanos: MockCumpleanos.proximos,
              onVerTodos: onIrARrhh,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refrescar() async {
    // TODO(backend): recargar el resumen y las marcas desde la API.
  }
}
