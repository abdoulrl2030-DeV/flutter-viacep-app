# ViaCEP App

Aplicativo Flutter para consulta de CEP utilizando a API ViaCEP. Inclui consumo de API REST, tratamento de erros, carregamento assíncrono e arquitetura organizada em camadas (Model, Service, Controller e UI).

## 🎯 Funcionalidades

- ✅ Busca de CEP em tempo real
- ✅ Validação de entrada de dados
- ✅ Tratamento de erros robusto
- ✅ Carregamento assíncrono
- ✅ Interface responsiva e moderna
- ✅ Gerenciamento de estado com Provider
- ✅ Arquitetura em camadas

## 📱 Estrutura do Projeto

```
flutter-viacep-app/
├── lib/
│   ├── core/
│   │   ├── exceptions/
│   │   │   └── cep_exception.dart        # Exceção customizada
│   │   └── utils/
│   │       └── constants.dart             # Constantes da app
│   ├── models/
│   │   └── cep_model.dart                # Modelo de dados
│   ├── services/
│   │   └── via_cep_service.dart          # Serviço de API
│   ├── controllers/
│   │   └── cep_controller.dart           # Controlador/ViewModel
│   ├── pages/
│   │   └── home_page.dart                # Tela principal
│   ├── widgets/
│   │   └── custom_text_field.dart        # Widget customizado
│   └── main.dart                         # Entrada da aplicação
├── pubspec.yaml                          # Dependências
└── README.md                             # Este arquivo
```

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.0+** - Framework mobile
- **Provider** - Gerenciamento de estado
- **HTTP** - Cliente HTTP para requisições
- **Dart** - Linguagem de programação

## 📦 Dependências Principais

```yaml
http: ^1.1.0          # Cliente HTTP
provider: ^6.0.0      # Gerenciamento de estado
```

## 🚀 Como Começar

### Pré-requisitos

- Flutter SDK 3.0 ou superior
- Dart SDK 3.0 ou superior
- Um editor de código (VS Code, Android Studio, etc)

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/abdoulrl2030-DeV/flutter-viacep-app.git
cd flutter-viacep-app
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## 📚 Estrutura e Camadas

### Core (`lib/core/`)
- **exceptions/** - Exceções customizadas da aplicação
- **utils/** - Constantes e utilitários

### Models (`lib/models/`)
- Modelos de dados que representam as respostas da API

### Services (`lib/services/`)
- Lógica de comunicação com a API ViaCEP
- Validação e formatação de dados

### Controllers (`lib/controllers/`)
- Gerenciamento de estado usando ChangeNotifier
- Lógica de negócio separada da UI

### Pages (`lib/pages/`)
- Telas da aplicação
- UI principal usando widgets do Flutter

### Widgets (`lib/widgets/`)
- Componentes reutilizáveis customizados

## 🎨 Componentes Principais

### CepModel
Representa os dados retornados pela API:
- CEP
- Logradouro
- Bairro
- Localidade
- UF
- E mais...

### ViaCepService
Responsável por:
- Fazer requisições à API
- Validar CEP
- Formatar dados
- Tratar erros

### CepController
Gerencia:
- Estado da busca
- Dados do CEP
- Mensagens de erro
- Carregamento

### CustomTextField
Widget customizado com:
- Validação
- Formatação
- Ícones
- Styling consistente

## 🔍 Uso da API ViaCEP

O aplicativo faz requisições GET para:
```
https://viacep.com.br/ws/{CEP}/json
```

Exemplo de resposta:
```json
{
  "cep": "01310100",
  "logradouro": "Avenida Paulista",
  "complemento": "",
  "bairro": "Bela Vista",
  "localidade": "São Paulo",
  "uf": "SP",
  "ibge": "3550308",
  "gia": "",
  "ddd": "11",
  "siafi": "7107"
}
```

## 🧪 Teste Manual

1. Inicie o aplicativo
2. Digite um CEP válido (ex: 01310100)
3. Toque em "BUSCAR"
4. Visualize o endereço retornado

### CEPs para Teste
- 01310100 - Av. Paulista, São Paulo
- 20040020 - Centro, Rio de Janeiro
- 70040902 - Brasília

## 📱 Componentes da Interface

A interface inclui:
- Campo de entrada de CEP com validação
- Indicador de carregamento
- Exibição de endereço completo
- Mensagens de erro amigáveis
- Botão para nova busca

## 🐛 Tratamento de Erros

O aplicativo trata:
- CEP inválido (menos de 8 dígitos)
- CEP não encontrado
- Erros de conexão
- Timeout de requisição
- Erros inesperados

## 📝 Licença

Este projeto está sob a licença MIT.

## 👨‍💻 Autor

Desenvolvido por [abdoulrl2030-DeV](https://github.com/abdoulrl2030-DeV)

## 🤝 Contribuindo

Sugestões e melhorias são bem-vindas! Sinta-se livre para abrir issues ou pull requests.

---

**Desenvolvido com ❤️ usando Flutter**
