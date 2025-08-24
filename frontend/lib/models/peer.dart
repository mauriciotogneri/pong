import 'package:webrtc/json/json_peer.dart';
import 'package:webrtc/models/candidate.dart';
import 'package:webrtc/models/description.dart';

class Peer {
  final Description description;
  final List<Candidate> candidates;

  const Peer({
    required this.description,
    required this.candidates,
  });

  JsonPeer toJson() => JsonPeer(
    description: description.toJson(),
    candidates: candidates.map((c) => c.toJson()).toList(),
  );
}
