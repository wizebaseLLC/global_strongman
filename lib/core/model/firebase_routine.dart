// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRoutine {
  FirebaseRoutine({
    this.created_on,
    this.name,
    this.description,
    this.thumbnail_url,
    this.video_url,
    this.categories,
    this.created_by,
    this.excercises,
    this.rating,
    this.views,
    this.is_public,
  });

  DateTime? created_on;
  String? name;
  String? description;
  String? thumbnail_url;
  String? video_url;
  List<dynamic>? categories;
  String? created_by;
  List<RoutineExcercise>? excercises;
  num? rating;
  num? views;
  String? is_public;

  FirebaseRoutine.fromJson(Map<String, Object?> json)
      : this(
          created_on: (json['created_on'] as Timestamp).toDate(),
          name: json['name'] as String?,
          description: json['description'] as String?,
          thumbnail_url: json['thumbnail_url'] as String?,
          video_url: json['video_url'] as String?,
          categories: json['categories'] as List<dynamic>?,
          created_by: json['created_by'] as String?,
          excercises: (json['excercises'] as List<dynamic>)
              .map((x) => RoutineExcercise.fromJson(x))
              .toList(),
          rating: json['rating'] as num?,
          views: json['views'] as num?,
          is_public: json['is_public'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'created_on': created_on,
      'name': name,
      'description': description,
      'thumbnail_url': thumbnail_url,
      'video_url': video_url,
      'categories': categories,
      'created_by': created_by,
      'rating': rating,
      'views': views,
      'is_public': is_public,
      'excercises': excercises?.map((e) => e.toJson()).toList(),
    };
  }

  /// Get a reference to the single program.
  DocumentReference<FirebaseRoutine> getDocumentReference({
    required String? doc,
  }) {
    return FirebaseFirestore.instance
        .collection('routines')
        .doc(doc)
        .withConverter<FirebaseRoutine>(
          fromFirestore: (snapshot, _) =>
              FirebaseRoutine.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  CollectionReference<FirebaseRoutine> getCollectionReference() {
    return FirebaseFirestore.instance
        .collection('routines')
        .withConverter<FirebaseRoutine>(
          fromFirestore: (snapshot, _) =>
              FirebaseRoutine.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  Future<void> addRoutine() async {
    await getCollectionReference().add(this);
  }

  Future<void> updateRoutine({
    required String userId,
    required String doc,
  }) async {
    if (userId == created_by) {
      await getDocumentReference(doc: doc).update(toJson());
    }
  }
}

class RoutineExcercise {
  RoutineExcercise({
    this.workout_id,
    this.instructions,
    this.sets,
  });

  final String? workout_id;
  final String? instructions;
  final List<RoutineSet>? sets;

  RoutineExcercise.fromJson(Map<String, Object?>? json)
      : this(
          workout_id: json?['workout_id'] as String?,
          instructions: json?['instructions'] as String?,
          sets: (json?['sets'] as List<dynamic>)
              .map((x) => RoutineSet.fromJson(x))
              .toList(),
        );

  Map<String, Object?> toJson() {
    return {
      'workout_id': workout_id,
      'instructions': instructions,
      'sets': sets?.map((e) => e.toJson()).toList(),
    };
  }
}

class RoutineSet {
  RoutineSet({
    this.rpe,
    this.reps,
    this.duration,
  });

  final num? rpe;
  final num? reps;
  final String? duration;

  RoutineSet.fromJson(Map<String, Object?>? json)
      : this(
          rpe: json?['rpe'] as num?,
          reps: json?['reps'] as num?,
          duration: json?['duration'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'rpe': rpe,
      'reps': reps,
      'duration': duration,
    };
  }
}
