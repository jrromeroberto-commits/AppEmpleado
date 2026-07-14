import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Campo de texto con etiqueta, usado en los formularios del perfil.
class CampoPerfil extends StatelessWidget {
  const CampoPerfil({
    super.key,
    required this.etiqueta,
    required this.icono,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.soloLectura = false,
    this.onTap,
    this.textoAyuda,
  });

  final String etiqueta;
  final IconData icono;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  /// El usuario no escribe: el valor lo pone la app (fecha, edad calculada).
  final bool soloLectura;

  final VoidCallback? onTap;

  /// Aclaración bajo el campo.
  final String? textoAyuda;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.texto,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: soloLectura,
          onTap: onTap,
          style: TextStyle(
            color: soloLectura ? AppColors.textoS : AppColors.texto,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icono, color: AppColors.primary),
            helperText: textoAyuda,
            helperStyle: const TextStyle(
              fontSize: 11,
              color: AppColors.textoS,
            ),
          ),
        ),
      ],
    );
  }
}
