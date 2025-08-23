// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
