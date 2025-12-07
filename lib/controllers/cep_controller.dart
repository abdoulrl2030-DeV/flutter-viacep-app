import 'package:flutter/material.dart';
import '../core/exceptions/cep_exception.dart';
import '../models/cep_model.dart';
import '../services/via_cep_service.dart';

/// Controlador para gerenciar a lógica de busca de CEP
class CepController extends ChangeNotifier {
  final ViaCepService _service;

  // Estados privados
  CepModel? _cepData;
  bool _isLoading = false;
  String? _error;

  CepController({ViaCepService? service})
    : _service = service ?? ViaCepService();

  // Getters públicos
  CepModel? get cepData => _cepData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _cepData != null && _cepData!.isValid;
  bool get hasError => _error != null;

  /// Busca dados do CEP
  Future<void> searchCep(String cep) async {
    try {
      _isLoading = true;
      _error = null;
      _cepData = null;
      notifyListeners();

      _cepData = await _service.fetchCepData(cep);
      _error = null;
    } on CepException catch (e) {
      _error = e.message;
      _cepData = null;
    } catch (e) {
      _error = 'Erro inesperado: $e';
      _cepData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa os dados
  void clearData() {
    _cepData = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Valida um CEP localmente
  bool validateCep(String cep) => _service.validateCep(cep);

  /// Formata um CEP
  String formatCep(String cep) => _service.formatCep(cep);
}
