import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../data/mock_justificaciones.dart';
import '../domain/justificacion.dart';
import 'nueva_justificacion_page.dart';

/// "My justifications": el listado de lo enviado a RR. HH. y el acceso para
/// crear una nueva.
class JustificacionesPage extends StatefulWidget {
  const JustificacionesPage({super.key});

  @override
  State<JustificacionesPage> createState() => _JustificacionesPageState();
}

class _JustificacionesPageState extends State<JustificacionesPage> {
  Future<void> _nueva() async {
    final enviada = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const NuevaJustificacionPage()),
    );

    if (enviada != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Justification sent to HR')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final justificaciones = MockJustificaciones.enviadas;

    return Scaffold(
      appBar: AppBar(title: const Text('Justifications')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _nueva,
                icon: const Icon(Icons.add, color: AppColors.negroSplash),
                label: const Text(
                  'New justification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'My justifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 12),
            if (justificaciones.isEmpty)
              _vacio()
            else
              for (final (i, j) in justificaciones.indexed) ...[
                if (i > 0) const SizedBox(height: 12),
                _tarjeta(j),
              ],
          ],
        ),
      ),
    );
  }

  Widget _vacio() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.description_outlined, size: 48, color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Nothing to justify yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.texto,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Your justifications and their status will show up here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textoS),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(Justificacion j) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  j.tipo.etiqueta,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texto,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '· ${j.motivo.etiqueta}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textoS),
                ),
                const Spacer(),
                _chipEstado(j.estado),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEE dd MMM yyyy', 'en_US').format(j.fecha),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              j.descripcion,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textoS,
              ),
            ),
            if (j.adjuntos > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    size: 14,
                    color: AppColors.textoS,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    j.adjuntos == 1 ? '1 attachment' : '${j.adjuntos} attachments',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textoS,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chipEstado(EstadoJustificacion estado) {
    final color = switch (estado) {
      EstadoJustificacion.pendiente => AppColors.ambar,
      EstadoJustificacion.aprobada => AppColors.verde,
      EstadoJustificacion.rechazada => AppColors.rojo,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        estado.etiqueta,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
