import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pong/models/candidate.dart';
import 'package:pong/models/database.dart';
import 'package:pong/models/description.dart';
import 'package:pong/models/session.dart';

class Connection {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  final List<Candidate> _candidates = [];
  final Function(String) onMessage;
  final Function(String) onLog;

  Connection({
    required this.onMessage,
    required this.onLog,
  });

  bool get isConnected =>
      _dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen;

  Map<String, dynamic> get _sdpConstraints => {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  Future connect() async {
    _peerConnection = await _createConnection();

    final Description? description = await Database.getExistingOffer();

    if (description != null) {
      await _createAnswer(description);
    } else {
      await _createOffer();
    }
  }

  Future<RTCPeerConnection> _createConnection() async {
    final RTCPeerConnection result = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}, // Google's public STUN server
        // Add TURN server if necessary for more robust connectivity
        // {'urls': 'turn:YOUR_TURN_SERVER_URL', 'username': 'YOUR_USERNAME', 'credential': 'YOUR_PASSWORD'},
      ],
    });

    result.onIceCandidate = (candidate) {
      // TODO(momo): new candidates must be sent to the peer if they change during the connection
      onLog('New ICE candidate: ${candidate.toMap()}');
      _candidates.add(
        Candidate(
          candidate: candidate.candidate,
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
        ),
      );
    };

    result.onIceConnectionState = (state) {
      onLog('ICE connection state changed: $state');
    };

    result.onIceGatheringState = (state) {
      onLog('ICE gathering state changed: $state');
    };

    result.onConnectionState = (state) {
      onLog('Connection state changed: $state');
    };

    result.onSignalingState = (state) {
      onLog('Signaling state changed: $state');
    };

    result.onDataChannel = (channel) {
      onLog('Data channel state created');
      _dataChannel = channel;
      channel.onMessage = _onReceive;
      channel.onDataChannelState = _onStateChanged;
    };

    return result;
  }

  Future _createOffer() async {
    final RTCDataChannel channel = await _peerConnection!.createDataChannel(
      'connection',
      RTCDataChannelInit(),
    );
    _dataChannel = channel;
    // TODO(momo): set callbacks?
    //_dataChannel!.onDataChannelState
    //_dataChannel!.onMessage

    final RTCSessionDescription local = await _peerConnection!.createOffer(
      _sdpConstraints,
    );
    await _peerConnection!.setLocalDescription(local);

    await Database.createSession(
      description: Description.fromDescription(local),
      onAnswered: _onOfferAnswered,
    );
  }

  Future _createAnswer(Description description) async {
    await _setRemoteDescription(description);

    final RTCSessionDescription local = await _peerConnection!.createAnswer(
      _sdpConstraints,
    );
    await _peerConnection!.setLocalDescription(local);

    final Description answer = Description.fromDescription(local);
    print(answer);
  }

  void _onOfferAnswered(Session session) {
    _setRemoteDescription(session.callee!.description);
    // TODO(momo): send candidates
  }

  Future _setRemoteDescription(Description description) async {
    final RTCSessionDescription remote = RTCSessionDescription(
      description.sdp,
      description.type,
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

  void send(String message) {
    _dataChannel?.send(RTCDataChannelMessage(message));
    onLog('>>>: $message');
  }

  void _onReceive(RTCDataChannelMessage message) {
    onLog('<<<: ${message.text}');
    onMessage(message.text);
  }

  void _onStateChanged(RTCDataChannelState state) {
    onLog('State changed: $state');
  }
}
