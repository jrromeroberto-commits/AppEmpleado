import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../reset_password_page.dart';

/// Hoja inferior para pedir el correo al que enviar el código de recuperación.
///
/// Se abre con [mostrar], que la eleva desde abajo hasta la mitad de la
/// pantalla.
class RecuperarPasswordSheet extends StatefulWidget {
  const RecuperarPasswordSheet({super.key});

  static Future<void> mostrar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.tarjeta,
      // El teclado no debe tapar el campo al escribir el correo.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const RecuperarPasswordSheet(),
    );
  }

  @override
  State<RecuperarPasswordSheet> createState() => _RecuperarPasswordSheetState();
}

class _RecuperarPasswordSheetState extends State<RecuperarPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  String? _validarCorreo(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) {
      return 'Enter your email';
    }
    final correoValido = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!correoValido.hasMatch(texto)) {
      return 'Invalid email format';
    }
    return null;
  }

  void _recuperar() {
    if (!_formKey.currentState!.validate()) return;

    final correo = _correoController.text.trim();

    // TODO(backend): pedir a la API que envíe el código al correo.
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResetPasswordPage(correo: correo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaTeclado = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      // Empuja la hoja por encima del teclado cuando este aparece.
      padding: EdgeInsets.only(bottom: alturaTeclado),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _asa()),
              const SizedBox(height: 24),
              const Icon(
                Icons.lock_reset,
                size: 44,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Forgot your password?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texto,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your email and we will send you a 6-digit code to '
                'reset your password.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.textoS,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _correoController,
                  validator: _validarCorreo,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _recuperar(),
                  autofocus: true,
                  autofillHints: const [AutofillHints.email],
                  style: const TextStyle(color: AppColors.texto),
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _recuperar,
                  child: const Text(
                    'Recover password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Barrita superior que indica que la hoja se puede arrastrar.
  Widget _asa() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.borde,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
