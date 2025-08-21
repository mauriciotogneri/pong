import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:pong/screens/rtc_state.dart';

class RtcScreen extends StatelessWidget {
  final RtcState state;

  const RtcScreen._(this.state);

  factory RtcScreen.instance() => RtcScreen._(RtcState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateProvider<RtcState>(
        state: state,
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: state.onConnect,
                child: const Text('Connect'),
              ),
              Text('Received: ${state.received}'),
            ],
          ),
          /*Column(
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
          ),*/
        ),
      ),
    );
  }
}
