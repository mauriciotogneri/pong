import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pong/json/json_session.dart';
import 'package:pong/models/description.dart';

class Database {
  static Future<Description?> getExistingOffer() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('connections')
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

  static Future createOffer(Description description) =>
      FirebaseFirestore.instance.collection('connections').add({
        'sdp': description.sdp,
        'type': description.type,
        'status': 'offered',
        'timestamp': FieldValue.serverTimestamp(),
      });
}
