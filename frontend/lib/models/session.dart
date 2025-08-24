import 'package:webrtc/json/json_session.dart';
import 'package:webrtc/models/description.dart';
import 'package:webrtc/models/peer.dart';
import 'package:webrtc/types/session_status.dart';

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

  bool get hasAnswer =>
      (callee != null) && (status == SessionStatus.answer_ready);

  bool get hasCallerCandidates =>
      (caller != null) &&
      (caller!.candidates.isNotEmpty) &&
      (status == SessionStatus.caller_candidates_ready);

  bool get hasCalleeCandidates =>
      (callee != null) &&
      (callee!.candidates.isNotEmpty) &&
      (status == SessionStatus.callee_candidates_ready);

  Session withId(String id) => Session(
    id: id,
    createdAt: createdAt,
    caller: caller,
    callee: callee,
    status: status,
  );

  Session withStatus(SessionStatus status) => Session(
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
    status: SessionStatus.offer_ready,
  );
}
