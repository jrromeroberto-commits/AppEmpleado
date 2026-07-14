import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/genero.dart';
import '../domain/informacion_personal.dart';
import 'widgets/campo_perfil.dart';
import 'widgets/perfil_foto.dart';

class InformacionPersonalPage extends StatefulWidget {
  const InformacionPersonalPage({super.key, this.informacion});

  /// Datos actuales, si ya los había. `null` la primera vez.
  final InformacionPersonal? informacion;

  @override
  State<InformacionPersonalPage> createState() =>
      _InformacionPersonalPageState();
}

class _InformacionPersonalPageState extends State<InformacionPersonalPage> {
  final _formKey = GlobalKey<FormState>();

  late final _nombreController = TextEditingController(
    text: widget.informacion?.nombre,
  );
  late final _apellidoController = TextEditingController(
    text: widget.informacion?.apellido,
  );
  late final _correoController = TextEditingController(
    text: widget.informacion?.correo,
  );
  late final _areaController = TextEditingController(
    text: widget.informacion?.area,
  );
  late final _cargoController = TextEditingController(
    text: widget.informacion?.cargo,
  );

  final _nacimientoController = TextEditingController();
  final _edadController = TextEditingController();

  late Genero? _genero = widget.informacion?.genero;
  late DateTime? _nacimiento = widget.informacion?.nacimiento;
  late File? _foto = widget.informacion?.foto;

