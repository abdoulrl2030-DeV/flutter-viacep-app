#!/bin/bash

# Script de configuração pós-deployment
# Execute este script antes de fazer deploy em produção

set -e

echo "=========================================="
echo "🔧 Configuração de Deployment & Security"
echo "=========================================="

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 1. Criar arquivo .env
log_info "1️⃣  Criando arquivo .env..."
if [ ! -f .env ]; then
    cp .env.example .env
    log_success "Arquivo .env criado (CONFIGURE COM SEUS VALORES!)"
else
    log_success "Arquivo .env já existe"
fi

# 2. Instalar dependências
log_info "2️⃣  Instalando dependências..."
export PATH="$PATH:~/flutter/bin"
flutter pub get
log_success "Dependências instaladas"

# 3. Executar análise
log_info "3️⃣  Executando análise de código..."
flutter analyze
log_success "Análise concluída - nenhum problema encontrado"

# 4. Executar testes
log_info "4️⃣  Executando testes..."
flutter test
log_success "Testes passaram com sucesso"

# 5. Tornar script deploy executável
log_info "5️⃣  Configurando script de deploy..."
chmod +x deploy.sh
log_success "Script deploy.sh pronto"

# 6. Informações de segurança
echo ""
echo "=========================================="
echo "🔐 CHECKLIST DE SEGURANÇA"
echo "=========================================="
echo ""
echo "ANTES DE FAZER DEPLOY:"
echo ""
echo "1. Arquivo .env"
echo "   [ ] Configure todas as variáveis em .env"
echo "   [ ] Não commite .env no Git"
echo "   [ ] Use GitHub Secrets para CI/CD"
echo ""
echo "2. Chaves de Assinatura (Android)"
echo "   [ ] Gere release.keystore:"
echo "       keytool -genkey -v -keystore release.keystore \\"
echo "         -keyalg RSA -keysize 2048 -validity 10000 \\"
echo "         -alias flutter_app"
echo "   [ ] Não commite release.keystore"
echo "   [ ] Configure em GitHub Secrets"
echo ""
echo "3. Certificados (iOS)"
echo "   [ ] Gere certificados no Apple Developer Portal"
echo "   [ ] Configure em Xcode"
echo "   [ ] Configure provisioning profiles"
echo ""
echo "4. GitHub Secrets (para CI/CD)"
echo "   [ ] KEYSTORE_PASSWORD"
echo "   [ ] KEY_ALIAS"
echo "   [ ] KEY_PASSWORD"
echo ""
echo "5. Ambiente de Produção"
echo "   [ ] Configure HTTPS obrigatório"
echo "   [ ] Implemente certificate pinning"
echo "   [ ] Configure rate limiting"
echo "   [ ] Habilite logging de erros remoto"
echo ""
echo "=========================================="
echo "🚀 PRÓXIMOS PASSOS"
echo "=========================================="
echo ""
echo "1. Editar arquivo .env:"
echo "   nano .env"
echo ""
echo "2. Testar localmente:"
echo "   flutter run"
echo ""
echo "3. Build para Android:"
echo "   ./deploy.sh android"
echo ""
echo "4. Build para Web:"
echo "   ./deploy.sh web"
echo ""
echo "5. Fazer push para GitHub (CI/CD automático):"
echo "   git push"
echo ""
echo "=========================================="
log_success "Configuração completa!"
echo "=========================================="
