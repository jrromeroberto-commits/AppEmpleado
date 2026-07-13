import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.siguiente});

  /// Pantalla a la que se navega al terminar el splash.
  final Widget siguiente;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _duracionAnimacion = Duration(milliseconds: 1400);
  static const _duracionTotal = Duration(milliseconds: 2000);

  late final AnimationController _controller;
  late final Animation<double> _escala;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duracionAnimacion)
      ..forward();

    _escala = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _timer = Timer(_duracionTotal, _irASiguiente);
  }

  void _irASiguiente() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => widget.siguiente,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.negroSplash,
      body: Center(
        child: ScaleTransition(
          scale: _escala,
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}
