/// Exceção customizada para erros relacionados a CEP
class CepException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  CepException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => message;
}
