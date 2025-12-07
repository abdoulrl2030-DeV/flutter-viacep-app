/// Modelo para representar dados de um CEP
class CepModel {
  final String? cep;
  final String? logradouro;
  final String? complemento;
  final String? bairro;
  final String? localidade;
  final String? uf;
  final String? ibge;
  final String? gia;
  final String? ddd;
  final String? siafi;
  final bool erro;

  CepModel({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
    this.erro = false,
  });

  /// Cria uma instância de CepModel a partir de um JSON
  factory CepModel.fromJson(Map<String, dynamic> json) {
    return CepModel(
      cep: json['cep'] as String?,
      logradouro: json['logradouro'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      localidade: json['localidade'] as String?,
      uf: json['uf'] as String?,
      ibge: json['ibge'] as String?,
      gia: json['gia'] as String?,
      ddd: json['ddd'] as String?,
      siafi: json['siafi'] as String?,
      erro: json['erro'] == true,
    );
  }

  /// Converte a instância para JSON
  Map<String, dynamic> toJson() => {
    'cep': cep,
    'logradouro': logradouro,
    'complemento': complemento,
    'bairro': bairro,
    'localidade': localidade,
    'uf': uf,
    'ibge': ibge,
    'gia': gia,
    'ddd': ddd,
    'siafi': siafi,
    'erro': erro,
  };

  /// Verifica se o CEP é válido
  bool get isValid => !erro && cep != null && cep!.isNotEmpty;

  /// Retorna o endereço completo formatado
  String get fullAddress {
    if (!isValid) return '';
    return '$logradouro, $bairro - $localidade, $uf';
  }

  @override
  String toString() => 'CepModel(cep: $cep, logradouro: $logradouro)';
}
