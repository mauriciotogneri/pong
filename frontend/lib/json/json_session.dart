import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pong/json/json_candidate.dart';
import 'package:pong/json/json_description.dart';
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

  factory JsonSession.fromQuerySnapshot(QueryDocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return JsonSession.fromJson(data);
  }

  factory JsonSession.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return JsonSession.fromJson(data);
  }

  factory JsonSession.fromJson(Map<String, dynamic> json) =>
      _$JsonSessionFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSessionToJson(this);
}
