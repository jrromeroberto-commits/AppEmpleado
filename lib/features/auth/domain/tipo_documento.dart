
enum TipoDocumento {
  /// DNI peruano: exactamente 8 dígitos.
  dni(etiqueta: 'DNI', largoMin: 8, largoMax: 8),

  carneExtranjeria(etiqueta: 'C.E.', largoMin: 9, largoMax: 12);

  const TipoDocumento({
    required this.etiqueta,
    required this.largoMin,
    required this.largoMax,
  });

  /// Texto corto para el selector.
  final String etiqueta;

  final int largoMin;
  final int largoMax;

  /// Nombre completo, para mensajes de error y etiquetas.
  String get nombre => switch (this) {
    TipoDocumento.dni => 'DNI',
    TipoDocumento.carneExtranjeria => 'Foreigner ID',
  };

  /// Valida el número contra las reglas de este tipo de documento.
  /// Devuelve `null` si es válido, o el mensaje de error.
  String? validar(String numero) {
    if (numero.isEmpty) {
      return 'Enter your $nombre';
    }
    if (numero.length < largoMin) {
      return largoMin == largoMax
          ? '$nombre must be $largoMin digits'
          : '$nombre must be at least $largoMin digits';
    }
    return null;
  }
}
