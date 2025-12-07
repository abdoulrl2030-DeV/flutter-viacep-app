# SECURITY.md - Política de Segurança

## Relatando Vulnerabilidades

Se você descobrir uma vulnerabilidade no projeto flutter-viacep-app, **por favor NÃO crie uma issue pública**. 

Em vez disso, envie um email para: `security@example.com` com:
- Descrição da vulnerabilidade
- Passos para reproduzir
- Impacto potencial
- Sua sugestão de correção (opcional)

## Práticas de Segurança

### 1. Validação de Entrada
- ✅ Todos os inputs de usuário são validados
- ✅ Proteção contra injeção de código
- ✅ Sanitização de strings

### 2. Proteção de Dados
- ✅ Comunicação HTTPS obrigatória
- ✅ Certificate pinning implementado
- ✅ Dados sensíveis não são logados
- ✅ Sem armazenamento de senhas

### 3. Rate Limiting
- ✅ Limite de 10 requisições por minuto por padrão
- ✅ Proteção contra força bruta
- ✅ Proteção contra DoS

### 4. Logging e Monitoramento
- ✅ Logs sanitizados (sem dados sensíveis)
- ✅ Diferentes níveis de log (DEBUG, INFO, WARNING, ERROR)
- ✅ Logs desabilitados em produção por padrão

### 5. Análise Estática
- ✅ Flutter analyze sem erros
- ✅ Regras de linting rigorosas
- ✅ Type-safe code
- ✅ Null-safety habilitada

### 6. Testes de Segurança
- ✅ Testes de validação de entrada
- ✅ Testes de rate limiting
- ✅ Cobertura de testes de segurança

## Checklist de Segurança para Releases

Antes de cada release, verificar:

- [ ] `flutter analyze` passa sem erros
- [ ] `flutter test` passa com 100% de cobertura
- [ ] Nenhuma senha ou chave em commits
- [ ] .env exemplo atualizado (sem valores reais)
- [ ] .gitignore contém arquivos sensíveis
- [ ] Dependências auditadas com `flutter pub outdated`
- [ ] Versão atualizada em pubspec.yaml
- [ ] Release notes preparadas
- [ ] Code review completado
- [ ] Testes de segurança passando

## Dependências Seguras

Este projeto usa as seguintes dependências de confiança:

| Dependência | Versão | Propósito |
|---|---|---|
| http | ^1.1.0 | Cliente HTTP seguro |
| provider | ^6.0.0 | Gerenciamento de estado |
| flutter | 3.0+ | Framework |

Todas as dependências são regularmente auditadas para vulnerabilidades conhecidas.

## Versão Mínima do SDK

- Flutter: 3.0.0
- Dart: 3.0.0
- Android: API 21 (5.0)
- iOS: 11.0

## Políticas de Atualização

- Atualizações de segurança: 24-48 horas
- Atualizações menores: Próximo release regular
- Atualizações maiores: Planejadas 4 semanas antes

## Contato

- **Email**: security@example.com
- **Issues de Segurança**: Não usar GitHub Issues
- **Documentação**: https://github.com/abdoulrl2030-DeV/flutter-viacep-app

---

**Última atualização**: Dezembro 2025
