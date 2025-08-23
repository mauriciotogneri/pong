import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pong/json/json_description.dart';
import 'package:pong/json/json_peer.dart';
import 'package:pong/json/json_session.dart';
import 'package:pong/models/description.dart';
import 'package:pong/models/session.dart';
import 'package:pong/types/session_status.dart';

class Database {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('connections');

  static Future<Description?> getExistingOffer() async {
    final QuerySnapshot snapshot = await collection
        .where('status', isEqualTo: 'offered')
        .limit(1)
        .get();

    if (snapshot.size == 1) {
      final JsonSession json = JsonSession.fromQuerySnapshot(
        snapshot.docs.first,
      );

      return json.object.caller!.description;
    } else {
      return null;
    }
  }

  static Future createSession({
    required Description description,
    required Function(Session) onAnswered,
  }) async {
    final JsonSession session = JsonSession(
      createdAt: DateTime.now(),
      caller: JsonPeer(
        description: JsonDescription(
          sdp: description.sdp,
          type: description.type,
        ),
        candidates: [],
      ),
      callee: null,
      status: SessionStatus.offered,
    );

    final Map<String, dynamic> data = session.toJson();
    final DocumentReference reference = collection.doc();
    await reference.set(data);

    reference.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final JsonSession updated = JsonSession.fromDocumentSnapshot(snapshot);

        if (updated.callee?.description != null &&
            updated.status == SessionStatus.answered) {
          onAnswered(updated.object);
        }
      }
    });
  }
}
