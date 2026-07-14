import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/mock_asistencia.dart';
import 'calendario_page.dart';
import 'widgets/tabla_marcaciones.dart';
import 'widgets/tarjeta_ultimos_dias.dart';

class AsistenciaPage extends StatelessWidget {
  const AsistenciaPage({super.key, this.onIrARrhh});
  /// Lleva a la pestaña de RR. HH. (para justificar una tardanza).
  final VoidCallback? onIrARrhh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Attendance',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.primary,
            ),
            tooltip: 'Calendar',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CalendarioPage()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          TarjetaUltimosDias(dias: MockAsistencia.ultimosDias),
          const SizedBox(height: 16),
          TablaMarcaciones(dias: MockAsistencia.ultimosDias),
          const SizedBox(height: 16),
          _accionesRapidas(context),
        ],
      ),
    );
  }

  Widget _accionesRapidas(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 16),
            _accion(
              context,
              icono: Icons.edit_note,
              titulo: 'Justify a late arrival',
              subtitulo: 'Send your justification to HR',
              onTap: onIrARrhh,
            ),
            const SizedBox(height: 12),
            _accion(
              context,
              icono: Icons.description_outlined,
              titulo: 'Full history',
              subtitulo: 'Review all your punches',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Full history: coming soon')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accion(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required String subtitulo,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.negroSplash,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borde),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, size: 22, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.texto,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textoS,
                    ),
                  ),
                ],
              ),
            ),
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
