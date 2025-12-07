/// Rate limiter para proteção contra abuso
class RateLimiter {
  final int maxRequests;
  final Duration windowDuration;
  final Map<String, List<DateTime>> _requestHistory = {};

  RateLimiter({
    this.maxRequests = 10,
    this.windowDuration = const Duration(minutes: 1),
  });

  /// Verifica se uma requisição é permitida
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

  /// Retorna o número de requisições restantes
  int getRemainingRequests(String clientId) {
    final now = DateTime.now();
    final history = _requestHistory[clientId] ?? [];

    // Remove requisições antigas
    history.removeWhere((time) => now.difference(time) > windowDuration);

    return (maxRequests - history.length).clamp(0, maxRequests);
  }

  /// Reseta o histórico para um cliente
  void reset(String clientId) {
    _requestHistory.remove(clientId);
  }

  /// Limpa todo o histórico
  void clearAll() {
    _requestHistory.clear();
  }
}
