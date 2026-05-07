class WsMessage {
  const WsMessage({
    required this.event,
    this.data,
  });

  final String event;
  final dynamic data;

  @override
  String toString() => 'WsMessage(event: $event, data: $data)';
}
