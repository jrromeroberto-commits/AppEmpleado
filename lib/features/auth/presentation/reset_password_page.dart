import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'widgets/codigo_input.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.correo});

  /// Correo al que se envió el código. Se muestra para dar contexto.
  final String correo;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _repetirController = TextEditingController();

  String _codigo = '';
  bool _verificado = false;
  bool _ocultaPassword = true;
  bool _ocultaRepetir = true;

  bool get _codigoCompleto => _codigo.length == CodigoInput.largo;

  @override
  void dispose() {
    _passwordController.dispose();
    _repetirController.dispose();
    super.dispose();
  }

  void _verificar() {
    if (!_codigoCompleto) return;

    // TODO(backend): validar el código contra la API.
    setState(() => _verificado = true);
  }

  String? _validarPassword(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) {
      return 'Enter your new password';
    }
    if (texto.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validarRepetir(String? valor) {
    if ((valor ?? '').isEmpty) {
      return 'Repeat your new password';
    }
    if (valor != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _cambiarPassword() {
    if (!_formKey.currentState!.validate()) return;

    // TODO(backend): enviar la nueva contraseña a la API.
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed successfully')),
    );
  }

  void _reenviarCodigo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code resent to your email')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _encabezado(),
                const SizedBox(height: 28),
                _seccionCodigo(),
                const SizedBox(height: 28),
                _seccionPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Check your email',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textoS,
            ),
            children: [
              const TextSpan(text: 'We sent a 6-digit code to '),
              TextSpan(
                text: widget.correo,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.texto,
                ),
              ),
              const TextSpan(text: '. Enter it below to continue.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _seccionCodigo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _etiqueta('Verification code'),
                const Spacer(),
                if (_verificado)
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppColors.verde,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.verde,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            CodigoInput(
              habilitado: !_verificado,
              onCambio: (codigo) => setState(() => _codigo = codigo),
              onCompleto: (_) {},
            ),
            const SizedBox(height: 16),
            if (!_verificado) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Deshabilitado hasta tener los 6 dígitos: un botón que no
                  // puede funcionar no debe verse pulsable.
                  onPressed: _codigoCompleto ? _verificar : null,
                  child: const Text(
                    'Verify code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: _reenviarCodigo,
                  child: const Text(
                    "Didn't get the code? Resend",
                    style: TextStyle(color: AppColors.textoS),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _seccionPassword() {
    // Antes de verificar, la sección se ve atenuada y no recibe toques: deja
    // claro que existe y qué falta para llegar a ella.
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: _verificado ? 1 : 0.4,
      child: IgnorePointer(
        ignoring: !_verificado,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _etiqueta('New password'),
                const SizedBox(height: 12),
                _campoPassword(
                  controller: _passwordController,
                  hint: 'Enter your new password',
                  validator: _validarPassword,
                  oculta: _ocultaPassword,
                  onToggle: () =>
                      setState(() => _ocultaPassword = !_ocultaPassword),
                ),
                const SizedBox(height: 20),
                _etiqueta('Repeat password'),
                const SizedBox(height: 12),
                _campoPassword(
                  controller: _repetirController,
                  hint: 'Repeat your new password',
                  validator: _validarRepetir,
                  oculta: _ocultaRepetir,
                  onToggle: () =>
                      setState(() => _ocultaRepetir = !_ocultaRepetir),
                  onSubmit: _cambiarPassword,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verificado ? _cambiarPassword : null,
                    child: const Text(
                      'Change password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoPassword({
    required TextEditingController controller,
    required String hint,
    required FormFieldValidator<String> validator,
    required bool oculta,
    required VoidCallback onToggle,
    VoidCallback? onSubmit,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: oculta,
      textInputAction: onSubmit == null
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) => onSubmit?.call(),
      style: const TextStyle(color: AppColors.texto),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            oculta ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textoS,
          ),
          tooltip: oculta ? 'Show password' : 'Hide password',
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _etiqueta(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.texto,
      ),
    );
  }
}
