import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Ilustración de la primera página: reconocimiento facial.
///
/// Se dibuja con widgets (no es una imagen) para que herede los colores del
/// tema y se vea nítida en cualquier densidad de pantalla.
class OnboardingBienvenida extends StatelessWidget {
  const OnboardingBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _rostroEscaneado(),
              const SizedBox(width: 24),
              _ondas(),
              const SizedBox(width: 24),
              _telefonoDesbloqueado(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _garantias(),
      ],
    );
  }

  /// Tarjeta con las dos garantías de la app: seguridad y fiabilidad.
  Widget _garantias() {
    return Card(
      color: AppColors.superficie,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: AppColors.bordeOscuro),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _garantia(
                  icono: Icons.lock_outline,
                  titulo: 'Secure',
                  detalle: 'Your information is protected',
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.bordeOscuro,
              ),
              Expanded(
                child: _garantia(
                  icono: Icons.schedule,
                  titulo: 'Reliable',
                  detalle: 'Accurate records in real time',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _garantia({
    required IconData icono,
    required String titulo,
    required String detalle,
  }) {
    return Column(
      children: [
        Icon(icono, size: 30, color: AppColors.primary),
        const SizedBox(height: 10),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textoClaro,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            detalle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: AppColors.textoClaroS,
            ),
          ),
        ),
      ],
    );
  }

  /// Rostro dentro de las esquinas de un marco de escaneo.
  Widget _rostroEscaneado() {
    return SizedBox(
      width: 120,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.face_outlined,
            size: 78,
            color: AppColors.primary,
          ),
          ..._esquinas(),
        ],
      ),
    );
  }

  List<Widget> _esquinas() {
    const grosor = BorderSide(color: AppColors.primary, width: 3);
    final config = <Alignment, Border>{
      Alignment.topLeft: const Border(left: grosor, top: grosor),
      Alignment.topRight: const Border(right: grosor, top: grosor),
      Alignment.bottomLeft: const Border(left: grosor, bottom: grosor),
      Alignment.bottomRight: const Border(right: grosor, bottom: grosor),
    };

    return config.entries.map((e) {
      return Align(
        alignment: e.key,
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(border: e.value),
        ),
      );
    }).toList();
  }

  /// Puntos que representan la señal viajando del rostro al teléfono.
  Widget _ondas() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (fila) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: List.generate(4, (col) {
              // Las filas de arriba y abajo se acortan para dar forma de cono.
              final visible = fila == 1 || col >= fila.abs();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: visible
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.25),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  /// Teléfono con candado abierto y check: acceso concedido.
  Widget _telefonoDesbloqueado() {
    return Container(
      width: 78,
      height: 140,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textoClaroS, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_open_outlined, size: 30, color: AppColors.primary),
          SizedBox(height: 14),
          Icon(Icons.check_circle_outline, size: 30, color: AppColors.primary),
        ],
      ),
    );
  }
}
