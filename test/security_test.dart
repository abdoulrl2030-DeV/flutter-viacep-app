import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_viacep_app/core/validators/input_validator.dart';
import 'package:flutter_viacep_app/core/security/rate_limiter.dart';

void main() {
  group('Input Validation Security Tests', () {
    test('Rejeita CEP null', () {
      expect(InputValidator.validateCep(null), isNotNull);
    });

    test('Rejeita CEP vazio', () {
      expect(InputValidator.validateCep(''), isNotNull);
    });

    test('Rejeita CEP com menos de 8 dígitos', () {
      expect(InputValidator.validateCep('0131010'), isNotNull);
    });

    test('Rejeita CEP com mais de 8 dígitos', () {
      expect(InputValidator.validateCep('013101000'), isNotNull);
    });

    test('Rejeita CEP com letras', () {
      expect(InputValidator.validateCep('0131010A'), isNotNull);
    });

    test('Rejeita CEP reservado 00000000', () {
      expect(InputValidator.validateCep('00000000'), isNotNull);
    });

    test('Aceita CEP válido', () {
      expect(InputValidator.validateCep('01310100'), isNull);
    });

    test('Aceita CEP com formatação', () {
      expect(InputValidator.validateCep('01310-100'), isNull);
    });

    test('Sanitiza entrada corretamente', () {
      final sanitized = InputValidator.sanitizeInput('  01310-100  ');
      expect(sanitized, '01310-100');
    });

    test('Remove caracteres especiais', () {
      final sanitized = InputValidator.sanitizeInput('01310@100#');
      expect(sanitized, '01310100');
    });

    test('Valida números', () {
      expect(InputValidator.isValidNumber('12345'), true);
      expect(InputValidator.isValidNumber('123A5'), false);
    });

    test('Valida comprimento mínimo', () {
      expect(InputValidator.isValidLength('12345', min: 5), true);
      expect(InputValidator.isValidLength('1234', min: 5), false);
    });

    test('Valida comprimento máximo', () {
      expect(InputValidator.isValidLength('12345', max: 5), true);
      expect(InputValidator.isValidLength('123456', max: 5), false);
    });
  });

  group('Rate Limiter Security Tests', () {
    late RateLimiter rateLimiter;

    setUp(() {
      rateLimiter = RateLimiter(
        maxRequests: 3,
        windowDuration: const Duration(seconds: 1),
      );
    });

    test('Permite requisições até o limite', () {
      expect(rateLimiter.isAllowed('user1'), true);
      expect(rateLimiter.isAllowed('user1'), true);
      expect(rateLimiter.isAllowed('user1'), true);
    });

    test('Bloqueia após atingir limite', () {
      rateLimiter.isAllowed('user1');
      rateLimiter.isAllowed('user1');
      rateLimiter.isAllowed('user1');
      expect(rateLimiter.isAllowed('user1'), false);
    });

    test('Requisições diferentes isolam por usuário', () {
      expect(rateLimiter.isAllowed('user1'), true);
      expect(rateLimiter.isAllowed('user2'), true);
      expect(rateLimiter.isAllowed('user1'), true);
    });

    test('Retorna requisições restantes corretas', () {
      rateLimiter.isAllowed('user1');
      expect(rateLimiter.getRemainingRequests('user1'), 2);
      rateLimiter.isAllowed('user1');
      expect(rateLimiter.getRemainingRequests('user1'), 1);
    });

    test('Reseta histórico de um usuário', () {
      rateLimiter.isAllowed('user1');
      rateLimiter.isAllowed('user1');
      rateLimiter.isAllowed('user1');
      rateLimiter.reset('user1');
      expect(rateLimiter.isAllowed('user1'), true);
    });

    test('Limpa todo o histórico', () {
      rateLimiter.isAllowed('user1');
      rateLimiter.isAllowed('user2');
      rateLimiter.clearAll();
      expect(rateLimiter.isAllowed('user1'), true);
      expect(rateLimiter.isAllowed('user2'), true);
    });
  });
}
