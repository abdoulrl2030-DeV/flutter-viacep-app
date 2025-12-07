#!/bin/bash

# Script de deployment para flutter-viacep-app
# Uso: ./deploy.sh [android|ios|web|all]

set -e

TARGETS=${1:-all}
VERSION=$(grep "version:" pubspec.yaml | awk '{print $2}' | head -1)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "================================"
echo "🚀 Iniciando Deployment"
echo "Versão: $VERSION"
echo "Data: $TIMESTAMP"
echo "================================"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Função para exibir mensagens
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Validar ambiente
validate_env() {
    log_info "Validando ambiente..."
    
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter não encontrado. Configure o PATH."
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        log_error "Git não encontrado."
        exit 1
    fi
    
    log_success "Ambiente validado"
}

# Limpar builds anteriores
clean() {
    log_info "Limpando builds anteriores..."
    flutter clean
    log_success "Limpeza concluída"
}

# Instalar dependências
get_dependencies() {
    log_info "Instalando dependências..."
    flutter pub get
    log_success "Dependências instaladas"
}

# Análise estática
analyze() {
    log_info "Executando análise estática..."
    flutter analyze
    log_success "Análise concluída"
}

# Testes
run_tests() {
    log_info "Executando testes..."
    flutter test
    log_success "Testes passaram"
}

# Build Android
build_android() {
    log_info "Building Android APK..."
    
    flutter build apk --release
    
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        cp build/app/outputs/flutter-apk/app-release.apk \
           "build/app-v${VERSION}-${TIMESTAMP}.apk"
        log_success "APK construído: app-v${VERSION}-${TIMESTAMP}.apk"
    else
        log_error "Falha ao construir APK"
        exit 1
    fi
}

# Build Android App Bundle
build_android_bundle() {
    log_info "Building Android App Bundle..."
    
    flutter build appbundle --release
    
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        cp build/app/outputs/bundle/release/app-release.aab \
           "build/app-v${VERSION}-${TIMESTAMP}.aab"
        log_success "App Bundle construído: app-v${VERSION}-${TIMESTAMP}.aab"
    else
        log_error "Falha ao construir App Bundle"
        exit 1
    fi
}

# Build iOS
build_ios() {
    log_info "Building iOS..."
    
    flutter build ios --release --no-codesign
    
    if [ -d "build/ios/iphoneos/Runner.app" ]; then
        log_success "iOS construído com sucesso"
    else
        log_error "Falha ao construir iOS"
        exit 1
    fi
}

# Build Web
build_web() {
    log_info "Building Web..."
    
    flutter build web --release
    
    if [ -d "build/web" ]; then
        tar -czf "build/web-v${VERSION}-${TIMESTAMP}.tar.gz" build/web/
        log_success "Web construído: web-v${VERSION}-${TIMESTAMP}.tar.gz"
    else
        log_error "Falha ao construir Web"
        exit 1
    fi
}

# Criar tag de release
create_release_tag() {
    log_info "Criando tag de release..."
    
    git tag -a "v${VERSION}-${TIMESTAMP}" -m "Release ${VERSION} - ${TIMESTAMP}"
    git push origin "v${VERSION}-${TIMESTAMP}"
    
    log_success "Tag criada: v${VERSION}-${TIMESTAMP}"
}

# Menu principal
main() {
    validate_env
    
    # Executar etapas comuns
    clean
    get_dependencies
    analyze
    run_tests
    
    # Executar builds específicos
    case $TARGETS in
        android)
            build_android
            ;;
        android-bundle)
            build_android_bundle
            ;;
        ios)
            build_ios
            ;;
        web)
            build_web
            ;;
        all)
            build_android
            build_android_bundle
            build_web
            log_info "Pulando iOS (requer macOS)"
            ;;
        *)
            log_error "Alvo desconhecido: $TARGETS"
            echo "Uso: ./deploy.sh [android|android-bundle|ios|web|all]"
            exit 1
            ;;
    esac
    
    echo ""
    echo "================================"
    log_success "🎉 Deployment concluído com sucesso!"
    echo "Versão: $VERSION"
    echo "Data: $TIMESTAMP"
    echo "Alvo: $TARGETS"
    echo "================================"
}

# Executar
main "$@"
