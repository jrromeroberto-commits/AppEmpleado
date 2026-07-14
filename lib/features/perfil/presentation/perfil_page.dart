import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_page.dart';
import '../domain/genero.dart';
import 'cambiar_password_page.dart';
import 'widgets/campo_perfil.dart';
import 'widgets/fila_perfil.dart';
import 'widgets/perfil_foto.dart';
import 'widgets/redes_sociales_sheet.dart';
import 'widgets/seccion_perfil.dart';

/// Perfil del empleado: información personal, seguridad y about.
///
/// Maquetación: los campos arrancan vacíos y nada se persiste todavía.
class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _nacimientoController = TextEditingController();
  final _edadController = TextEditingController();
  final _correoController = TextEditingController();
  final _areaController = TextEditingController();
  final _cargoController = TextEditingController();

  Genero? _genero;
  DateTime? _nacimiento;
  bool _biometriaActiva = false;

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

  void _pendiente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: coming soon')),
    );
  }

  // ---- Información personal ----

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
      _nacimientoController.text = DateFormat(
        'dd MMM yyyy',
        'en_US',
      ).format(fecha);
      // La edad se deriva de la fecha: si el usuario pudiera escribir ambas,
      // podrían contradecirse.
      _edadController.text = '${_calcularEdad(fecha)}';
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

  void _guardarInformacion() {
    if (!_formKey.currentState!.validate()) return;

    if (_genero == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your gender')),
      );
      return;
    }

    // TODO(backend): enviar la información del perfil a la API.
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
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
                // TODO(foto): abrir la cámara con image_picker.
                _pendiente('Camera');
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
                // TODO(foto): abrir la galería con image_picker.
                _pendiente('Gallery');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _cambiarPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CambiarPasswordPage()),
    );
  }

  Future<void> _cerrarSesion() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.tarjeta,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Sign out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
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
              'Sign out',
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

    // TODO(backend): invalidar el token en el servidor y borrarlo del
    // almacenamiento seguro.

    // Se vuelve al login descartando toda la pila: si quedara alguna pantalla
    // detrás, el botón "atrás" devolvería al usuario a la sesión cerrada.
    // Tampoco se pasa por el onboarding: ya lo vio al instalar la app.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (ruta) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _cabecera(),
          const SizedBox(height: 28),
          _seccionInformacion(),
          const SizedBox(height: 24),
          _seccionSeguridad(),
          const SizedBox(height: 24),
          _seccionAbout(),
          const SizedBox(height: 24),
          _botonCerrarSesion(),
        ],
      ),
    );
  }

  Widget _cabecera() {
    return Column(
      children: [
        PerfilFoto(onCambiarFoto: _cambiarFoto),
        const SizedBox(height: 14),
        TextButton(
          onPressed: _cambiarFoto,
          child: const Text(
            'Add photo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _seccionInformacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Personal information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.texto,
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                    // La fecha necesita más ancho que la edad (dos dígitos).
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
                  // El correo va a ancho completo: partido en dos se leería mal.
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
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _guardarInformacion,
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
      ],
    );
  }

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

  Widget _seccionSeguridad() {
    return SeccionPerfil(
      titulo: 'Security',
      icono: Icons.lock_outline,
      children: [
        FilaAccion(
          icono: Icons.key_outlined,
          titulo: 'Change password',
          subtitulo: 'Update your access password',
          onTap: _cambiarPassword,
        ),
        FilaAccion(
          icono: Icons.fingerprint,
          titulo: 'Biometric login',
          subtitulo: 'Use fingerprint or face to sign in',
          esUltima: true,
          // El switch ya lleva la acción: un onTap encima duplicaría el gesto.
          trailing: Switch(
            value: _biometriaActiva,
            activeThumbColor: AppColors.texto,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.textoS,
            inactiveTrackColor: AppColors.borde,
            onChanged: (valor) {
              // TODO(auth): registrar/borrar la huella con local_auth.
              setState(() => _biometriaActiva = valor);
            },
          ),
        ),
      ],
    );
  }

  Widget _seccionAbout() {
    return SeccionPerfil(
      titulo: 'About',
      icono: Icons.info_outline,
      children: [
        FilaAccion(
          icono: Icons.share_outlined,
          titulo: 'Social networks',
          subtitulo: 'Add the profiles you want to share',
          onTap: () => RedesSocialesSheet.mostrar(context),
        ),
        FilaAccion(
          icono: Icons.star_outline,
          titulo: 'Rate the app',
          subtitulo: 'Tell us what you think',
          onTap: () => _pendiente('Rate the app'),
        ),
        FilaAccion(
          icono: Icons.help_outline,
          titulo: 'Help and support',
          onTap: () => _pendiente('Help and support'),
          esUltima: true,
        ),
      ],
    );
  }

  Widget _botonCerrarSesion() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FilaAccion(
          icono: Icons.logout,
          titulo: 'Sign out',
          destructiva: true,
          esUltima: true,
          onTap: _cerrarSesion,
          trailing: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
