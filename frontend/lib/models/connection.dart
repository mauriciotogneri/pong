import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pong/models/candidate.dart';
import 'package:pong/models/database.dart';
import 'package:pong/models/description.dart';
import 'package:pong/models/peer.dart';
import 'package:pong/models/session.dart';
import 'package:pong/types/session_status.dart';

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

    await Database.searchSession(
      onOfferNeeded: _onOfferNeeded,
      onAnswerNeeded: _onAnswerNeeded,
      onCallerCandidatesReady: _onCallerCandidatesReady,
    );
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

  // ---------------------------------------------------------------------------

  Future _onOfferNeeded() async {
    onLog('Creating offer...');

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

    await Database.createOffer(
      session: Session.create(Description.fromDescription(local)),
      onAnswerReady: _onAnswerReady,
      onCalleeCandidatesReady: _onCalleeCandidatesReady,
    );
  }

  Future _onAnswerNeeded(Session session) async {
    onLog('Creating answer...');

    await _setRemoteDescription(session.caller!.description);

    final RTCSessionDescription local = await _peerConnection!.createAnswer(
      _sdpConstraints,
    );
    await _peerConnection!.setLocalDescription(local);

    final Session newSession = session
        .withCallee(
          Peer(
            description: Description.fromDescription(local),
            candidates: [],
          ),
        )
        .withStatus(SessionStatus.answer_ready);

    await Database.updateSession(newSession);
  }

  Future _onAnswerReady(Session session) async {
    await _setRemoteDescription(session.callee!.description);

    final Session newSession = session
        .withCaller(
          Peer(
            description: session.caller!.description,
            candidates: _candidates,
          ),
        )
        .withStatus(SessionStatus.caller_candidates_ready);

    await Database.updateSession(newSession);
  }

  Future _onCallerCandidatesReady(Session session) async {
    await _addCandidates(session.caller!.candidates);

    final Session newSession = session
        .withCallee(
          Peer(
            description: session.callee!.description,
            candidates: _candidates,
          ),
        )
        .withStatus(SessionStatus.callee_candidates_ready);

    await Database.updateSession(newSession);
  }

  Future _onCalleeCandidatesReady(Session session) =>
      _addCandidates(session.callee!.candidates);
}
