import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.fondo,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.texto,
      secondary: AppColors.rojobot,
      onSecondary: AppColors.texto,
      surface: AppColors.tarjeta,
      onSurface: AppColors.texto,
      error: AppColors.rojobot,
      onError: AppColors.texto,
      outline: AppColors.borde,
    ),

    cardTheme: CardThemeData(
      color: AppColors.tarjeta,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borde),
      ),
    ),

    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: AppColors.texto,
      displayColor: AppColors.texto,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.fondo,
      foregroundColor: AppColors.texto,
      elevation: 0,
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.tarjeta,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final seleccionado = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.w400,
          color: seleccionado ? AppColors.primary : AppColors.textoS,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final seleccionado = states.contains(WidgetState.selected);
        return IconThemeData(
          color: seleccionado ? AppColors.primary : AppColors.textoS,
        );
      }),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.rojobot,
        foregroundColor: AppColors.texto,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.borde,
      thickness: 1,
    ),
  );
}
