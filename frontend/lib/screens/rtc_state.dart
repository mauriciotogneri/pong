import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dafluta/dafluta.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pong/models/answer.dart';
import 'package:pong/models/candidate.dart';
import 'package:pong/models/offer.dart';

class RtcState extends BaseState {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  String received = '';
  final List<Candidate> _candidates = [];

  bool get isConnected =>
      _dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen;

  Future onConnect() async {
    _peerConnection = await _createConnection();

    final Offer? offer = await _getExistingOffer();

    if (offer != null) {
      await _createAnswer(offer);
    } else {
      await _createOffer();
    }
  }

  Future<RTCPeerConnection> _createConnection() async {
    final RTCPeerConnection result = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    result.onIceCandidate = (candidate) {
      _candidates.add(
        Candidate(
          candidate: candidate.candidate,
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
        ),
      );
    };

    result.onDataChannel = (channel) {
      _dataChannel = channel;
      channel.onMessage = _onReceive;
      channel.onDataChannelState = _onStateChanged;
    };

    return result;
  }

  Future<Offer?> _getExistingOffer() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('connections')
        .where('status', isEqualTo: 'offered')
        .limit(1)
        .get();

    if (snapshot.size == 1) {
      return null; // snapshot.docs.first.data();
    } else {
      return null;
    }
  }

  Future _createOffer() async {
    final RTCDataChannel channel = await _peerConnection!.createDataChannel(
      'chat',
      RTCDataChannelInit(),
    );
    _dataChannel = channel;
    // TODO(momo): set callbacks?

    final RTCSessionDescription local = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(local);

    final Offer offer = Offer(
      sdp: local.sdp,
      type: local.type,
    );
    print(offer);
  }

  Future _createAnswer(Offer offer) async {
    final RTCSessionDescription remote = RTCSessionDescription(
      offer.sdp,
      offer.type,
    );
    await _peerConnection!.setRemoteDescription(remote);

    final RTCSessionDescription local = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(local);

    final Answer answer = Answer(
      sdp: local.sdp,
      type: local.type,
    );
    print(answer);
  }

  Future _setRemoteDescription(Answer answer) async {
    final RTCSessionDescription remote = RTCSessionDescription(
      answer.sdp,
      answer.type,
    );
    await _peerConnection!.setRemoteDescription(remote);
  }

  Future _addCandidates(List<Candidate> candidates) async {
    for (final Candidate candidate in candidates) {
      await _peerConnection!.addCandidate(
        RTCIceCandidate(
          candidate.candidate,
          candidate.sdpMid,
          candidate.sdpMLineIndex,
        ),
      );
    }
  }

  void onSend() {
    _dataChannel?.send(RTCDataChannelMessage('Hello from Dart!'));
  }

  void _onReceive(RTCDataChannelMessage message) {
    print('Received message: $message');
    received = message.text;
    notify();
  }

  void _onStateChanged(RTCDataChannelState state) {
    print('State changed: $state');
    notify();
  }
}
