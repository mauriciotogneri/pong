import 'package:webrtc/json/json_candidate.dart';

class Candidate {
  final String? candidate;
  final String? sdpMid;
  final int? sdpMLineIndex;

  const Candidate({
    this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
  });

  JsonCandidate toJson() => JsonCandidate(
    candidate: candidate,
    sdpMid: sdpMid,
    sdpMLineIndex: sdpMLineIndex,
  );
}
