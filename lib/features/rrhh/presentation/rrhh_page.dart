import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../empleados/data/mock_cumpleanos.dart';
import '../../home/presentation/widgets/tarjeta_cumpleanos.dart';
import '../data/mock_avisos.dart';
import '../domain/aviso.dart';

/// Pestaña "HR": noticias y avisos de Recursos Humanos, más los próximos
/// cumpleaños. A diferencia del resto de la app, sus tarjetas son **negras**.
class RrhhPage extends StatelessWidget {
  const RrhhPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Los fijados van arriba; el resto, del más reciente al más antiguo.
    final avisos = [...MockAvisos.publicados]
      ..sort((a, b) {
        if (a.fijado != b.fijado) return a.fijado ? -1 : 1;
        return b.fecha.compareTo(a.fecha);
      });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'HR',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          TarjetaCumpleanos(
            cumpleanos: MockCumpleanos.proximos,
            oscuro: true,
          ),
          const SizedBox(height: 20),
          const Text(
            'News & notices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 12),
          if (avisos.isEmpty)
            _vacio()
          else
            for (final (i, aviso) in avisos.indexed) ...[
              if (i > 0) const SizedBox(height: 14),
              _tarjeta(context, aviso),
            ],
        ],
      ),
    );
  }

  Widget _vacio() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.campaign_outlined, size: 56, color: AppColors.primary),
          SizedBox(height: 20),
          Text(
            'No news yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.texto,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "You'll see HR announcements here",
            style: TextStyle(fontSize: 14, color: AppColors.textoS),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Aviso aviso) {
    return Card(
      color: AppColors.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        // El aviso fijado se destaca con el borde dorado.
        side: BorderSide(
          color: aviso.fijado ? AppColors.primary : AppColors.bordeOscuro,
        ),
      ),
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Full article: coming soon')),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _chipTipo(aviso.tipo),
                  const Spacer(),
                  if (aviso.fijado) ...[
                    const Icon(
                      Icons.push_pin,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    DateFormat('dd MMM', 'en_US').format(aviso.fecha),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textoClaroS,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                aviso.titulo,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoClaro,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                aviso.resumen,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textoClaroS,
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.bordeOscuro),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.groups_outlined,
                    size: 16,
                    color: AppColors.textoClaroS,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    aviso.autor,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textoClaroS,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipTipo(TipoAviso tipo) {
    final color = switch (tipo) {
      TipoAviso.urgente => AppColors.rojo,
      TipoAviso.evento => AppColors.verde,
      TipoAviso.aviso => AppColors.ambar,
      TipoAviso.noticia => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        tipo.etiqueta,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
