/// Motivo de una denuncia anónima.
enum TipoDenuncia {
  acosoSexual(etiqueta: 'Sexual harassment'),
  acosoLaboral(etiqueta: 'Workplace harassment'),
  discriminacion(etiqueta: 'Discrimination'),
  abusoAutoridad(etiqueta: 'Abuse of authority'),
  otro(etiqueta: 'Other');

  const TipoDenuncia({required this.etiqueta});

  final String etiqueta;
}