  @override
  void initState() {
    super.initState();
    final nacimiento = _nacimiento;
    if (nacimiento != null) _pintarNacimiento(nacimiento);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _nacimientoController.dispose();
    _edadController.dispose();
    _correoController.dispose();
    _areaController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  void _pintarNacimiento(DateTime fecha) {
    _nacimientoController.text = DateFormat('dd MMM yyyy', 'en_US').format(
      fecha,
    );
    _edadController.text = '${_calcularEdad(fecha)}';
  }

  // ---- Foto ----

  void _cambiarFoto() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.tarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borde,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Profile photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.primary,
              ),
              title: const Text(
                'Take a photo',
                style: TextStyle(color: AppColors.texto),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _elegirFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.primary,
              ),
              title: const Text(
                'Choose from gallery',
                style: TextStyle(color: AppColors.texto),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _elegirFoto(ImageSource.gallery);
              },
            ),
            if (_foto != null)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.primary,
                ),
                title: const Text(
                  'Remove photo',
                  style: TextStyle(color: AppColors.primary),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _foto = null);
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _elegirFoto(ImageSource origen) async {
    try {
      final elegida = await ImagePicker().pickImage(
        source: origen,
        // Se reduce antes de guardarla: una foto de cámara pesa varios MB y
        // aquí solo se muestra en un círculo pequeño.
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (elegida == null || !mounted) return;

      setState(() => _foto = File(elegida.path));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the photo')),
      );
    }
  }

  // ---- Campos ----

  Future<void> _elegirNacimiento() async {
    final ahora = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _nacimiento ?? DateTime(ahora.year - 25),
      firstDate: DateTime(ahora.year - 80),
      lastDate: DateTime(ahora.year - 16),
      helpText: 'Select your date of birth',
    );

    if (fecha == null || !mounted) return;

    setState(() {
      _nacimiento = fecha;
      _pintarNacimiento(fecha);
    });
  }

  int _calcularEdad(DateTime nacimiento) {
    final ahora = DateTime.now();
    var edad = ahora.year - nacimiento.year;
    final yaCumplio =
        ahora.month > nacimiento.month ||
        (ahora.month == nacimiento.month && ahora.day >= nacimiento.day);
    if (!yaCumplio) edad--;
    return edad;
  }

  String? _obligatorio(String? valor, String campo) {
    if ((valor ?? '').trim().isEmpty) return 'Enter your $campo';
    return null;
  }

  String? _validarCorreo(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Enter your email';
    final correoValido = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!correoValido.hasMatch(texto)) return 'Invalid email format';
    return null;
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final genero = _genero;
    final nacimiento = _nacimiento;

    if (genero == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your gender')),
      );
      return;
    }
    if (nacimiento == null) return;

    // TODO(backend): enviar la información del perfil a la API.
    Navigator.of(context).pop(
      InformacionPersonal(
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        nacimiento: nacimiento,
        genero: genero,
        correo: _correoController.text.trim(),
        area: _areaController.text.trim(),
        cargo: _cargoController.text.trim(),
        foto: _foto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal information')),
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
                      children: [
                        _bloqueFoto(),
                        const SizedBox(height: 20),
                        const Divider(height: 1, color: AppColors.borde),
                        const SizedBox(height: 20),
                        _fila(
                          izquierda: CampoPerfil(
                            etiqueta: 'First name',
                            icono: Icons.person_outline,
                            controller: _nombreController,
                            validator: (v) => _obligatorio(v, 'first name'),
                            keyboardType: TextInputType.name,
                          ),
                          derecha: CampoPerfil(
                            etiqueta: 'Last name',
                            icono: Icons.person_outline,
                            controller: _apellidoController,
                            validator: (v) => _obligatorio(v, 'last name'),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _fila(
                          // La fecha necesita más ancho que la edad.
                          flexIzquierda: 3,
                          flexDerecha: 2,
                          izquierda: CampoPerfil(
                            etiqueta: 'Date of birth',
                            icono: Icons.cake_outlined,
                            hint: 'Select date',
                            controller: _nacimientoController,
                            validator: (v) => _obligatorio(v, 'date of birth'),
                            soloLectura: true,
                            onTap: _elegirNacimiento,
                          ),
                          derecha: CampoPerfil(
                            etiqueta: 'Age',
                            icono: Icons.numbers,
                            hint: '—',
                            controller: _edadController,
                            soloLectura: true,
                            textoAyuda: 'Auto',
                          ),
                        ),
                        const SizedBox(height: 18),
                        _fila(
                          izquierda: _selectorGenero(),
                          derecha: CampoPerfil(
                            etiqueta: 'Area',
                            icono: Icons.apartment_outlined,
                            controller: _areaController,
                            validator: (v) => _obligatorio(v, 'area'),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // El correo va a ancho completo: partido en dos se
                        // leería mal.
                        CampoPerfil(
                          etiqueta: 'Email',
                          icono: Icons.mail_outline,
                          hint: 'Enter your email',
                          controller: _correoController,
                          validator: _validarCorreo,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
                        CampoPerfil(
                          etiqueta: 'Position',
                          icono: Icons.work_outline,
                          hint: 'Enter your position',
                          controller: _cargoController,
                          validator: (v) => _obligatorio(v, 'position'),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _guardar,
                    child: const Text(
                      'Save changes',
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

  /// La foto es la primera opción del formulario.
  Widget _bloqueFoto() {
    return Column(
      children: [
        PerfilFoto(foto: _foto, onCambiarFoto: _cambiarFoto),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _cambiarFoto,
          child: Text(
            _foto == null ? 'Add photo' : 'Change photo',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// Dos campos en una fila.
  ///
  /// Se alinean arriba: si uno muestra un error de validación crece hacia abajo,
  /// y sin esto el otro campo quedaría descuadrado.
  Widget _fila({
    required Widget izquierda,
    required Widget derecha,
    int flexIzquierda = 1,
    int flexDerecha = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: flexIzquierda, child: izquierda),
        const SizedBox(width: 12),
        Expanded(flex: flexDerecha, child: derecha),
      ],
    );
  }

  Widget _selectorGenero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.texto,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Genero>(
          initialValue: _genero,
          onChanged: (valor) => setState(() => _genero = valor),
          dropdownColor: AppColors.tarjeta,
          borderRadius: BorderRadius.circular(14),
          // A media columna, "Prefer not to say" no cabe: se recorta con
          // puntos suspensivos en vez de desbordar.
          isExpanded: true,
          style: const TextStyle(fontSize: 15, color: AppColors.texto),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textoS),
          decoration: const InputDecoration(
            hintText: 'Select',
            prefixIcon: Icon(Icons.wc_outlined, color: AppColors.primary),
          ),
          items: Genero.values.map((genero) {
            return DropdownMenuItem(
              value: genero,
              child: Text(genero.etiqueta, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ],
    );
  }
}
