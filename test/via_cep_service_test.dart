import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_viacep_app/services/via_cep_service.dart';

void main() {
  group('ViaCepService Tests', () {
    late ViaCepService service;

    setUp(() {
      service = ViaCepService();
    });

    test('Valida CEP correto', () {
      expect(service.validateCep('01310100'), true);
    });

    test('Rejeita CEP com menos de 8 dígitos', () {
      expect(service.validateCep('01310'), false);
    });

    test('Rejeita CEP vazio', () {
      expect(service.validateCep(''), false);
    });

    test('Formata CEP corretamente', () {
      expect(service.formatCep('01310100'), '01310-100');
    });

    test('Formata CEP com caracteres especiais', () {
      expect(service.formatCep('01310-100'), '01310-100');
    });
  });
}
