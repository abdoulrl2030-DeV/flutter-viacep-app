/// Validador de entrada para a aplicação
import '../logger/secure_logger.dart';

class InputValidator {
  /// Valida um CEP
  static String? validateCep(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }

    final cleanCep = value.replaceAll(RegExp(r'\D'), '');

    if (cleanCep.isEmpty) {
      return 'CEP inválido';
    }

    if (cleanCep.length != 8) {
      return 'CEP deve conter 8 dígitos';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleanCep)) {
      return 'CEP deve conter apenas números';
    }

    // CEP 00000-000 é reservado
    if (cleanCep == '00000000') {
      return 'CEP inválido';
    }

    SecureLogger.debug('CEP validado: $cleanCep');
    return null;
  }

  /// Sanitiza entrada de usuário
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'[^\w\s-]'), '');
  }

  /// Valida se é um número válido
  static bool isValidNumber(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  /// Valida comprimento de string
  static bool isValidLength(String value, {int? min, int? max}) {
    if (min != null && value.length < min) return false;
    if (max != null && value.length > max) return false;
    return true;
  }
}
