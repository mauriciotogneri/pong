import 'package:json_annotation/json_annotation.dart';
import 'package:pong/json/json_candidate.dart';
import 'package:pong/json/json_description.dart';
import 'package:pong/models/peer.dart';

part 'json_peer.g.dart';

@JsonSerializable()
class JsonPeer {
  @JsonKey(name: 'description')
  final JsonDescription description;

  @JsonKey(name: 'candidates')
  final List<JsonCandidate> candidates;

  JsonPeer({
    required this.description,
    required this.candidates,
  });

  Peer get object => Peer(
    description: description.object,
    candidates: candidates.map((c) => c.object).toList(),
  );

  factory JsonPeer.fromJson(Map<String, dynamic> json) =>
      _$JsonPeerFromJson(json);

  Map<String, dynamic> toJson() => _$JsonPeerToJson(this);
}
