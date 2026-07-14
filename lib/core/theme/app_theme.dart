import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    // El diseño es claro: fondo blanco, contenido y texto oscuros. Solo el
    // AppBar y la barra de navegación se mantienen negros (definidos abajo).
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.fondo,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.negroSplash,
      secondary: AppColors.primary,
      onSecondary: AppColors.negroSplash,
      surface: AppColors.tarjeta,
      onSurface: AppColors.texto,
      error: AppColors.rojo,
      onError: AppColors.textoClaro,
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

    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: AppColors.texto,
      displayColor: AppColors.texto,
    ),

    // El AppBar se mantiene negro sobre el fondo blanco.
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.superficie,
      foregroundColor: AppColors.textoClaro,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    // La barra de navegación también negra.
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.superficie,
      indicatorColor: AppColors.primary.withValues(alpha: 0.18),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final seleccionado = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.w400,
          color: seleccionado ? AppColors.primary : AppColors.textoClaroS,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final seleccionado = states.contains(WidgetState.selected);
        return IconThemeData(
          color: seleccionado ? AppColors.primary : AppColors.textoClaroS,
        );
      }),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.rojobot,
        // Texto negro sobre el dorado.
        foregroundColor: AppColors.negroSplash,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.texto,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppColors.borde),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.campo,
      hintStyle: const TextStyle(color: AppColors.textoS),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borde),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.rojo),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.rojo, width: 1.5),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.borde,
      thickness: 1,
    ),
  );
}
