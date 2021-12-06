import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProgramRating {
  FirebaseProgramRating({this.rating, this.review, this.uid, this.created_on});

  final num? rating;
  final String? review;
  final String? uid;
  final DateTime? created_on;

  FirebaseProgramRating.fromJson(Map<String, Object?> json)
      : this(
          rating: (json['rating']) as num?,
          review: json['review'] as String?,
          uid: json['uid'] as String?,
          created_on: (json['created_on'] as Timestamp).toDate(),
        );

  Map<String, Object?> toJson() {
    return {
      'rating': rating,
      'review': review,
      'uid': uid,
      'created_on': created_on,
    };
  }

  /// Get a reference to the single ref.
  DocumentReference<FirebaseProgramRating> getDocumentReference({
    required String program,
    required String docId,
  }) {
    return FirebaseFirestore.instance
        .collection('programs')
        .doc(program)
        .collection("reviews")
        .doc(docId)
        .withConverter<FirebaseProgramRating>(
          fromFirestore: (snapshot, _) =>
              FirebaseProgramRating.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  /// Don't forget to add a where clause.
  CollectionReference<FirebaseProgramRating> getCollectionReference({
    required String program,
  }) {
    return FirebaseFirestore.instance
        .collection('programs')
        .doc(program)
        .collection("reviews")
        .withConverter<FirebaseProgramRating>(
          fromFirestore: (snapshot, _) =>
              FirebaseProgramRating.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  Future<void> createRating({
    required num rating,
    required String userId,
    required String review,
    required String program,
  }) async {
    getCollectionReference(program: program).add(FirebaseProgramRating(
      rating: rating,
      review: review,
      uid: userId,
    ));
  }

  Future<void> removeRating({
    required String docId,
    required String program,
  }) async {
    getCollectionReference(program: program).doc(docId).delete();
  }

  Future<void> updateRating({
    required num rating,
    required String docId,
    required String review,
    required String program,
  }) async {
    getDocumentReference(program: program, docId: docId).update(
      {
        "rating": rating,
        "review": review,
      },
    );
  }
}
