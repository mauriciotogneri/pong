import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pong/json/json_session.dart';
import 'package:pong/models/candidate.dart';
import 'package:pong/models/description.dart';
import 'package:pong/models/session.dart';
import 'package:pong/types/session_status.dart';

class Database {
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('connections');

  static Future searchSession({
    required Function() onOfferNeeded,
    required Function(Session) onAnswerNeeded,
  }) async {
    final QuerySnapshot snapshot = await collection
        .where('status', isEqualTo: SessionStatus.offered.name)
        .limit(1)
        .get();

    if (snapshot.size == 1) {
      final JsonSession json = JsonSession.fromQuerySnapshot(
        snapshot.docs.first,
      );

      await onAnswerNeeded(json.object);
    } else {
      await onOfferNeeded();
    }
  }

  static Future offerCreated({
    required Description description,
    required Function(Session) onAnswered,
  }) async {
    final Session session = Session.create(description);
    final JsonSession json = session.toJson();
    final DocumentReference reference = await collection.add(json.toJson());

    StreamSubscription? subscription;
    subscription = reference.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final JsonSession json = JsonSession.fromDocumentSnapshot(snapshot);
        final Session session = json.object;

        if (session.isAnswered) {
          onAnswered(session);
          subscription?.cancel();
        }
      }
    });
  }

  static Future answerCreated({
    required Session session,
    required Function(List<Candidate>) onCallerCandidatesReady,
  }) async {
    final JsonSession json = session.toJson();
    final DocumentReference reference = await collection.add(json.toJson());

    StreamSubscription? subscription;
    subscription = reference.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final JsonSession json = JsonSession.fromDocumentSnapshot(snapshot);
        final Session session = json.object;

        if (session.hasCallerCandidates) {
          onCallerCandidatesReady(session.caller!.candidates);
          subscription?.cancel();
        }
      }
    });
  }
}
