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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texto,
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
        _campana(),
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

  Widget _campana() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.tarjeta,
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.texto,
          ),
        ),
        if (hayNotificaciones)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: AppColors.fondo, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
