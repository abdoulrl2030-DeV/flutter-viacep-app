/// Constantes da aplicação
class AppConstants {
  static const String appName = 'ViaCEP App';
  static const String apiBaseUrl = 'https://viacep.com.br/ws';
  static const String apiJsonFormat = '/json';
  
  // Mensagens
  static const String invalidCepMessage = 'CEP inválido. Digite apenas números.';
  static const String searchingMessage = 'Buscando endereço...';
  static const String errorMessage = 'Erro ao buscar CEP';
  static const String notFoundMessage = 'CEP não encontrado';
  static const String emptyFieldMessage = 'Por favor, digite um CEP';
  
  // Padrões
  static const String cepPattern = r'^\d{8}$';
  static const int cepLength = 8;
}
