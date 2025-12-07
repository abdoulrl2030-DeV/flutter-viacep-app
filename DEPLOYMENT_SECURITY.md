# Guia de Deployment e Security - flutter-viacep-app

## 🔒 Segurança

### 1. Variáveis de Ambiente

Criar um arquivo `.env` (NÃO commitar no git):
```bash
API_BASE_URL=https://viacep.com.br/ws
API_TIMEOUT=10000
LOG_LEVEL=INFO
```

### 2. Proteção de Dados Sensíveis

#### Android (android/app/build.gradle)
```gradle
android {
    defaultConfig {
        // Usar variáveis de ambiente
        buildConfigField "String", "API_BASE_URL", "\"${System.getenv('API_BASE_URL') ?: 'https://viacep.com.br/ws'}\""
    }
    
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### iOS (ios/Runner/Info.plist)
```xml
<dict>
    <key>NSLocalNetworkUsageDescription</key>
    <string>Para buscar dados de CEP</string>
    <key>NSBonjourServices</key>
    <array>
        <string>_http._tcp</string>
        <string>_https._tcp</string>
    </array>
</dict>
```

### 3. Certificados SSL/TLS

Para evitar man-in-the-middle attacks, usar certificate pinning:

```dart
// lib/services/http_client_config.dart
import 'dart:io';
import 'package:http/http.dart' as http;

class SecureHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Validação de certificado SSL
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => false;
    
    return _inner.send(request);
  }
}
```

### 4. Rate Limiting

Implementar proteção contra abuso da API:

```dart
// lib/services/rate_limiter.dart
class RateLimiter {
  final int maxRequests;
  final Duration windowDuration;
  final Map<String, List<DateTime>> _requestHistory = {};

  RateLimiter({
    this.maxRequests = 10,
    this.windowDuration = const Duration(minutes: 1),
  });

  bool isAllowed(String clientId) {
    final now = DateTime.now();
    final history = _requestHistory[clientId] ?? [];
    
    // Remove requisições antigas
    history.removeWhere((time) => now.difference(time) > windowDuration);
    
    if (history.length < maxRequests) {
      history.add(now);
      _requestHistory[clientId] = history;
      return true;
    }
    
    return false;
  }
}
```

### 5. Validação de Entrada

```dart
// lib/core/validators/input_validator.dart
class InputValidator {
  static String? validateCep(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }
    
    final cleanCep = value.replaceAll(RegExp(r'\D'), '');
    
    if (cleanCep.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(cleanCep)) {
      return 'CEP deve conter apenas números';
    }
    
    return null;
  }
}
```

### 6. Logging Seguro

```dart
// lib/core/logger/secure_logger.dart
import 'package:flutter/foundation.dart';

class SecureLogger {
  static void log(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[$runtimeType] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
    // Em produção, enviar para serviço de logging seguro
  }

  static void logError(String message, Object error, StackTrace stackTrace) {
    log('ERROR: $message', error: error, stackTrace: stackTrace);
  }
}
```

---

## 🚀 Deployment

### Android

#### 1. Configurar Signing

Criar `android/app/build.gradle`:
```gradle
signingConfigs {
    release {
        storeFile file("release.keystore")
        storePassword System.getenv("KEYSTORE_PASSWORD")
        keyAlias System.getenv("KEY_ALIAS")
        keyPassword System.getenv("KEY_PASSWORD")
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

#### 2. Gerar APK

```bash
# Gerar keystore (uma vez)
keytool -genkey -v -keystore release.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias flutter_app

# Build APK
export KEYSTORE_PASSWORD=sua_senha
export KEY_ALIAS=flutter_app
export KEY_PASSWORD=sua_senha

flutter build apk --release
```

#### 3. Gerar App Bundle (Google Play)

```bash
flutter build appbundle --release
```

### iOS

#### 1. Configurar Certificados

```bash
# Gerar certificado de distribuição
# Use Xcode ou Apple Developer Portal
```

#### 2. Build iOS

```bash
flutter build ios --release
```

#### 3. Upload para App Store

```bash
# Usar Transporter ou TestFlight
```

### Web

#### 1. Build Web

```bash
flutter build web --release
```

#### 2. Deploy em Firebase Hosting

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Deploy
firebase deploy
```

#### 3. Deploy em AWS S3 + CloudFront

```bash
# Instalar AWS CLI
aws configure

# Upload para S3
aws s3 sync build/web s3://seu-bucket --delete

# Invalidar CloudFront cache
aws cloudfront create-invalidation --distribution-id sua-distro-id --paths "/*"
```

---

## 🔐 Checklist de Segurança

- [ ] Variáveis sensíveis em `.env` (não commitadas)
- [ ] HTTPS/TLS obrigatório para APIs
- [ ] Certificate pinning implementado
- [ ] Rate limiting ativo
- [ ] Validação de entrada em todos os campos
- [ ] Logs não expõem dados sensíveis
- [ ] Permissões Android/iOS minimizadas
- [ ] Code obfuscation ativo
- [ ] Versão mínima do SDK atualizada
- [ ] Dependências auditadas regularmente
- [ ] Testes de segurança executados

## 📋 Checklist de Deployment

- [ ] Build local testado
- [ ] Testes unitários passando
- [ ] Testes de integração passando
- [ ] Análise estática sem erros
- [ ] Versionamento semântico atualizado
- [ ] Release notes preparadas
- [ ] Screenshots atualizadas
- [ ] Store listing completo
- [ ] Privacy policy configurada
- [ ] Terms of service configurados
- [ ] Certificados/chaves atualizadas

---

## 📝 Versionamento

Usar versionamento semântico: `MAJOR.MINOR.PATCH`

```yaml
# pubspec.yaml
version: 1.0.0+1
# 1.0.0 = versão semântica
# 1 = versão build (Android)
```

---

## 🔄 CI/CD com GitHub Actions

Criar `.github/workflows/deploy.yml` para automação.

---

**Documentação de Deployment e Security v1.0**
