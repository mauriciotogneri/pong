import 'package:pong/json/json_session.dart';
import 'package:pong/models/description.dart';
import 'package:pong/models/peer.dart';
import 'package:pong/types/session_status.dart';

class Session {
  final String id;
  final DateTime createdAt;
  final Peer? caller;
  final Peer? callee;
  final SessionStatus status;

  const Session({
    required this.id,
    required this.createdAt,
    required this.caller,
    required this.callee,
    required this.status,
  });

  bool get isAnswered => (callee != null) && (status == SessionStatus.answered);

  bool get hasCallerCandidates =>
      (caller != null) && (caller!.candidates.isNotEmpty);

  bool get hasCalleeCandidates =>
      (callee != null) && (callee!.candidates.isNotEmpty);

  Session withId(String id) => Session(
    id: id,
    createdAt: createdAt,
    caller: caller,
    callee: callee,
    status: status,
  );

  Session withCaller(Peer caller) => Session(
    id: id,
    createdAt: createdAt,
    caller: caller,
    callee: callee,
    status: status,
  );

  Session withCallee(Peer callee) => Session(
    id: id,
    createdAt: createdAt,
    caller: caller,
    callee: callee,
    status: status,
  );

  JsonSession toJson() => JsonSession(
    id: id,
    createdAt: createdAt,
    caller: caller?.toJson(),
    callee: callee?.toJson(),
    status: status,
  );

  factory Session.create(Description description) => Session(
    id: '',
    createdAt: DateTime.now(),
    caller: Peer(
      description: description,
      candidates: [],
    ),
    callee: null,
    status: SessionStatus.offered,
  );
}
