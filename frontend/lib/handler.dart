import 'dart:io';

class Handler {
  const Handler();

  void onMessage(WebSocket socket, String message) {
    print('<<< $message');
    socket.add(message);
  }

  void onConnect(WebSocket socket) {
    print('Connected');
    socket.add('welcome');
  }

  void onDisconnect(WebSocket socket) {
    print('Disconnected');
  }

  void onError(WebSocket socket, dynamic error) {
    print('Error: $error');
  }
}
