import 'package:pong/models/candidate.dart';
import 'package:pong/models/description.dart';
import 'package:pong/types/session_status.dart';

class Session {
  final Description? callerDescription;
  final Description? calleeDescription;
  final List<Candidate> callerCandidates;
  final List<Candidate> calleeCandidates;
  final SessionStatus status;

  const Session({
    required this.callerDescription,
    required this.calleeDescription,
    required this.callerCandidates,
    required this.calleeCandidates,
    required this.status,
  });
}
