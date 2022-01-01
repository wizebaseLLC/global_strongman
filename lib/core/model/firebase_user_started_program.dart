// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserStartedProgram {
  FirebaseUserStartedProgram({
    this.program_id,
    this.started_on,
    this.is_active,
  });

  final String? program_id;
  final DateTime? started_on;
  final bool? is_active;

  FirebaseUserStartedProgram.fromJson(Map<String, Object?> json)
      : this(
          program_id: json['program_id'] as String?,
          is_active: json['is_active'] as bool?,
          started_on: (json['started_on'] as Timestamp?)?.toDate(),
        );

  Map<String, Object?> toJson() {
    return {
      'program_id': program_id,
      'is_active': is_active,
      'started_on': started_on,
    };
  }

  /// Get a reference to the single ref.
  DocumentReference<FirebaseUserStartedProgram> getDocumentReference({
    required String userId,
    required String docId,
  }) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("programs")
        .doc(docId)
        .withConverter<FirebaseUserStartedProgram>(
          fromFirestore: (snapshot, _) =>
              FirebaseUserStartedProgram.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  /// Don't forget to add a where clause.
  CollectionReference<FirebaseUserStartedProgram> getCollectionReference({
    required String userId,
  }) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("programs")
        .withConverter<FirebaseUserStartedProgram>(
          fromFirestore: (snapshot, _) =>
              FirebaseUserStartedProgram.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  Future<void> createStartedPrograms({
    required String programId,
    required String userId,
  }) async {
    getCollectionReference(userId: userId).add(FirebaseUserStartedProgram(
      is_active: true,
      started_on: DateTime.now(),
      program_id: programId,
    ));
  }

  Future<void> toggleProgramActiveState({
    required bool state,
    required String programId,
    required String userId,
    required String docId,
  }) async {
    getDocumentReference(userId: userId, docId: docId).update(
      {
        "is_active": state,
      },
    );
  }
}
