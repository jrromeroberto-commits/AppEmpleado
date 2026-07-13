import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../asistencia/data/mock_asistencia.dart';
import 'widgets/home_encabezado.dart';
import 'widgets/tarjeta_resumen_mes.dart';
import 'widgets/tarjeta_ultimas_marcas.dart';
import 'widgets/tarjeta_ultimos_dias.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.tarjeta,
        onRefresh: _refrescar,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const HomeEncabezado(
              empleado: MockAsistencia.empleado,
              hayNotificaciones: true,
            ),
            const SizedBox(height: 20),
            TarjetaResumenMes(resumen: MockAsistencia.resumen),
            const SizedBox(height: 16),
            TarjetaUltimasMarcas(marcas: MockAsistencia.ultimasMarcas),
            const SizedBox(height: 16),
            TarjetaUltimosDias(dias: MockAsistencia.ultimosDias),
            const SizedBox(height: 16),
            _bannerHorario(),
          ],
        ),
      ),
    );
  }

  Future<void> _refrescar() async {
    // TODO(backend): recargar el resumen y las marcas desde la API.
  }

  Widget _bannerHorario() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 26,
              color: AppColors.primary,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Your entry time is ${MockAsistencia.horaEntrada} '
                '(${MockAsistencia.zonaHoraria}). '
                'Arriving on time earns you points.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.textoS,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textoS,
            ),
          ],
        ),
      ),
    );
  }
}
