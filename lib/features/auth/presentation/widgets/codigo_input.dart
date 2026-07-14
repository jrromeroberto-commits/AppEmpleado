import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class CodigoInput extends StatefulWidget {
  const CodigoInput({
    super.key,
    required this.onCambio,
    required this.onCompleto,
    this.habilitado = true,
  });

  /// Se llama en cada cambio con el código completo hasta el momento.
  final ValueChanged<String> onCambio;

  /// Se llama cuando se han escrito los 6 dígitos.
  final ValueChanged<String> onCompleto;

  final bool habilitado;

  static const largo = 6;

  @override
  State<CodigoInput> createState() => _CodigoInputState();
}

class _CodigoInputState extends State<CodigoInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focos;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      CodigoInput.largo,
      (_) => TextEditingController(),
    );
    _focos = List.generate(CodigoInput.largo, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focos) {
      f.dispose();
    }
    super.dispose();
  }

  String get _codigo => _controllers.map((c) => c.text).join();

  void _alEscribir(int indice, String valor) {
    if (valor.isNotEmpty && indice < CodigoInput.largo - 1) {
      _focos[indice + 1].requestFocus();
    }

    final codigo = _codigo;
    widget.onCambio(codigo);

    if (codigo.length == CodigoInput.largo) {
      _focos[indice].unfocus();
      widget.onCompleto(codigo);
    }
    setState(() {});
  }

  /// Borrar en una casilla vacía debe saltar a la anterior y borrar allí.
  void _alPresionarTecla(int indice, KeyEvent evento) {
    final esBorrar =
        evento is KeyDownEvent &&
        evento.logicalKey == LogicalKeyboardKey.backspace;

    if (esBorrar && _controllers[indice].text.isEmpty && indice > 0) {
      _controllers[indice - 1].clear();
      _focos[indice - 1].requestFocus();
      widget.onCambio(_codigo);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Las casillas se reparten el ancho disponible en vez de tener un ancho
    // fijo: con 6 casillas fijas se desbordaba en pantallas estrechas.
    return Row(
      children: List.generate(CodigoInput.largo, (i) {
        final primera = i == 0;
        final ultima = i == CodigoInput.largo - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: primera ? 0 : 4,
              right: ultima ? 0 : 4,
            ),
            child: SizedBox(height: 58, child: _casilla(i)),
          ),
        );
      }),
    );
  }

  Widget _casilla(int i) {
    final lleno = _controllers[i].text.isNotEmpty;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (evento) => _alPresionarTecla(i, evento),
      child: TextField(
        controller: _controllers[i],
        focusNode: _focos[i],
        enabled: widget.habilitado,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (valor) => _alEscribir(i, valor),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.texto,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: AppColors.campo,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: lleno ? AppColors.primary : AppColors.borde,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: lleno ? AppColors.primary : AppColors.borde,
            ),
          ),
        ),
      ),
    );
  }
}
