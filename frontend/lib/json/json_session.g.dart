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
      'callerDescription': instance.callerDescription?.toJson(),
      'calleeDescription': instance.calleeDescription?.toJson(),
      'callerCandidates': instance.callerCandidates
          ?.map((e) => e.toJson())
          .toList(),
      'calleeCandidates': instance.calleeCandidates
          ?.map((e) => e.toJson())
          .toList(),
      'status': _$SessionStatusEnumMap[instance.status]!,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.offered: 'offered',
  SessionStatus.answered: 'answered',
  SessionStatus.connected: 'connected',
};
