import 'package:flutter/material.dart';

import '../../features/asistencia/presentation/asistencia_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/perfil/presentation/perfil_page.dart';
import '../../features/rrhh/presentation/rrhh_page.dart';

enum _Pestana { inicio, asistencia, rrhh, perfil }
class EmpleadoShell extends StatefulWidget {
  const EmpleadoShell({super.key});

  @override
  State<EmpleadoShell> createState() => _EmpleadoShellState();
}

class _EmpleadoShellState extends State<EmpleadoShell> {
  _Pestana _actual = _Pestana.inicio;

  void _irA(_Pestana pestana) => setState(() => _actual = pestana);

  @override
  Widget build(BuildContext context) {
    final paginas = <Widget>[
      HomePage(
        onIrAAsistencia: () => _irA(_Pestana.asistencia),
        onIrARrhh: () => _irA(_Pestana.rrhh),
      ),
      AsistenciaPage(onIrARrhh: () => _irA(_Pestana.rrhh)),
      const RrhhPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      // IndexedStack conserva el estado de cada pestaña (scroll, formularios)
      // al cambiar entre ellas, cosa que no haría un simple paginas[indice].
      body: IndexedStack(index: _actual.index, children: paginas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _actual.index,
        onDestinationSelected: (i) => _irA(_Pestana.values[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'HR',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
