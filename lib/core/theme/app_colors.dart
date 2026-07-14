import 'package:flutter/material.dart';

/// Paleta de la app.
///
/// El diseño es **claro**: fondo blanco, contenido sobre blanco, texto negro y
/// dorado para lo importante. Los tokens sin sufijo son los del contenido claro
/// (el caso por defecto).
///
/// Unas pocas superficies se mantienen **oscuras** —AppBar, barra de
/// navegación, tarjetas de HR y las pantallas de entrada (login, onboarding,
/// splash)— y usan los tokens con sufijo `Oscuro` / `Claro`.
class AppColors {
  AppColors._();

  // ---- Fondo de pantalla ----
  static const Color fondo = Color(0xFFFFFFFF);

  // ---- Acentos ----
  /// Dorado. Resalta lo importante: acciones, valores y palabras clave.
  static const Color primary = Color(0xFFD4AF37);
  static const Color rojobot = Color(0xFFD4AF37);
  static const Color verde = Color(0xFF2E9E57);
  static const Color ambar = Color(0xFFC98A00);
  static const Color rojo = Color(0xFFE5484D);

  // ---- Contenido claro (por defecto) ----
  /// Texto principal (negro sobre blanco).
  static const Color texto = Color(0xFF0A0A0A);

  /// Texto secundario (gris sobre blanco).
  static const Color textoS = Color(0xFF5F5F5F);

  /// Superficie de las tarjetas: blanca, se distingue por el borde.
  static const Color tarjeta = Color(0xFFFFFFFF);

  /// Relleno de campos y paneles internos.
  static const Color campo = Color(0xFFF4F4F4);

  /// Borde sutil sobre blanco.
  static const Color borde = Color(0xFFE4E4E4);

  // Alias de compatibilidad: antes distinguían "texto sobre el fondo blanco".
  // Ahora el texto por defecto ya es oscuro, así que apuntan a lo mismo.
  static const Color textoFondo = texto;
  static const Color textoFondoS = textoS;

  // ---- Superficies oscuras ----
  static const Color negroSplash = Color(0xFF000000);

  /// Fondo de AppBar, barra de navegación y tarjetas de HR.
  static const Color superficie = Color(0xFF0A0A0A);

  /// Relleno de campos dentro de superficies oscuras.
  static const Color campoOscuro = Color(0xFF161616);

  /// Borde sobre superficies oscuras.
  static const Color bordeOscuro = Color(0xFF262626);

  /// Texto sobre superficies oscuras.
  static const Color textoClaro = Color(0xFFFFFFFF);
  static const Color textoClaroS = Color(0xFFA0A0A0);
}
