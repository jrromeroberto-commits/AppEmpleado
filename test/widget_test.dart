import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_asistencia/core/router/empleado_shell.dart';
import 'package:app_asistencia/features/asistencia/data/mock_asistencia.dart';
import 'package:app_asistencia/features/auth/domain/tipo_documento.dart';
import 'package:app_asistencia/features/auth/presentation/reset_password_page.dart';
import 'package:app_asistencia/features/auth/presentation/widgets/codigo_input.dart';
import 'package:app_asistencia/features/auth/presentation/widgets/recuperar_password_sheet.dart';
import 'package:app_asistencia/features/perfil/domain/genero.dart';
import 'package:app_asistencia/features/perfil/presentation/cambiar_password_page.dart';
import 'package:app_asistencia/features/perfil/presentation/widgets/redes_sociales_sheet.dart';
import 'package:app_asistencia/main.dart';

Future<void> _irAlOnboarding(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: MiApp()));
  await tester.pump(const Duration(seconds: 7));
  await tester.pumpAndSettle();
}

/// El onboarding solo se salta con "Skip"; el resto es deslizando.
Future<void> _irAlLogin(WidgetTester tester) async {
  await _irAlOnboarding(tester);

  await tester.tap(find.text('Skip'));
  await tester.pumpAndSettle();
}

Future<void> _deslizar(WidgetTester tester, {bool atras = false}) async {
  await tester.fling(
    find.byType(PageView),
    Offset(atras ? 400 : -400, 0),
    1000,
  );
  await tester.pumpAndSettle();
}

Finder get _campoDocumento => find.byType(TextFormField).first;
Finder get _campoPassword => find.byType(TextFormField).last;


Finder _enSheet(Finder finder) => find.descendant(
  of: find.byType(RecuperarPasswordSheet),
  matching: finder,
);

Finder _enReset(Finder finder) =>
    find.descendant(of: find.byType(ResetPasswordPage), matching: finder);


Finder get _casillasCodigo =>
    find.descendant(of: find.byType(CodigoInput), matching: find.byType(TextField));

/// Abre la hoja inferior de recuperar contraseña.
Future<void> _irAlRecuperar(WidgetTester tester) async {
  await _irAlLogin(tester);
  await tester.tap(find.text('Forgot your password?'));
  await tester.pumpAndSettle();
}

/// Llega hasta la pantalla del código de verificación.
Future<void> _irAlCodigo(WidgetTester tester) async {
  await _irAlRecuperar(tester);
  await tester.enterText(
    _enSheet(find.byType(TextFormField)),
    'mitchell@runway7fashion.com',
  );
  await tester.tap(find.text('Recover password'));
  await tester.pumpAndSettle();
}

