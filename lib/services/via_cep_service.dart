import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/exceptions/cep_exception.dart';
import '../core/utils/constants.dart';
import '../models/cep_model.dart';

/// Serviço para consumo da API ViaCEP
class ViaCepService {
  final http.Client _httpClient;

  ViaCepService({http.Client? httpClient}) 
    : _httpClient = httpClient ?? http.Client();

  /// Busca dados de um CEP
  Future<CepModel> fetchCepData(String cep) async {
    try {
      // Valida o CEP
      if (cep.isEmpty) {
        throw CepException(message: AppConstants.emptyFieldMessage);
      }

      final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
      
      if (cleanCep.length != AppConstants.cepLength) {
        throw CepException(message: AppConstants.invalidCepMessage);
      }

      // Monta a URL
      final url = Uri.parse(
        '${AppConstants.apiBaseUrl}/$cleanCep${AppConstants.apiJsonFormat}',
      );

      // Faz a requisição
      final response = await _httpClient.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw CepException(
          message: 'Tempo limite de requisição excedido',
        ),
      );

      // Valida o status da resposta
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cepModel = CepModel.fromJson(json);

        if (cepModel.erro) {
          throw CepException(message: AppConstants.notFoundMessage);
        }

        return cepModel;
      } else {
        throw CepException(
          message: 'Erro na requisição: ${response.statusCode}',
        );
      }
    } on CepException {
      rethrow;
    } catch (e, stackTrace) {
      throw CepException(
        message: AppConstants.errorMessage,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Valida um CEP localmente
  bool validateCep(String cep) {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
    return cleanCep.length == AppConstants.cepLength;
  }

  /// Formata um CEP no padrão XXXXX-XXX
  String formatCep(String cep) {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
    if (cleanCep.length == AppConstants.cepLength) {
      return '${cleanCep.substring(0, 5)}-${cleanCep.substring(5)}';
    }
    return cep;
  }
}
