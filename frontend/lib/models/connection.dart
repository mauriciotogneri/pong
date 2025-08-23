import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pong/models/candidate.dart';
import 'package:pong/models/description.dart';

class Connection {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  final List<Candidate> _candidates = [];
  final Function(String) onMessage;

  Connection({required this.onMessage});

  bool get isConnected =>
      _dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen;

  Future connect() async {
    _peerConnection = await _createConnection();

    final Description? description = await _getExistingOffer();

    if (description != null) {
      await _createAnswer(description);
    } else {
      await _createOffer();
    }
  }

  final Map<String, dynamic> _sdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

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
      _candidates.add(
        Candidate(
          candidate: candidate.candidate,
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
        ),
      );
    };

    result.onConnectionState = (state) {
      print('Connection state changed: $state');
    };

    result.onIceConnectionState = (state) {
      print('ICE connection state changed: $state');
    };

    result.onIceGatheringState = (state) {
      print('ICE gathering state changed: $state');
    };

    result.onSignalingState = (state) {
      print('Signaling state changed: $state');
    };

    result.onDataChannel = (channel) {
      _dataChannel = channel;
      channel.onMessage = _onReceive;
      channel.onDataChannelState = _onStateChanged;
    };

    return result;
  }

  Future<Description?> _getExistingOffer() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('connections')
        .where('status', isEqualTo: 'offered')
        .limit(1)
        .get();

    if (snapshot.size == 1) {
      // TODO(momo): read snapshot
      return const Description(
        sdp: '',
        type: '',
      );
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

    final RTCSessionDescription local = await _peerConnection!.createOffer(
      _sdpConstraints,
    );
    await _peerConnection!.setLocalDescription(local);

    final Description description = Description(
      sdp: local.sdp,
      type: local.type,
    );
    print(description);
  }

  Future _createAnswer(Description description) async {
    await _setRemoteDescription(description);

    final RTCSessionDescription local = await _peerConnection!.createAnswer(
      _sdpConstraints,
    );
    await _peerConnection!.setLocalDescription(local);

    final Description answer = Description(
      sdp: local.sdp,
      type: local.type,
    );
    print(answer);
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
  }

  void _onReceive(RTCDataChannelMessage message) {
    onMessage(message.text);
  }

  void _onStateChanged(RTCDataChannelState state) {
    print('State changed: $state');
  }
}
