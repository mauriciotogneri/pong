import 'dart:io';
import 'package:pong/handler.dart';

class Server {
  final Handler handler;

  const Server(this.handler);

  Future start() async {
    print('Starting server...');
    final InternetAddress address = InternetAddress.tryParse('192.168.0.191')!;
    final HttpServer server = await HttpServer.bind(
      address,
      7777,
    );
    server.listen(_handleRequest);
    print('Server running on ${server.port}');
  }

  Future _handleRequest(HttpRequest request) async {
    try {
      print('HTTP Request: ${request.method} ${request.requestedUri}');

      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final WebSocket socket = await WebSocketTransformer.upgrade(request);
        socket.listen(
          (message) => handler.onMessage(socket, message),
          onDone: () => handler.onDisconnect(socket),
          onError: (error) => handler.onError(socket, error),
        );
        handler.onConnect(socket);
      } else {
        print('Request cannot be upgraded');

        request.response.statusCode = HttpStatus.forbidden;
        await request.response.close();
      }
    } catch (e) {
      print('Error handling request: $e');
    }
  }
}
