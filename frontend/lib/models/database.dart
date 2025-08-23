import 'package:cloud_firestore/cloud_firestore.dart';
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

      return json.object.callerDescription;
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
      callerDescription: JsonDescription(
        sdp: description.sdp,
        type: description.type,
      ),
      calleeDescription: null,
      callerCandidates: [],
      calleeCandidates: [],
      status: SessionStatus.offered,
    );

    final DocumentReference reference = await collection.add(session.toJson());

    reference.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final JsonSession updated = JsonSession.fromDocumentSnapshot(snapshot);

        if (updated.calleeDescription != null &&
            updated.status == SessionStatus.answered) {
          onAnswered(updated.object);
        }
      }
    });
  }
}
