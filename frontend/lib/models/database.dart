import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pong/json/json_session.dart';
import 'package:pong/models/candidate.dart';
import 'package:pong/models/session.dart';
import 'package:pong/types/session_status.dart';

class Database {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('connections');

  static Future searchSession({
    required Function() onOfferNeeded,
    required Function(Session) onAnswerNeeded,
    required Function(List<Candidate>) onCandidatesReady,
  }) async {
    final QuerySnapshot snapshot = await collection
        .where('status', isEqualTo: SessionStatus.offered.name)
        .limit(1)
        .get();

    if (snapshot.size == 1) {
      final QueryDocumentSnapshot doc = snapshot.docs.first;
      final JsonSession json = JsonSession.fromQuerySnapshot(doc);
      await onAnswerNeeded(json.object);

      StreamSubscription? subscription;
      subscription = doc.reference.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          final JsonSession json = JsonSession.fromDocumentSnapshot(snapshot);
          final Session session = json.object;

          if (session.hasCallerCandidates) {
            onCandidatesReady(session.caller!.candidates);
            subscription?.cancel();
          }
        }
      });
    } else {
      await onOfferNeeded();
    }
  }

  static Future createOffer({
    required Session session,
    required Function(Session) onAnswerReady,
    required Function(List<Candidate>) onCandidatesReady,
  }) async {
    final DocumentReference doc = collection.doc();
    final JsonSession json = session.withId(doc.id).toJson();
    await doc.set(json.toJson());

    StreamSubscription? subscription;
    subscription = doc.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final JsonSession json = JsonSession.fromDocumentSnapshot(snapshot);
        final Session session = json.object;

        if (session.isAnswered) {
          onAnswerReady(session);
        } else if (session.hasCalleeCandidates) {
          onCandidatesReady(session.callee!.candidates);
          subscription?.cancel();
        }
      }
    });
  }

  static Future updateSession(Session session) async {
    final JsonSession json = session.toJson();
    final DocumentReference doc = collection.doc(session.id);
    await doc.set(json.toJson());
  }
}
