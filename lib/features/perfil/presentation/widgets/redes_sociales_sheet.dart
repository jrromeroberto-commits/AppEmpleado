import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/enlaces_empresa.dart';
import '../../../../core/theme/app_colors.dart';


class RedesSocialesSheet extends StatelessWidget {
  const RedesSocialesSheet({super.key});

  static Future<void> mostrar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.tarjeta,
      // La lista es larga: sin esto la hoja se limitaría a media pantalla.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const RedesSocialesSheet(),
    );
  }

  Future<void> _abrir(BuildContext context, RedSocial red) async {
    final uri = Uri.parse(red.url);
    final abierto = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (abierto || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open ${red.nombre}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaMaxima = MediaQuery.sizeOf(context).height * 0.8;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: alturaMaxima),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            _asa(),
            const SizedBox(height: 20),
            _encabezado(),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: EnlacesEmpresa.redes.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.borde),
                itemBuilder: (context, i) {
                  final red = EnlacesEmpresa.redes[i];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        red.icono,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      red.nombre,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.texto,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: AppColors.textoS,
                    ),
                    onTap: () => _abrir(context, red),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _encabezado() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.share_outlined, size: 24, color: AppColors.primary),
              SizedBox(width: 10),
              Text(
                'Follow us',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.texto,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Runway 7 Fashion on social media.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textoS,
            ),
          ),
        ],
      ),
    );
  }

  Widget _asa() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.borde,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
