import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_colors.dart';

class LoginPie extends StatelessWidget {
  const LoginPie({super.key});

  /// Firma del autor. Apenas se despega del fondo: solo se lee si se busca.
  static const _firma = Color(0xFF141414);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.hasData
            ? 'Version ${snapshot.data!.version}'
            : '';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
              child: Center(
                child: Text(
                  version,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textoClaroS,
                  ),
                ),
              ),
            ),
            const Text(
              'By El elemento',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 0.5,
                color: _firma,
              ),
            ),
          ],
        );
      },
    );
  }
}
