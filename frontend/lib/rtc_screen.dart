import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCExample extends StatefulWidget {
  const WebRTCExample({super.key});

  @override
  State<WebRTCExample> createState() => _WebRTCExampleState();
}

class _WebRTCExampleState extends State<WebRTCExample> {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  String _received = '';
  final TextEditingController _sdpController = TextEditingController();
  final List<dynamic> _candidates = [];

  @override
  void initState() {
    super.initState();
    _createPeerConnection();
  }

  Future _createPeerConnection() async {
    final RTCPeerConnection pc = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    pc.onIceCandidate = (candidate) {
      _candidates.add(candidate.toMap());
      print('ICE candidates: ${jsonEncode(_candidates)}');
    };

    pc.onDataChannel = (channel) {
      _dataChannel = channel;
      channel.onMessage = (msg) {
        setState(() => _received = msg.text);
      };
    };

    setState(() {
      _peerConnection = pc;
    });
  }

  Future _createOffer() async {
    final RTCDataChannel channel = await _peerConnection!.createDataChannel(
      'chat',
      RTCDataChannelInit(),
    );
    _dataChannel = channel;

    channel.onMessage = (msg) {
      setState(() => _received = msg.text);
    };

    channel.onDataChannelState = (state) {
      print('DataChannel state: $state');
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        setState(() {});
      }
    };

    final RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    _sdpController.text = jsonEncode({
      'sdp': offer.sdp,
      'type': offer.type,
    });
  }

  Future _createAnswer() async {
    final dynamic data = jsonDecode(_sdpController.text);
    final RTCSessionDescription offer = RTCSessionDescription(
      data['sdp'],
      data['type'],
    );
    await _peerConnection!.setRemoteDescription(offer);

    final RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    _sdpController.text = jsonEncode(answer.toMap());
  }

  Future _setRemoteDescription() async {
    final dynamic data = jsonDecode(_sdpController.text);
    final RTCSessionDescription answer = RTCSessionDescription(
      data['sdp'],
      data['type'],
    );
    await _peerConnection!.setRemoteDescription(answer);
  }

  Future _addCandidate() async {
    final List<dynamic> data = jsonDecode(_sdpController.text) as List<dynamic>;

    for (final dynamic element in data) {
      final RTCIceCandidate candidate = RTCIceCandidate(
        element['candidate'],
        element['sdpMid'],
        element['sdpMLineIndex'],
      );
      await _peerConnection!.addCandidate(candidate);
    }
  }

  void _sendMessage() {
    _dataChannel?.send(RTCDataChannelMessage('Hello from Dart!'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebRTC DataChannel Example')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _createOffer,
              child: const Text('Create Offer'),
            ),
            ElevatedButton(
              onPressed: _createAnswer,
              child: const Text('Create Answer'),
            ),
            ElevatedButton(
              onPressed: _addCandidate,
              child: const Text('Add Candidates'),
            ),
            ElevatedButton(
              onPressed: _setRemoteDescription,
              child: const Text('Set Remote Description'),
            ),
            TextField(
              controller: _sdpController,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Paste here',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen
                  ? _sendMessage
                  : null,
              child: const Text('Send Message'),
            ),
            Text('Received: $_received'),
          ],
        ),
      ),
    );
  }
}
