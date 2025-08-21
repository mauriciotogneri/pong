import 'dart:convert';
import 'package:dafluta/dafluta.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RtcState extends BaseState {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  String received = '';
  final List<dynamic> _candidates = [];

  bool get isConnected =>
      _dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen;

  Future onConnect() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    _peerConnection!.onIceCandidate = (candidate) {
      _candidates.add(candidate.toMap());
      print('ICE candidates: ${jsonEncode(_candidates)}');
    };

    _peerConnection!.onDataChannel = (channel) {
      _dataChannel = channel;
      channel.onMessage = (message) => _onReceive(message.text);
      channel.onDataChannelState = _onStateChanged;
    };

    notify();
  }

  /*Future _createOffer() async {
    final RTCDataChannel channel = await _peerConnection!.createDataChannel(
      'chat',
      RTCDataChannelInit(),
    );
    _dataChannel = channel;

    final RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    sdpController.text = jsonEncode({
      'sdp': offer.sdp,
      'type': offer.type,
    });
  }*/

  /*Future _createAnswer() async {
    final dynamic data = jsonDecode(_sdpController.text);
    final RTCSessionDescription offer = RTCSessionDescription(
      data['sdp'],
      data['type'],
    );
    await _peerConnection!.setRemoteDescription(offer);

    final RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    _sdpController.text = jsonEncode(answer.toMap());
  }*/

  /*Future _setRemoteDescription() async {
    final dynamic data = jsonDecode(_sdpController.text);
    final RTCSessionDescription answer = RTCSessionDescription(
      data['sdp'],
      data['type'],
    );
    await _peerConnection!.setRemoteDescription(answer);
  }*/

  /*Future _addCandidate() async {
    final List<dynamic> data = jsonDecode(_sdpController.text) as List<dynamic>;

    for (final dynamic element in data) {
      final RTCIceCandidate candidate = RTCIceCandidate(
        element['candidate'],
        element['sdpMid'],
        element['sdpMLineIndex'],
      );
      await _peerConnection!.addCandidate(candidate);
    }
  }*/

  void onSend() {
    _dataChannel?.send(RTCDataChannelMessage('Hello from Dart!'));
  }

  void _onReceive(String message) {
    print('Received message: $message');
    received = message;
    notify();
  }

  void _onStateChanged(RTCDataChannelState state) {
    print('State changed: $state');
    notify();
  }
}
