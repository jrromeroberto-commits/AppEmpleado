import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_colors.dart';

class LoginPie extends StatelessWidget {
  const LoginPie({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        // Mientras carga (o si falla) se reserva la altura para que el layout
        // no dé un salto al aparecer el texto.
        final version = snapshot.hasData
            ? 'Version ${snapshot.data!.version}'
            : '';

        return SizedBox(
          height: 20,
          child: Center(
            child: Text(
              version,
              style: const TextStyle(fontSize: 13, color: AppColors.textoClaroS),
            ),
          ),
        );
      },
    );
  }
}
