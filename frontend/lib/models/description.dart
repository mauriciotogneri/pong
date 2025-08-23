import 'package:flutter_webrtc/flutter_webrtc.dart';

class Description {
  final String? sdp;
  final String? type;

  const Description({
    required this.sdp,
    required this.type,
  });

  factory Description.fromDescription(
    RTCSessionDescription description,
  ) {
    return Description(
      sdp: description.sdp,
      type: description.type,
    );
  }
}
