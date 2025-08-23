import 'package:pong/models/candidate.dart';
import 'package:pong/models/description.dart';

class Peer {
  final Description description;
  final List<Candidate> candidates;

  const Peer({
    required this.description,
    required this.candidates,
  });
}
