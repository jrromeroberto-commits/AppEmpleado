import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AnilloTardanzas extends StatelessWidget {
  const AnilloTardanzas({
    super.key,
    required this.porcentaje,
    this.lado = 150,
  });

  /// Valor entre 0 y 1.
  final double porcentaje;
  final double lado;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: lado,
      height: lado,
      child: CustomPaint(
        painter: _AnilloPainter(porcentaje: porcentaje.clamp(0, 1)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(porcentaje * 100).round()}%',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texto,
                ),
              ),
              const Text(
                'Late arrivals',
                style: TextStyle(fontSize: 13, color: AppColors.textoS),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnilloPainter extends CustomPainter {
  const _AnilloPainter({required this.porcentaje});

  final double porcentaje;

  static const _grosor = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = (size.width - _grosor) / 2;
    final rect = Rect.fromCircle(center: centro, radius: radio);

    // Arranca arriba (12 en punto) y avanza en sentido horario.
    const inicio = -math.pi / 2;
    final barrido = 2 * math.pi * porcentaje;

    final pista = Paint()
      ..color = AppColors.borde
      ..style = PaintingStyle.stroke
      ..strokeWidth = _grosor
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, inicio, 2 * math.pi, false, pista);

    if (porcentaje == 0) return;

    // Resplandor: el mismo arco desenfocado por debajo del trazo nítido.
    final resplandor = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _grosor
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(rect, inicio, barrido, false, resplandor);

    final progreso = Paint()
      ..shader = const SweepGradient(
        colors: [AppColors.rojobot, AppColors.primary],
        startAngle: 0,
        endAngle: math.pi * 2,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _grosor
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, inicio, barrido, false, progreso);
  }

  @override
  bool shouldRepaint(_AnilloPainter oldDelegate) =>
      oldDelegate.porcentaje != porcentaje;
}
