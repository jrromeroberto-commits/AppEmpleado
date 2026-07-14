import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/enlaces_empresa.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_page.dart';
import '../domain/informacion_personal.dart';
import 'cambiar_password_page.dart';
import 'informacion_personal_page.dart';
import 'widgets/fila_perfil.dart';
import 'widgets/perfil_foto.dart';
import 'widgets/redes_sociales_sheet.dart';
import 'widgets/seccion_perfil.dart';

/// Perfil del empleado: información personal, seguridad y about.
///
/// Maquetación: la información se mantiene solo en memoria; nada se persiste.
class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  InformacionPersonal? _informacion;
  bool _biometriaActiva = false;

  void _pendiente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: coming soon')),
    );
  }

  // ---- Información personal ----

  Future<void> _editarInformacion() async {
    final actualizada = await Navigator.of(context).push<InformacionPersonal>(
      MaterialPageRoute(
        builder: (_) => InformacionPersonalPage(informacion: _informacion),
      ),
    );

    if (actualizada == null || !mounted) return;

    setState(() => _informacion = actualizada);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  // ---- About ----

  Future<void> _abrirTerminos() async {
    final abierto = await launchUrl(
      Uri.parse(EnlacesEmpresa.terminos),
      mode: LaunchMode.externalApplication,
    );

    if (abierto || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the link')),
    );
  }

  Future<void> _compartirApp() async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Runway 7 Club — track your attendance and stay connected '
            'with HR. Download the app!',
        subject: 'Runway 7 Club',
      ),
    );
  }

  // ---- Seguridad ----

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
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

  /// La foto solo se muestra: se cambia dentro de "Personal information".
  Widget _cabecera() {
    final info = _informacion;

    return Column(
      children: [
        PerfilFoto(foto: info?.foto),
        if (info != null) ...[
          const SizedBox(height: 14),
          Text(
            info.nombreCompleto,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            info.cargo,
            style: const TextStyle(fontSize: 14, color: AppColors.primary),
          ),
        ],
      ],
    );
  }


  Widget _seccionInformacion() {
    return SeccionPerfil(
      titulo: 'Profile',
      icono: Icons.badge_outlined,
      children: [
        FilaAccion(
          icono: Icons.person_outline,
          titulo: 'Personal information',
          subtitulo: _informacion == null
              ? 'Complete your details'
              : 'Name, birthday, area and position',
          onTap: _editarInformacion,
          esUltima: true,
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
          subtitulo: 'Follow Runway 7 Fashion',
          onTap: () => RedesSocialesSheet.mostrar(context),
        ),
        FilaAccion(
          icono: Icons.star_outline,
          titulo: 'Rate the app',
          subtitulo: 'Tell us what you think',
          onTap: () => _pendiente('Rate the app'),
        ),
        FilaAccion(
          icono: Icons.ios_share,
          titulo: 'Share the app',
          subtitulo: 'Invite your teammates',
          onTap: _compartirApp,
        ),
        FilaAccion(
          icono: Icons.description_outlined,
          titulo: 'Terms and Conditions',
          onTap: _abrirTerminos,
          esUltima: true,
          trailing: const Icon(
            Icons.open_in_new,
            size: 18,
            color: AppColors.textoS,
          ),
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
