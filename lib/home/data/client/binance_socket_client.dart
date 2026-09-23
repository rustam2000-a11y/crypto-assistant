import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@singleton
class BinanceSocketClient {
  static const _url = 'wss://stream.binance.com:9443/ws';
  static const _reconnectDelay = Duration(seconds: 3);

  final _messages = StreamController<Map<String, dynamic>>.broadcast();
  final _streams = <String>{};
  WebSocketChannel? _channel;

  Stream<double> watchPrice(String symbol) {
    final pair = '${symbol.toUpperCase()}USDT';
    final stream = '${pair.toLowerCase()}@miniTicker';
    return _messages.stream
        .where((m) => m['s'] == pair)
        .map((m) => double.parse(m['c'] as String))
        .doOnListen(() {
          _streams.add(stream);
          _channel == null ? _connect() : _send('SUBSCRIBE', [stream]);
        })
        .doOnCancel(() {
          _streams.remove(stream);
          _send('UNSUBSCRIBE', [stream]);
        });
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_url));
    _channel!.stream.listen(
      (raw) => _messages.add(jsonDecode(raw as String) as Map<String, dynamic>),
      onError: (Object _) => _reconnect(),
      onDone: _reconnect,
      cancelOnError: true,
    );
    _send('SUBSCRIBE', _streams.toList());
  }

  void _reconnect() {
    _channel = null;
    Future.delayed(_reconnectDelay, () {
      if (_channel == null && _streams.isNotEmpty) _connect();
    });
  }

  void _send(String method, List<String> streams) {
    if (streams.isEmpty) return;
    final payload = {'method': method, 'params': streams, 'id': 1};
    _channel?.sink.add(jsonEncode(payload));
  }
}
