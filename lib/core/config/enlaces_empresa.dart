import 'package:flutter/material.dart';

/// Una red social de la empresa.
class RedSocial {
  const RedSocial({
    required this.nombre,
    required this.icono,
    required this.url,
  });

  final String nombre;
  final IconData icono;
  final String url;
}

class EnlacesEmpresa {
  EnlacesEmpresa._();

  static const terminos = 'https://runway7fashion.com/terms-and-conditions/';

  static const redes = <RedSocial>[
    RedSocial(
      nombre: 'Instagram',
      icono: Icons.camera_alt_outlined,
      url:
          'https://www.instagram.com/runway7fashion?igsh=MXFodG5tcnVnN3lxcQ==',
    ),
    RedSocial(
      nombre: 'Facebook',
      icono: Icons.facebook_outlined,
      url: 'https://www.facebook.com/runway7fashion/',
    ),
    RedSocial(
      nombre: 'YouTube',
      icono: Icons.play_circle_outline,
      url: 'https://youtube.com/@runway7fashion?si=zd3EnCKXeAMsMmVE',
    ),
    RedSocial(
      nombre: 'TikTok',
      icono: Icons.music_note_outlined,
      url: 'https://www.tiktok.com/@runway7fashion?_r=1&_t=ZS-981zxfB7haM',
    ),
    RedSocial(
      nombre: 'LinkedIn',
      icono: Icons.work_outline,
      url: 'https://www.linkedin.com/company/runway-7-fashion/',
    ),
    RedSocial(
      nombre: 'X (Twitter)',
      icono: Icons.alternate_email,
      url: 'https://x.com/Runway7Fashion',
    ),
    RedSocial(
      nombre: 'Pinterest',
      icono: Icons.push_pin_outlined,
      url: 'https://es.pinterest.com/runway7fashion/',
    ),
  ];
}
