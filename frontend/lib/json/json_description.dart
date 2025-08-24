import 'package:json_annotation/json_annotation.dart';
import 'package:webrtc/models/description.dart';

part 'json_description.g.dart';

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
