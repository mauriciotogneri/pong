import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webrtc/json/json_peer.dart';
import 'package:webrtc/models/session.dart';
import 'package:webrtc/types/session_status.dart';

part 'json_session.g.dart';

@JsonSerializable()
class JsonSession {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'caller')
  final JsonPeer? caller;

  @JsonKey(name: 'callee')
  final JsonPeer? callee;

  @JsonKey(name: 'status')
  final SessionStatus status;

  JsonSession({
    required this.id,
    required this.createdAt,
    required this.caller,
    required this.callee,
    required this.status,
  });

  Session get object => Session(
    id: id,
    createdAt: createdAt,
    caller: caller?.object,
    callee: callee?.object,
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
