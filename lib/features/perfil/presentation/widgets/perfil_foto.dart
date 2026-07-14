import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
class PerfilFoto extends StatelessWidget {
  const PerfilFoto({super.key, required this.onCambiarFoto});

  final VoidCallback onCambiarFoto;

  static const _lado = 110.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _lado,
      height: _lado,
      child: Stack(
        children: [
          Container(
            width: _lado,
            height: _lado,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.tarjeta,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 56,
              color: AppColors.textoS,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onCambiarFoto,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  // El borde del color del fondo recorta el círculo del avatar
                  // y hace que el botón se lea como una pieza aparte.
                  border: Border.all(color: AppColors.fondo, width: 3),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  size: 16,
                  color: AppColors.texto,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
