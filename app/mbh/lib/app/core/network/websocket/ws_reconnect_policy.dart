class WsReconnectPolicy {
  const WsReconnectPolicy({
    this.maxRetries = 5,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
  });

  final int maxRetries;
  final Duration initialDelay;
  final Duration maxDelay;

  Duration delayForAttempt(int attempt) {
    final int ms = (initialDelay.inMilliseconds * (1 << attempt))
        .clamp(0, maxDelay.inMilliseconds);
    return Duration(milliseconds: ms);
  }
}
