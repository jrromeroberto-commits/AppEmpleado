import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/dia_asistencia.dart';


extension EstadoDiaVisual on EstadoDia {
  IconData get icono => switch (this) {
    EstadoDia.aTiempo => Icons.check_circle_outline,
    EstadoDia.tarde => Icons.check_circle_outline,
    EstadoDia.falta => Icons.cancel_outlined,
    EstadoDia.pendiente => Icons.remove_circle_outline,
  };

  Color get color => switch (this) {
    EstadoDia.aTiempo => AppColors.verde,
    EstadoDia.tarde => AppColors.ambar,
    EstadoDia.falta => const Color.fromARGB(255, 255, 0, 0),
    EstadoDia.pendiente => AppColors.textoS,
  };
}
