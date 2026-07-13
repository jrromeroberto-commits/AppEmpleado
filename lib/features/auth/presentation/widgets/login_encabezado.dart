import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_colors.dart';

class LoginEncabezado extends StatefulWidget {
  const LoginEncabezado({super.key, required this.subtitulo});

  final String subtitulo;

  @override
  State<LoginEncabezado> createState() => _LoginEncabezadoState();
}

class _LoginEncabezadoState extends State<LoginEncabezado> {
  static const _lado = 96.0;

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _cargarVideo();
  }

  Future<void> _cargarVideo() async {
    final controller = VideoPlayerController.asset(
      'assets/video/logo_splash.mp4',
    );

    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      // Se reproduce una sola vez al abrir la pantalla; al terminar queda
      // congelado en el último fotograma, que es el logo completo.
      await controller.setVolume(0);
      await controller.play();

      setState(() => _controller = controller);
    } catch (_) {
      // Sin video (plataforma sin soporte, asset ilegible...): queda el logo
      // estático como respaldo.
      await controller.dispose();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // El video tiene fondo negro y esquinas redondeadas, igual que el logo:
        // se recorta con el mismo radio para que el borde quede limpio.
        ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: SizedBox(
            width: _lado,
            height: _lado,
            child: _marca(),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Attendance Control',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.texto,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitulo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: AppColors.textoS),
        ),
      ],
    );
  }

  Widget _marca() {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return Image.asset(
        'assets/images/logo.png',
        filterQuality: FilterQuality.medium,
      );
    }

    // FittedBox + cover recorta el video al cuadrado sin deformarlo.
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}
