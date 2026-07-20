import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../asistencia/data/mock_asistencia.dart';
import '../../perfil/presentation/widgets/campo_perfil.dart';
import '../domain/justificacion.dart';

/// Formulario para justificar una tardanza, falta o salida anticipada.
///
/// Maquetación: no hay backend.
class NuevaJustificacionPage extends StatefulWidget {
  const NuevaJustificacionPage({super.key, this.fecha, this.tipo});

  /// Día que se justifica. Viene puesto cuando se llega desde el calendario o
  /// la tabla de marcas; es `null` si se abre desde el botón general.
  final DateTime? fecha;

  /// Tipo deducido del estado del día, cuando se conoce.
  final TipoJustificacion? tipo;

  @override
  State<NuevaJustificacionPage> createState() => _NuevaJustificacionPageState();
}

class _NuevaJustificacionPageState extends State<NuevaJustificacionPage> {
  static const _maxPruebas = 5;
  static const _minDescripcion = 20;

  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _fechaController = TextEditingController();

  late TipoJustificacion? _tipo = widget.tipo;
  late DateTime? _fecha = widget.fecha;
  MotivoJustificacion? _motivo;
  final _pruebas = <File>[];

  /// Se llegó desde un día concreto: la fecha no se toca.
  bool get _fechaFijada => widget.fecha != null;

  @override
  void initState() {
    super.initState();
    final fecha = _fecha;
    if (fecha != null) _pintarFecha(fecha);
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  void _pintarFecha(DateTime fecha) {
    _fechaController.text = DateFormat('EEE dd MMM yyyy', 'en_US').format(fecha);
  }

  Future<void> _elegirFecha() async {
    final hoy = MockAsistencia.hoy;
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      // Solo se justifica el pasado: un día que aún no ocurrió no tiene falta.
      firstDate: DateTime(hoy.year, hoy.month - 3),
      lastDate: hoy,
      helpText: 'Select the day to justify',
    );

    if (fecha == null || !mounted) return;

    setState(() {
      _fecha = fecha;
      _pintarFecha(fecha);
    });
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

      setState(() => _pruebas.addAll(elegidas.map((x) => File(x.path))));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the gallery')),
      );
    }
  }

  String? _validarFecha(String? valor) {
    if ((valor ?? '').isEmpty) return 'Select the day to justify';
    return null;
  }

  String? _validarDescripcion(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Explain what happened';
    if (texto.length < _minDescripcion) {
      return 'Please give at least $_minDescripcion characters of detail';
    }
    return null;
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;

    if (_tipo == null) {
      _avisar('Select what you are justifying');
      return;
    }
    if (_motivo == null) {
      _avisar('Select a reason');
      return;
    }

    // TODO(backend): enviar la justificación (con sus adjuntos) a la API.
    Navigator.of(context).pop(true);
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New justification')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _selectorTipo(),
                        const SizedBox(height: 20),
                        _campoFecha(),
                        const SizedBox(height: 20),
                        _selectorMotivo(),
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
                      'Send justification',
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

  Widget _selectorTipo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _etiqueta('What are you justifying?'),
        const SizedBox(height: 8),
        DropdownButtonFormField<TipoJustificacion>(
          initialValue: _tipo,
          onChanged: (valor) => setState(() => _tipo = valor),
          dropdownColor: AppColors.tarjeta,
          borderRadius: BorderRadius.circular(14),
          isExpanded: true,
          style: const TextStyle(fontSize: 15, color: AppColors.texto),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textoS),
          decoration: const InputDecoration(
            hintText: 'Select',
            prefixIcon: Icon(Icons.event_busy_outlined, color: AppColors.primary),
          ),
          items: TipoJustificacion.values.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Text(tipo.etiqueta, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _campoFecha() {
    return CampoPerfil(
      etiqueta: 'Day',
      icono: Icons.calendar_today_outlined,
      hint: 'Select the day',
      controller: _fechaController,
      validator: _validarFecha,
      soloLectura: true,
      // Al llegar desde un día concreto la fecha ya es correcta: dejar
      // cambiarla solo invitaría a justificar el día equivocado.
      onTap: _fechaFijada ? null : _elegirFecha,
      textoAyuda: _fechaFijada ? 'Taken from the day you selected' : null,
    );
  }

  Widget _selectorMotivo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _etiqueta('Reason'),
        const SizedBox(height: 8),
        DropdownButtonFormField<MotivoJustificacion>(
          initialValue: _motivo,
          onChanged: (valor) => setState(() => _motivo = valor),
          dropdownColor: AppColors.tarjeta,
          borderRadius: BorderRadius.circular(14),
          isExpanded: true,
          style: const TextStyle(fontSize: 15, color: AppColors.texto),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textoS),
          decoration: const InputDecoration(
            hintText: 'Select a reason',
            prefixIcon: Icon(Icons.help_outline, color: AppColors.primary),
          ),
          items: MotivoJustificacion.values.map((motivo) {
            return DropdownMenuItem(
              value: motivo,
              child: Text(motivo.etiqueta, overflow: TextOverflow.ellipsis),
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
        _etiqueta('Description'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descripcionController,
          validator: _validarDescripcion,
          maxLines: 5,
          maxLength: 500,
          inputFormatters: [LengthLimitingTextInputFormatter(500)],
          style: const TextStyle(color: AppColors.texto),
          decoration: const InputDecoration(
            hintText: 'Explain what happened.',
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
            _etiqueta('Evidence'),
            const SizedBox(width: 8),
            const Text(
              'Optional',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textoS,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Attach a medical certificate or any proof that supports your case.',
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
                    ? 'Attach evidence'
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
          child: Image.file(prueba, width: 78, height: 78, fit: BoxFit.cover),
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
                color: AppColors.textoClaro,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _etiqueta(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.texto,
      ),
    );
  }
}
