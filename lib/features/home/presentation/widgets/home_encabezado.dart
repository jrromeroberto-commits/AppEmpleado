import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/empleado.dart';

/// Cabecera del Home: avatar, nombre, rol y campana de notificaciones.
class HomeEncabezado extends StatelessWidget {
  const HomeEncabezado({
    super.key,
    required this.empleado,
    this.hayNotificaciones = false,
  });

  final Empleado empleado;
  final bool hayNotificaciones;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _avatar(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                empleado.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // Sobre el AppBar negro.
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoClaro,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                empleado.rol.etiqueta,
                style: const TextStyle(fontSize: 14, color: AppColors.primary),
              ),
            ],
          ),
        ),
        const CampanaNotificaciones(),
      ],
    );
  }

  /// Sin foto todavía: se muestran las iniciales sobre el rojo de la marca.
  Widget _avatar() {
    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Text(
        empleado.iniciales,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.texto,
        ),
      ),
    );
  }
}

/// Campana que despliega el panel de notificaciones recientes.
///
/// El panel está vacío: no hay fuente de notificaciones todavía.
class CampanaNotificaciones extends StatelessWidget {
  const CampanaNotificaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      // El panel se ancla bajo la campana y se cierra al tocar fuera.
      alignmentOffset: const Offset(-220, 8),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.tarjeta),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.borde),
          ),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () =>
              controller.isOpen ? controller.close() : controller.open(),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.campoOscuro,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textoClaro,
            ),
          ),
        );
      },
      menuChildren: [_panel()],
    );
  }

  Widget _panel() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borde),
          const SizedBox(height: 24),
          const Center(
            child: Icon(
              Icons.notifications_off_outlined,
              size: 32,
              color: AppColors.textoS,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "You'll see recent notifications here",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textoS,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
