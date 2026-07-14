import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
class CambiarPasswordPage extends StatefulWidget {
  const CambiarPasswordPage({super.key});

  @override
  State<CambiarPasswordPage> createState() => _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _actualController = TextEditingController();
  final _nuevaController = TextEditingController();
  final _repetirController = TextEditingController();

  bool _ocultaActual = true;
  bool _ocultaNueva = true;
  bool _ocultaRepetir = true;

  @override
  void dispose() {
    _actualController.dispose();
    _nuevaController.dispose();
    _repetirController.dispose();
    super.dispose();
  }

  String? _validarActual(String? valor) {
    if ((valor ?? '').isEmpty) return 'Enter your current password';
    return null;
  }

  String? _validarNueva(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) return 'Enter your new password';
    if (texto.length < 8) return 'Password must be at least 8 characters';
    if (texto == _actualController.text) {
      return 'The new password must be different';
    }
    return null;
  }

  String? _validarRepetir(String? valor) {
    if ((valor ?? '').isEmpty) return 'Repeat your new password';
    if (valor != _nuevaController.text) return 'Passwords do not match';
    return null;
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    // TODO(backend): enviar la nueva contraseña a la API.
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a strong password you have not used before.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textoFondoS,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _etiqueta('Current password'),
                        const SizedBox(height: 12),
                        _campo(
                          controller: _actualController,
                          hint: 'Enter your current password',
                          validator: _validarActual,
                          oculta: _ocultaActual,
                          onToggle: () =>
                              setState(() => _ocultaActual = !_ocultaActual),
                        ),
                        const SizedBox(height: 20),
                        _etiqueta('New password'),
                        const SizedBox(height: 12),
                        _campo(
                          controller: _nuevaController,
                          hint: 'Enter your new password',
                          validator: _validarNueva,
                          oculta: _ocultaNueva,
                          onToggle: () =>
                              setState(() => _ocultaNueva = !_ocultaNueva),
                        ),
                        const SizedBox(height: 20),
                        _etiqueta('Repeat password'),
                        const SizedBox(height: 12),
                        _campo(
                          controller: _repetirController,
                          hint: 'Repeat your new password',
                          validator: _validarRepetir,
                          oculta: _ocultaRepetir,
                          onToggle: () =>
                              setState(() => _ocultaRepetir = !_ocultaRepetir),
                          onSubmit: _guardar,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _guardar,
                            child: const Text(
                              'Save password',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo({
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
