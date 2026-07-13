import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/empleado_shell.dart';
import '../domain/tipo_documento.dart';
import 'widgets/login_encabezado.dart';
import 'widgets/login_pie.dart';
import 'widgets/recuperar_password_sheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 
  static const _altoCampo = 60.0;

  final _formKey = GlobalKey<FormState>();
  final _documentoController = TextEditingController();
  final _passwordController = TextEditingController();

  TipoDocumento _tipo = TipoDocumento.dni;
  bool _oculta = true;

  @override
  void dispose() {
    _documentoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validarDocumento(String? valor) {
    return _tipo.validar(valor?.trim() ?? '');
  }

  void _cambiarTipo(TipoDocumento nuevo) {
    if (nuevo == _tipo) return;

    setState(() {
      _tipo = nuevo;
      // El número anterior pertenece al otro documento y su largo ya no aplica.
      _documentoController.clear();
    });
  }

  String? _validarPassword(String? valor) {
    if ((valor ?? '').isEmpty) {
      return 'Enter your password';
    }
    return null;
  }

  void _ingresar() {
    if (!_formKey.currentState!.validate()) return;

    // TODO(backend): autenticar contra la API y decidir el destino según el rol.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const EmpleadoShell()),
    );
  }

  void _olvidePassword() {
    RecuperarPasswordSheet.mostrar(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        const LoginEncabezado(
                          subtitulo: 'Enter your credentials to continue',
                        ),
                        const SizedBox(height: 32),
                        _tarjetaFormulario(),
                        const Spacer(flex: 3),
                        const LoginPie(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tarjetaFormulario() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _etiqueta('Identity document'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _selectorTipo(),
                  const SizedBox(width: 10),
                  Expanded(child: _campoDocumento()),
                ],
              ),
              const SizedBox(height: 20),
              _etiqueta('Password'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                validator: _validarPassword,
                obscureText: _oculta,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _ingresar(),
                autofillHints: const [AutofillHints.password],
                style: const TextStyle(color: AppColors.texto),
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _oculta
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textoS,
                    ),
                    tooltip: _oculta
                        ? 'Show password'
                        : 'Hide password',
                    onPressed: () => setState(() => _oculta = !_oculta),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _ingresar,
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: _olvidePassword,
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(color: AppColors.textoS),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Selector de tipo de documento (izquierda de la fila).
  ///
  /// Replica el estilo del campo de texto (fondo, borde y radio) para que
  /// ambos se lean como una sola pieza.
  Widget _selectorTipo() {
    return Container(
      height: _altoCampo,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.fondo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borde),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TipoDocumento>(
          value: _tipo,
          onChanged: (nuevo) {
            if (nuevo != null) _cambiarTipo(nuevo);
          },
          dropdownColor: AppColors.tarjeta,
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textoS,
            size: 20,
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.texto,
          ),
          items: TipoDocumento.values.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Text(tipo.etiqueta),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Campo del número de documento (derecha de la fila).
  Widget _campoDocumento() {
    return TextFormField(
      controller: _documentoController,
      validator: _validarDocumento,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      // Ambos documentos son numéricos: se bloquea cualquier otro carácter en
      // vez de dejar escribirlo y luego rechazarlo. El largo máximo depende
      // del tipo seleccionado.
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_tipo.largoMax),
      ],
      style: const TextStyle(color: AppColors.texto),
      decoration: InputDecoration(
        hintText: 'Numbers',
        prefixIcon: const Icon(
          Icons.badge_outlined,
          color: AppColors.primary,
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
