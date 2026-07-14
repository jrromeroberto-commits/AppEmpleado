import 'package:flutter/material.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/perfil/presentation/perfil_page.dart';
import '../widgets/pagina_pendiente.dart';

class EmpleadoShell extends StatefulWidget {
  const EmpleadoShell({super.key});

  @override
  State<EmpleadoShell> createState() => _EmpleadoShellState();
}

class _EmpleadoShellState extends State<EmpleadoShell> {
  int _indice = 0;

  static const _paginas = <Widget>[
    HomePage(),
    PaginaPendiente(
      titulo: 'Attendance',
      icono: Icons.event_available_outlined,
      fase: 'A.2',
    ),
    PaginaPendiente(
      titulo: 'HR',
      icono: Icons.groups_outlined,
      fase: 'A.3',
    ),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack conserva el estado de cada pestaña (scroll, formularios)
      // al cambiar entre ellas, cosa que no haría un simple _paginas[_indice].
      body: IndexedStack(index: _indice, children: _paginas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_outlined),
            selectedIcon: Icon(Icons.event_available),
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
