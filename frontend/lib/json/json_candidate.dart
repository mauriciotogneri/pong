import 'package:json_annotation/json_annotation.dart';
import 'package:webrtc/models/candidate.dart';

part 'json_candidate.g.dart';

@JsonSerializable()
class JsonCandidate {
  @JsonKey(name: 'candidate')
  final String? candidate;

  @JsonKey(name: 'sdpMid')
  final String? sdpMid;

  @JsonKey(name: 'sdpMLineIndex')
  final int? sdpMLineIndex;

  JsonCandidate({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
  });

  Candidate get object => Candidate(
    candidate: candidate,
    sdpMid: sdpMid,
    sdpMLineIndex: sdpMLineIndex,
  );

  factory JsonCandidate.fromJson(Map<String, dynamic> json) =>
      _$JsonCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$JsonCandidateToJson(this);
}
