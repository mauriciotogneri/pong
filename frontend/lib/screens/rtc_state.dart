import 'package:dafluta/dafluta.dart';
import 'package:pong/models/connection.dart';

class RtcState extends BaseState {
  String log = '';
  late final Connection connection;

  RtcState() {
    connection = Connection(
      onMessage: _onMessage,
      onLog: _onLog,
    );
  }

  bool get isConnected => connection.isConnected;

  Future onConnect() => connection.connect();

  void onSend() => connection.send('Hello!');

  void _onMessage(String message) {}

  void _onLog(String message) {
    log += '$message\n';
    notify();
  }
}
