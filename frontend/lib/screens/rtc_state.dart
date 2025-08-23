import 'package:dafluta/dafluta.dart';
import 'package:pong/models/connection.dart';

class RtcState extends BaseState {
  String log = '';
  late final Connection connection;
  DateTime messageSent = DateTime.now();

  RtcState() {
    connection = Connection(
      onMessage: _onMessage,
      onLog: _onLog,
    );
  }

  bool get isDisconnected => connection.isDisconnected;

  bool get isConnected => connection.isConnected;

  Future onConnect() async {
    await connection.connect();
    notify();
  }

  void onSend() {
    messageSent = DateTime.now();
    connection.send('Marco');
  }

  void _onMessage(String message) {
    if (message == 'Marco') {
      connection.send('Polo');
    } else if (message == 'Polo') {
      final duration = DateTime.now().difference(messageSent);
      _onLog('Round-trip time: ${duration.inMilliseconds} ms');
    }
  }

  void _onLog(String message) {
    log += '$message\n';
    notify();
  }
}
