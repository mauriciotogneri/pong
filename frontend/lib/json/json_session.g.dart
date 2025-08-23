// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonSession _$JsonSessionFromJson(Map<String, dynamic> json) => JsonSession(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  caller: json['caller'] == null
      ? null
      : JsonPeer.fromJson(json['caller'] as Map<String, dynamic>),
  callee: json['callee'] == null
      ? null
      : JsonPeer.fromJson(json['callee'] as Map<String, dynamic>),
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
);

Map<String, dynamic> _$JsonSessionToJson(JsonSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'caller': instance.caller?.toJson(),
      'callee': instance.callee?.toJson(),
      'status': _$SessionStatusEnumMap[instance.status]!,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.offered: 'offered',
  SessionStatus.answered: 'answered',
  SessionStatus.connected: 'connected',
};
