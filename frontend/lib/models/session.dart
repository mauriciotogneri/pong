import 'package:pong/models/peer.dart';
import 'package:pong/types/session_status.dart';

class Session {
  final Peer? caller;
  final Peer? callee;
  final SessionStatus status;

  const Session({
    required this.caller,
    required this.callee,
    required this.status,
  });
}
