import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pong/models/description.dart';

class Database {
  static Future<Description?> getExistingOffer() async {
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

  static Future createOffer(Description description) =>
      FirebaseFirestore.instance.collection('connections').add({
        'sdp': description.sdp,
        'type': description.type,
        'status': 'offered',
        'timestamp': FieldValue.serverTimestamp(),
      });
}
