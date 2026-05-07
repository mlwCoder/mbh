import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:mbh/app/core/logging/app_logger.dart';
import 'package:mbh/app/core/network/websocket/ws_message.dart';
import 'package:mbh/app/core/network/websocket/ws_reconnect_policy.dart';
import 'package:mbh/app/core/network/websocket/ws_status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsClient extends GetxService {
  WsClient(this._logger, {WsReconnectPolicy? reconnectPolicy})
      : _reconnectPolicy = reconnectPolicy ?? const WsReconnectPolicy();

  final AppLogger _logger;
  final WsReconnectPolicy _reconnectPolicy;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  String? _url;

  final Rx<WsStatus> status = WsStatus.disconnected.obs;
  final RxList<WsMessage> messages = <WsMessage>[].obs;

  final StreamController<WsMessage> _messageController =
      StreamController<WsMessage>.broadcast();

  Stream<WsMessage> get messageStream => _messageController.stream;

  Future<void> connect(String url) async {
    _url = url;
    _reconnectAttempt = 0;
    await _doConnect(url);
  }

  Future<void> _doConnect(String url) async {
    status.value = WsStatus.connecting;
    _logger.debug('WebSocket connecting to $url');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      await _channel!.ready;

      status.value = WsStatus.connected;
      _reconnectAttempt = 0;
      _logger.debug('WebSocket connected.');

      _startHeartbeat();

      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
      );
    } catch (e) {
      _logger.error('WebSocket connect failed: $e');
      _scheduleReconnect();
    }
  }

  void send(WsMessage message) {
    if (status.value != WsStatus.connected || _channel == null) {
      _logger.error('WebSocket is not connected. Cannot send.');
      return;
    }

    final String payload = jsonEncode(<String, dynamic>{
      'event': message.event,
      'data': message.data,
    });
    _channel!.sink.add(payload);
  }

  Future<void> disconnect() async {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    await _subscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
    status.value = WsStatus.disconnected;
    _logger.debug('WebSocket disconnected.');
  }

  void _onData(dynamic raw) {
    try {
      if (raw is String) {
        final Map<String, dynamic> json =
            jsonDecode(raw) as Map<String, dynamic>;
        final WsMessage message = WsMessage(
          event: json['event'] as String? ?? 'unknown',
          data: json['data'],
        );
        messages.add(message);
        _messageController.add(message);
      }
    } catch (e) {
      _logger.error('WebSocket parse error: $e');
    }
  }

  void _onError(Object error) {
    _logger.error('WebSocket error: $error');
    _scheduleReconnect();
  }

  void _onDone() {
    _logger.debug('WebSocket closed by server.');
    _scheduleReconnect();
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (status.value == WsStatus.connected) {
          send(const WsMessage(event: 'ping'));
        }
      },
    );
  }

  void _scheduleReconnect() {
    if (_reconnectAttempt >= _reconnectPolicy.maxRetries) {
      _logger.error('WebSocket max reconnect attempts reached.');
      status.value = WsStatus.disconnected;
      return;
    }

    status.value = WsStatus.reconnecting;
    final Duration delay = _reconnectPolicy.delayForAttempt(_reconnectAttempt);
    _reconnectAttempt++;
    _logger.debug('WebSocket reconnecting in ${delay.inMilliseconds}ms (attempt $_reconnectAttempt)');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_url != null) {
        _doConnect(_url!);
      }
    });
  }

  @override
  void onClose() {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _messageController.close();
    super.onClose();
  }
}
