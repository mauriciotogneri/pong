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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: state.isDisconnected ? state.onConnect : null,
                child: const Text('Connect'),
              ),
              const VBox(10),
              ElevatedButton(
                onPressed: state.isConnected ? state.onSend : null,
                child: const Text('Send'),
              ),
              const VBox(10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.log),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
