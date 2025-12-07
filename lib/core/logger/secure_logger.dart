/// Logger seguro para a aplicação
import 'package:flutter/foundation.dart';

class SecureLogger {
  static const String _prefix = '[ViaCEP]';

  /// Log de informação
  static void info(String message) {
    if (kDebugMode) {
      print('$_prefix [INFO] $message');
    }
  }

  /// Log de aviso
  static void warning(String message) {
    if (kDebugMode) {
      print('$_prefix [WARNING] $message');
    }
  }

  /// Log de erro (sem expor detalhes sensíveis em produção)
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      print('$_prefix [ERROR] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    } else {
      // Em produção, apenas registrar a mensagem genérica
      print('$_prefix [ERROR] $message');
    }
  }

  /// Log de debug
  static void debug(String message) {
    if (kDebugMode) {
      print('$_prefix [DEBUG] $message');
    }
  }
}
