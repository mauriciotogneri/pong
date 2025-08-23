import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pong/json/json_session.dart';
import 'package:pong/models/description.dart';
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
      final Map<String, dynamic> data =
          snapshot.docs.first.data() as Map<String, dynamic>;
      final JsonSession json = JsonSession.fromJson(data);

      return json.object.callerDescription;
    } else {
      return null;
    }
  }

  static Future createSession(Description description) async {
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

    await collection.add(session.toJson());
  }
}
