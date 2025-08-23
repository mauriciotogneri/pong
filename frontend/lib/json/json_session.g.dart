// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonSession _$JsonSessionFromJson(Map<String, dynamic> json) => JsonSession(
  createdAt: DateTime.parse(json['createdAt'] as String),
  callerDescription: json['callerDescription'] == null
      ? null
      : JsonDescription.fromJson(
          json['callerDescription'] as Map<String, dynamic>,
        ),
  calleeDescription: json['calleeDescription'] == null
      ? null
      : JsonDescription.fromJson(
          json['calleeDescription'] as Map<String, dynamic>,
        ),
  callerCandidates: (json['callerCandidates'] as List<dynamic>?)
      ?.map((e) => JsonCandidate.fromJson(e as Map<String, dynamic>))
      .toList(),
  calleeCandidates: (json['calleeCandidates'] as List<dynamic>?)
      ?.map((e) => JsonCandidate.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
);

Map<String, dynamic> _$JsonSessionToJson(JsonSession instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'callerDescription': instance.callerDescription,
      'calleeDescription': instance.calleeDescription,
      'callerCandidates': instance.callerCandidates,
      'calleeCandidates': instance.calleeCandidates,
      'status': _$SessionStatusEnumMap[instance.status]!,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.offered: 'offered',
  SessionStatus.answered: 'answered',
  SessionStatus.connected: 'connected',
};

JsonDescription _$JsonDescriptionFromJson(Map<String, dynamic> json) =>
    JsonDescription(sdp: json['sdp'] as String?, type: json['type'] as String?);

Map<String, dynamic> _$JsonDescriptionToJson(JsonDescription instance) =>
    <String, dynamic>{'sdp': instance.sdp, 'type': instance.type};

JsonCandidate _$JsonCandidateFromJson(Map<String, dynamic> json) =>
    JsonCandidate(
      candidate: json['candidate'] as String?,
      sdpMid: json['sdpMid'] as String?,
      sdpMLineIndex: (json['sdpMLineIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JsonCandidateToJson(JsonCandidate instance) =>
    <String, dynamic>{
      'candidate': instance.candidate,
      'sdpMid': instance.sdpMid,
      'sdpMLineIndex': instance.sdpMLineIndex,
    };
