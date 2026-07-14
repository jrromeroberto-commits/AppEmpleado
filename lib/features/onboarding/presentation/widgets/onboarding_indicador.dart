import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Puntos que indican la página actual del onboarding.
class OnboardingIndicador extends StatelessWidget {
  const OnboardingIndicador({
    super.key,
    required this.total,
    required this.actual,
  });

  final int total;
  final int actual;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final activo = i == actual;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: activo ? 10 : 8,
          height: activo ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: activo ? AppColors.primary : AppColors.bordeOscuro,
          ),
        );
      }),
    );
  }
}