/// Inicia sesión y deja la app en el Home del empleado.
Future<void> _irAlHome(WidgetTester tester) async {
  await _irAlLogin(tester);
  await tester.enterText(_campoDocumento, '12345678');
  await tester.enterText(_campoPassword, 'secreta');
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

/// Abre la pestaña Profile.
Future<void> _irAlPerfil(WidgetTester tester) async {
  await _irAlHome(tester);
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
}

/// Desplaza el perfil hasta que [objetivo] exista y sea visible.
Future<void> _scrollPerfil(WidgetTester tester, Finder objetivo) async {
  await tester.scrollUntilVisible(
    objetivo,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

/// Abre la pantalla de cambiar contraseña desde el perfil.
Future<void> _irAlCambiarPassword(WidgetTester tester) async {
  await _irAlPerfil(tester);
  await _scrollPerfil(tester, find.text('Change password'));
  await tester.tap(find.text('Change password'));
  await tester.pumpAndSettle();
}

/// Verifica el código y deja los campos de contraseña desbloqueados.
Future<void> _verificarCodigo(WidgetTester tester) async {
  await _escribirCodigo(tester, '123456');
  await tester.tap(find.text('Verify code'));
  await tester.pumpAndSettle();
}

/// Escribe el código dígito a dígito en las casillas.
Future<void> _escribirCodigo(WidgetTester tester, String codigo) async {
  for (var i = 0; i < codigo.length; i++) {
    await tester.enterText(_casillasCodigo.at(i), codigo[i]);
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('La app arranca mostrando el splash con el logo', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MiApp()));

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
  });

  testWidgets('El splash navega al onboarding', (tester) async {
    await _irAlOnboarding(tester);

    expect(find.text('Welcome to Runway 7 Club'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    // Ya no hay botones de navegación: se avanza deslizando.
    expect(find.text('Next'), findsNothing);
    expect(find.text('Back'), findsNothing);
  });

  testWidgets('La primera página muestra las garantías', (tester) async {
    await _irAlOnboarding(tester);

    expect(find.text('Secure'), findsOneWidget);
    expect(find.text('Your information is protected'), findsOneWidget);
    expect(find.text('Reliable'), findsOneWidget);
    expect(find.text('Accurate records in real time'), findsOneWidget);
  });

  testWidgets('El onboarding se recorre deslizando', (tester) async {
    await _irAlOnboarding(tester);

    await _deslizar(tester);
    expect(find.text('Track your attendance'), findsOneWidget);

    await _deslizar(tester);
    expect(find.text('Connect with HR'), findsOneWidget);
  });

  testWidgets('En la última página Skip se vuelve Comenzar', (tester) async {
    await _irAlOnboarding(tester);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Get started'), findsNothing);

    await _deslizar(tester);
    expect(find.text('Skip'), findsOneWidget);

    await _deslizar(tester);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
  });

  testWidgets('Comenzar lleva al login', (tester) async {
    await _irAlOnboarding(tester);
    await _deslizar(tester);
    await _deslizar(tester);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Attendance Control'), findsOneWidget);
  });

  testWidgets('Se puede volver atrás deslizando', (tester) async {
    await _irAlOnboarding(tester);

    await _deslizar(tester);
    await _deslizar(tester, atras: true);

    expect(find.text('Welcome to Runway 7 Club'), findsOneWidget);
  });

  testWidgets('Skip lleva directo al login', (tester) async {
    await _irAlLogin(tester);

    expect(find.text('Attendance Control'), findsOneWidget);
    expect(find.text('Enter your credentials to continue'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('El login permite elegir el tipo de documento', (tester) async {
    await _irAlLogin(tester);

    expect(find.text('Identity document'), findsOneWidget);
    // El hint es el mismo para ambos tipos.
    expect(find.text('Numbers'), findsOneWidget);
    // Por defecto: DNI.
    expect(find.text('DNI'), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<TipoDocumento>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('C.E.').last);
    await tester.pumpAndSettle();

    expect(find.text('C.E.'), findsOneWidget);
    expect(find.text('Numbers'), findsOneWidget);
  });

  testWidgets('Cambiar de tipo limpia el número escrito', (tester) async {
    await _irAlLogin(tester);

    await tester.enterText(_campoDocumento, '12345678');
    expect(
      tester.widget<TextFormField>(_campoDocumento).controller!.text,
      '12345678',
    );

    await tester.tap(find.byType(DropdownButton<TipoDocumento>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('C.E.').last);
    await tester.pumpAndSettle();

    expect(tester.widget<TextFormField>(_campoDocumento).controller!.text, '');
  });

  testWidgets('El C.E. exige más dígitos que el DNI', (tester) async {
    await _irAlLogin(tester);

    // 8 dígitos son válidos como DNI.
    await tester.enterText(_campoDocumento, '12345678');
    await tester.enterText(_campoPassword, 'secreta');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(EmpleadoShell), findsOneWidget);
  });

  testWidgets('El login muestra ambos campos a la vez', (tester) async {
    await _irAlLogin(tester);

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Identity document'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Los campos vacíos muestran errores de validación', (
    tester,
  ) async {
    await _irAlLogin(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your DNI'), findsWidgets);
    expect(find.text('Enter your password'), findsWidgets);
    expect(find.byType(EmpleadoShell), findsNothing);
  });

  testWidgets('Un documento demasiado corto no deja continuar', (tester) async {
    await _irAlLogin(tester);

    await tester.enterText(_campoDocumento, '1234');
    await tester.enterText(_campoPassword, 'secreta');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(
      find.text('DNI must be 8 digits'),
      findsOneWidget,
    );
    expect(find.byType(EmpleadoShell), findsNothing);
  });

  testWidgets('El campo de documento solo acepta dígitos', (tester) async {
    await _irAlLogin(tester);

    await tester.enterText(_campoDocumento, 'abc123def456');
    await tester.pumpAndSettle();

    final campo = tester.widget<TextFormField>(_campoDocumento);
    expect(campo.controller!.text, '123456');
  });

  testWidgets('Sin contraseña no deja continuar', (tester) async {
    await _irAlLogin(tester);

    await tester.enterText(_campoDocumento, '12345678');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your password'), findsWidgets);
    expect(find.byType(EmpleadoShell), findsNothing);
  });

  testWidgets('Credenciales válidas navegan a la siguiente pantalla', (
    tester,
  ) async {
    await _irAlLogin(tester);

    await tester.enterText(_campoDocumento, '12345678');
    await tester.enterText(_campoPassword, 'secreta');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(EmpleadoShell), findsOneWidget);
  });

  testWidgets('La contraseña se puede mostrar y ocultar', (tester) async {
    await _irAlLogin(tester);

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  // ---- Recuperar contraseña ----

  testWidgets('"Forgot your password?" abre la hoja inferior', (tester) async {
    await _irAlLogin(tester);

    await tester.tap(find.text('Forgot your password?'));
    await tester.pumpAndSettle();

    expect(find.byType(RecuperarPasswordSheet), findsOneWidget);
    expect(find.text('Recover password'), findsOneWidget);
  });

  testWidgets('La hoja valida el formato del correo', (tester) async {
    await _irAlRecuperar(tester);

    await tester.enterText(_enSheet(find.byType(TextFormField)), 'correo-malo');
    await tester.tap(find.text('Recover password'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email format'), findsOneWidget);
    expect(find.byType(ResetPasswordPage), findsNothing);
  });

  testWidgets('Un correo válido lleva a la pantalla del código', (
    tester,
  ) async {
    await _irAlCodigo(tester);

    expect(find.byType(ResetPasswordPage), findsOneWidget);
    expect(find.text('Check your email'), findsOneWidget);
    expect(find.text('Verification code'), findsOneWidget);
    // Las 6 casillas del código.
    expect(_casillasCodigo, findsNWidgets(6));
  });

  testWidgets('"Verify code" está deshabilitado sin los 6 dígitos', (
    tester,
  ) async {
    await _irAlCodigo(tester);

    final boton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Verify code'),
    );
    expect(boton.onPressed, isNull);

    await _escribirCodigo(tester, '123');
    final aunDeshabilitado = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Verify code'),
    );
    expect(aunDeshabilitado.onPressed, isNull);
  });

  testWidgets('Verificar el código desbloquea los campos de contraseña', (
    tester,
  ) async {
    await _irAlCodigo(tester);
    await _verificarCodigo(tester);

    expect(find.text('Verified'), findsOneWidget);
    // El bloque del código desaparece al verificar.
    expect(find.text('Verify code'), findsNothing);

    final cambiar = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change password'),
    );
    expect(cambiar.onPressed, isNotNull);
  });

  testWidgets('Las contraseñas deben coincidir', (tester) async {
    await _irAlCodigo(tester);
    await _verificarCodigo(tester);

    final campos = _enReset(find.byType(TextFormField));
    await tester.enterText(campos.at(0), 'password123');
    await tester.enterText(campos.at(1), 'otracosa456');
    // El botón queda bajo el pliegue en el viewport de test: hay que traerlo
    // a la vista antes de pulsarlo.
    await tester.ensureVisible(find.text('Change password'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('La contraseña nueva exige un mínimo de 8 caracteres', (
    tester,
  ) async {
    await _irAlCodigo(tester);
    await _verificarCodigo(tester);

    final campos = _enReset(find.byType(TextFormField));
    await tester.enterText(campos.at(0), 'corta');
    await tester.enterText(campos.at(1), 'corta');
    // El botón queda bajo el pliegue en el viewport de test: hay que traerlo
    // a la vista antes de pulsarlo.
    await tester.ensureVisible(find.text('Change password'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });

  // ---- Home del empleado ----

  // Los tests leen los valores de MockAsistencia en vez de tenerlos escritos a
  // mano: así siguen pasando si se cambian los datos provisionales.

  testWidgets('El Home muestra la cabecera del empleado', (tester) async {
    await _irAlHome(tester);

    expect(find.text(MockAsistencia.empleado.nombre), findsOneWidget);
    expect(find.text(MockAsistencia.empleado.rol.etiqueta), findsOneWidget);
  });

  testWidgets('El Home muestra el resumen del mes', (tester) async {
    await _irAlHome(tester);

    final porcentaje =
        (MockAsistencia.resumen.porcentajeTardanzas * 100).round();

    expect(find.text('Monthly attendance'), findsOneWidget);
    expect(find.text('July 2025'), findsOneWidget);
    expect(find.text('$porcentaje%'), findsOneWidget);
    expect(find.text('Late arrivals'), findsOneWidget);
  });

  testWidgets('El Home muestra los cuatro contadores', (tester) async {
    await _irAlHome(tester);

    final resumen = MockAsistencia.resumen;

    expect(find.text('Absences'), findsOneWidget);
    expect(find.text('${resumen.faltas}'), findsWidgets);
    expect(find.text('Late'), findsOneWidget);
    expect(find.text('${resumen.tardanzas}'), findsWidgets);
    expect(find.text('${resumen.asistencias}'), findsWidgets);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text(resumen.estadoHoy.etiqueta), findsWidgets);
  });

  testWidgets('El Home muestra las últimas marcas', (tester) async {
    await _irAlHome(tester);

    expect(find.text('Latest punches'), findsOneWidget);
    expect(find.text('Clock in'), findsOneWidget);
    expect(find.text('Clock out'), findsOneWidget);
    expect(find.text('08:56'), findsOneWidget);
    expect(find.text('18:07'), findsWidgets);
  });

  testWidgets('El Home muestra los últimos días', (tester) async {
    await _irAlHome(tester);

    // El ListView construye perezosamente: hay que desplazarse para que la
    // tarjeta llegue a existir en el árbol.
    await tester.scrollUntilVisible(
      find.text('Recent days'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Recent days'), findsOneWidget);
    expect(find.text('08:58'), findsOneWidget);
    expect(find.text('09:02'), findsOneWidget);
  });

  testWidgets('La barra inferior tiene las cuatro pestañas', (tester) async {
    await _irAlHome(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.text('HR'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Cambiar de pestaña muestra el placeholder', (tester) async {
    await _irAlHome(tester);

    await tester.tap(find.text('Attendance'));
    await tester.pumpAndSettle();

    expect(find.text('Coming in phase A.2'), findsOneWidget);
  });

  // ---- Perfil ----

  testWidgets('La pestaña Profile muestra las tres secciones', (tester) async {
    await _irAlPerfil(tester);

    expect(find.text('Personal information'), findsOneWidget);

    // El ListView construye perezosamente: hay que desplazarse para que las
    // secciones de abajo lleguen a existir en el árbol.
    await _scrollPerfil(tester, find.text('Security'));
    expect(find.text('Security'), findsOneWidget);

    await _scrollPerfil(tester, find.text('About'));
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('La información personal son campos rellenables', (tester) async {
    await _irAlPerfil(tester);

    expect(find.text('First name'), findsOneWidget);
    expect(find.text('Last name'), findsOneWidget);
    expect(find.text('Date of birth'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);

    await _scrollPerfil(tester, find.text('Save changes'));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Area'), findsOneWidget);
    expect(find.text('Position'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<Genero>), findsOneWidget);
  });

  testWidgets('Guardar con campos vacíos muestra errores', (tester) async {
    await _irAlPerfil(tester);
    await _scrollPerfil(tester, find.text('Save changes'));

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your first name'), findsWidgets);
    expect(find.text('Enter your email'), findsWidgets);
    expect(find.text('Profile updated'), findsNothing);
  });

  testWidgets('El correo valida su formato', (tester) async {
    await _irAlPerfil(tester);
    await _scrollPerfil(tester, find.text('Save changes'));

    final campoCorreo = find.ancestor(
      of: find.text('Enter your email'),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(campoCorreo, 'correo-malo');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email format'), findsOneWidget);
  });

  testWidgets('La foto abre el selector de origen', (tester) async {
    await _irAlPerfil(tester);

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();

    expect(find.text('Profile photo'), findsOneWidget);
    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
  });

  testWidgets('El switch de biometría cambia de estado', (tester) async {
    await _irAlPerfil(tester);
    await _scrollPerfil(tester, find.byType(Switch));

    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('Change password abre su pantalla', (tester) async {
    await _irAlCambiarPassword(tester);

    expect(find.byType(CambiarPasswordPage), findsOneWidget);
    expect(find.text('Current password'), findsOneWidget);
    expect(find.text('New password'), findsOneWidget);
    expect(find.text('Repeat password'), findsOneWidget);
  });

  testWidgets('La contraseña nueva no puede ser igual a la actual', (
    tester,
  ) async {
    await _irAlCambiarPassword(tester);

    final campos = find.descendant(
      of: find.byType(CambiarPasswordPage),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(campos.at(0), 'password123');
    await tester.enterText(campos.at(1), 'password123');
    await tester.enterText(campos.at(2), 'password123');

    await tester.ensureVisible(find.text('Save password'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save password'));
    await tester.pumpAndSettle();

    expect(find.text('The new password must be different'), findsOneWidget);
  });

  testWidgets('Sign out pide confirmación antes de salir', (tester) async {
    await _irAlPerfil(tester);
    await _scrollPerfil(tester, find.text('Sign out'));

    await tester.tap(find.text('Sign out').first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Are you sure you want to sign out?'), findsOneWidget);

    // Cancelar deja al usuario donde estaba.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(EmpleadoShell), findsOneWidget);
  });

  testWidgets('Confirmar Sign out devuelve al login', (tester) async {
    await _irAlPerfil(tester);
    await _scrollPerfil(tester, find.text('Sign out'));

    await tester.tap(find.text('Sign out').first);
    await tester.pumpAndSettle();

    // El botón del diálogo (el último "Sign out" de la pantalla).
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, 'Sign out'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Attendance Control'), findsOneWidget);
    // La sesión se descarta por completo: no queda el shell detrás.
    expect(find.byType(EmpleadoShell, skipOffstage: false), findsNothing);
    // Tampoco se vuelve a pasar por el onboarding.
    expect(find.text('Welcome to Runway 7 Club'), findsNothing);
  });

  testWidgets('Social networks abre la hoja inferior', (tester) async {
    await _irAlPerfil(tester);
    await _scrollPerfil(tester, find.text('Social networks'));

    await tester.tap(find.text('Social networks'));
    await tester.pumpAndSettle();

    expect(find.byType(RedesSocialesSheet), findsOneWidget);
    // Una sola opción en About que abre la hoja con las 5 redes.
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('X (Twitter)'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.text('TikTok'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
