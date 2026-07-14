import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Una red social del perfil.
class _Red {
  const _Red({required this.nombre, required this.icono, required this.hint});

  final String nombre;
  final IconData icono;
  final String hint;
}

/// Hoja inferior para añadir los perfiles de redes sociales.
///
/// Se abre con [mostrar]. Maquetación: los valores aún no se guardan.
class RedesSocialesSheet extends StatefulWidget {
  const RedesSocialesSheet({super.key});

  static Future<void> mostrar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.tarjeta,
      // La hoja crece con el contenido y sube con el teclado.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const RedesSocialesSheet(),
    );
  }

  @override
  State<RedesSocialesSheet> createState() => _RedesSocialesSheetState();
}

class _RedesSocialesSheetState extends State<RedesSocialesSheet> {
  static const _redes = <_Red>[
    _Red(
      nombre: 'Instagram',
      icono: Icons.camera_alt_outlined,
      hint: '@username',
    ),
    _Red(
      nombre: 'LinkedIn',
      icono: Icons.work_outline,
      hint: 'linkedin.com/in/username',
    ),
    _Red(
      nombre: 'X (Twitter)',
      icono: Icons.alternate_email,
      hint: '@username',
    ),
    _Red(
      nombre: 'Facebook',
      icono: Icons.facebook_outlined,
      hint: 'facebook.com/username',
    ),
    _Red(
      nombre: 'TikTok',
      icono: Icons.music_note_outlined,
      hint: '@username',
    ),
  ];

  late final Map<String, TextEditingController> _controllers = {
    for (final red in _redes) red.nombre: TextEditingController(),
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _guardar() {
    // TODO(backend): guardar las redes sociales del perfil.
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Social networks saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaTeclado = MediaQuery.viewInsetsOf(context).bottom;
    final alturaMaxima = MediaQuery.sizeOf(context).height * 0.85;

    return Padding(
      padding: EdgeInsets.only(bottom: alturaTeclado),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: alturaMaxima),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              _asa(),
              const SizedBox(height: 20),
              _encabezado(),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      for (final red in _redes) ...[
                        _campo(red),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _guardar,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _encabezado() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.share_outlined, size: 24, color: AppColors.primary),
              SizedBox(width: 10),
              Text(
                'Social networks',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texto,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Add the profiles you want to share with your team. '
            'All fields are optional.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textoS,
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo(_Red red) {
    return TextFormField(
      controller: _controllers[red.nombre],
      style: const TextStyle(color: AppColors.texto),
      decoration: InputDecoration(
        labelText: red.nombre,
        labelStyle: const TextStyle(color: AppColors.textoS),
        hintText: red.hint,
        prefixIcon: Icon(red.icono, color: AppColors.primary),
      ),
    );
  }

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
