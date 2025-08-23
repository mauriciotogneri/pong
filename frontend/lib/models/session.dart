import 'package:pong/models/peer.dart';
import 'package:pong/types/session_status.dart';

class Session {
  final DateTime createdAt;
  final Peer? caller;
  final Peer? callee;
  final SessionStatus status;

  const Session({
    required this.createdAt,
    required this.caller,
    required this.callee,
    required this.status,
  });

  Session withCalee(Peer callee) => Session(
    createdAt: createdAt,
    caller: caller,
    callee: callee,
    status: status,
  );
}
