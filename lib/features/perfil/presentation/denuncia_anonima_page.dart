import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/tipo_denuncia.dart';
import 'widgets/campo_perfil.dart';

class DenunciaAnonimaPage extends StatefulWidget {
  const DenunciaAnonimaPage({super.key});

  @override
  State<DenunciaAnonimaPage> createState() => _DenunciaAnonimaPageState();
}

class _DenunciaAnonimaPageState extends State<DenunciaAnonimaPage> {
  static const _maxPruebas = 5;
  static const _minDescripcion = 30;

  final _formKey = GlobalKey<FormState>();
  final _acusadoController = TextEditingController();
  final _descripcionController = TextEditingController();

  TipoDenuncia? _tipo;
  final _pruebas = <File>[];

  @override
  void dispose() {
    _acusadoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _agregarPrueba() async {
    if (_pruebas.length >= _maxPruebas) return;

    try {
      final elegidas = await ImagePicker().pickMultiImage(
        limit: _maxPruebas - _pruebas.length,
        maxWidth: 1600,
        imageQuality: 85,
      );

      if (elegidas.isEmpty || !mounted) return;

      setState(() {
        _pruebas.addAll(elegidas.map((x) => File(x.path)));
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the gallery')),
      );
    }
  }

  String? _validarAcusado(String? valor) {
    if ((valor ?? '').trim().isEmpty) {
      return "Enter the reported person's name";
    }
    return null;
  }

  String? _validarDescripcion(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Describe what happened';
    if (texto.length < _minDescripcion) {
      return 'Please give at least $_minDescripcion characters of detail';
    }
    return null;
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tipo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select the type of report')),
      );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.tarjeta,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Send report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
        content: const Text(
          'Your report will be sent anonymously. Your name will not be '
          'attached. Do you want to continue?',
          style: TextStyle(color: AppColors.textoS),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textoS),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Send',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    // TODO(backend): enviar la denuncia SIN ningún dato del denunciante.
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report sent anonymously')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anonymous report')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _avisoAnonimato(),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _selectorTipo(),
                        const SizedBox(height: 20),
                        CampoPerfil(
                          etiqueta: 'Reported person',
                          icono: Icons.person_outline,
                          hint: 'Full name of the reported person',
                          controller: _acusadoController,
                          validator: _validarAcusado,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 20),
                        _campoDescripcion(),
                        const SizedBox(height: 20),
                        _bloquePruebas(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _enviar,
                    child: const Text(
                      'Send report',
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

  /// Lo primero que ve el denunciante: que su identidad no se envía.
  Widget _avisoAnonimato() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            size: 26,
            color: AppColors.primary,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textoFondoS,
                ),
                children: [
                  TextSpan(
                    text: 'Your identity stays anonymous. ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoFondo,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Your name is never attached to this report. HR will '
                        'review it and act on it.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorTipo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type of report',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.texto,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TipoDenuncia>(
          initialValue: _tipo,
          onChanged: (valor) => setState(() => _tipo = valor),
          dropdownColor: AppColors.tarjeta,
          borderRadius: BorderRadius.circular(14),
          isExpanded: true,
          style: const TextStyle(fontSize: 15, color: AppColors.texto),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textoS),
          decoration: const InputDecoration(
            hintText: 'Select the type of report',
            prefixIcon: Icon(Icons.report_outlined, color: AppColors.primary),
          ),
          items: TipoDenuncia.values.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Text(tipo.etiqueta, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _campoDescripcion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.texto,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descripcionController,
          validator: _validarDescripcion,
          maxLines: 6,
          maxLength: 1000,
          inputFormatters: [LengthLimitingTextInputFormatter(1000)],
          style: const TextStyle(color: AppColors.texto),
          decoration: const InputDecoration(
            hintText:
                'Describe what happened: when, where, and who else was there.',
            alignLabelWithHint: true,
            counterStyle: TextStyle(color: AppColors.textoS),
          ),
        ),
      ],
    );
  }

  Widget _bloquePruebas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Evidence',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Optional',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textoS.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Attach screenshots or photos that support your report.',
          style: TextStyle(fontSize: 12, color: AppColors.textoS),
        ),
        const SizedBox(height: 12),
        if (_pruebas.isNotEmpty) ...[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final (i, prueba) in _pruebas.indexed) _miniatura(i, prueba),
            ],
          ),
          const SizedBox(height: 12),
        ],
        if (_pruebas.length < _maxPruebas)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _agregarPrueba,
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
              ),
              label: Text(
                _pruebas.isEmpty
                    ? 'Add screenshots'
                    : 'Add more (${_pruebas.length}/$_maxPruebas)',
              ),
            ),
          ),
      ],
    );
  }

  Widget _miniatura(int indice, File prueba) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            prueba,
            width: 78,
            height: 78,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: () => setState(() => _pruebas.removeAt(indice)),
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.negroSplash,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: AppColors.texto,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
