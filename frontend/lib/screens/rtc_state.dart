import 'package:dafluta/dafluta.dart';
import 'package:pong/models/connection.dart';

class RtcState extends BaseState {
  String received = '';
  late final Connection connection;

  RtcState() {
    connection = Connection(onMessage: _onMessage);
  }

  bool get isConnected => connection.isConnected;

  Future onConnect() => connection.connect();

  void onSend() => connection.send('Hello!');

  void _onMessage(String message) {
    print('Received message: $message');
    received = message;
    notify();
  }
}
