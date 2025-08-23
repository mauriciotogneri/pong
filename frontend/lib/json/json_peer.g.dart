// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_peer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPeer _$JsonPeerFromJson(Map<String, dynamic> json) => JsonPeer(
  description: JsonDescription.fromJson(
    json['description'] as Map<String, dynamic>,
  ),
  candidates: (json['candidates'] as List<dynamic>)
      .map((e) => JsonCandidate.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JsonPeerToJson(JsonPeer instance) => <String, dynamic>{
  'description': instance.description.toJson(),
  'candidates': instance.candidates.map((e) => e.toJson()).toList(),
};
