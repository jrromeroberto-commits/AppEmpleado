import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PerfilFoto extends StatelessWidget {
  const PerfilFoto({
    super.key,
    this.foto,
    this.onCambiarFoto,
    this.lado = 110,
  });

  /// Ruta local de la foto elegida. `null` si aún no hay ninguna.
  final File? foto;

  final VoidCallback? onCambiarFoto;
  final double lado;

  bool get _editable => onCambiarFoto != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: lado,
      height: lado,
      child: Stack(
        children: [
          Container(
            width: lado,
            height: lado,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.tarjeta,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: foto == null
                ? Icon(
                    Icons.person_outline,
                    size: lado * 0.5,
                    color: AppColors.textoS,
                  )
                : Image.file(foto!, fit: BoxFit.cover),
          ),
          if (_editable)
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
                    // El borde del color del fondo recorta el círculo del
                    // avatar y hace que el botón se lea como pieza aparte.
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
