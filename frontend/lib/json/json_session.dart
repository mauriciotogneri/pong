import 'package:json_annotation/json_annotation.dart';
import 'package:pong/models/candidate.dart';
import 'package:pong/models/description.dart';
import 'package:pong/models/session.dart';
import 'package:pong/types/session_status.dart';

part 'json_session.g.dart';

@JsonSerializable()
class JsonSession {
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'callerDescription')
  final JsonDescription? callerDescription;

  @JsonKey(name: 'calleeDescription')
  final JsonDescription? calleeDescription;

  @JsonKey(name: 'callerCandidates')
  final List<JsonCandidate>? callerCandidates;

  @JsonKey(name: 'calleeCandidates')
  final List<JsonCandidate>? calleeCandidates;

  @JsonKey(name: 'status')
  final SessionStatus status;

  JsonSession({
    required this.createdAt,
    required this.callerDescription,
    required this.calleeDescription,
    required this.callerCandidates,
    required this.calleeCandidates,
    required this.status,
  });

  Session get object => Session(
    callerDescription: callerDescription?.object,
    calleeDescription: calleeDescription?.object,
    callerCandidates: callerCandidates?.map((c) => c.object).toList() ?? [],
    calleeCandidates: calleeCandidates?.map((c) => c.object).toList() ?? [],
    status: status,
  );

  factory JsonSession.fromJson(Map<String, dynamic> json) =>
      _$JsonSessionFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSessionToJson(this);
}

@JsonSerializable()
class JsonDescription {
  @JsonKey(name: 'sdp')
  final String? sdp;

  @JsonKey(name: 'type')
  final String? type;

  JsonDescription({
    required this.sdp,
    required this.type,
  });

  Description get object => Description(
    sdp: sdp,
    type: type,
  );

  factory JsonDescription.fromJson(Map<String, dynamic> json) =>
      _$JsonDescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$JsonDescriptionToJson(this);
}

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
