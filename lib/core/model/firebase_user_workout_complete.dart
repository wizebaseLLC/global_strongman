// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserWorkoutComplete {
  FirebaseUserWorkoutComplete({
    this.created_on,
    this.program_id,
    this.workout_id,
    this.day,
    this.working_weight_lbs,
    this.working_weight_kgs,
    this.seconds,
    this.categories,
    this.weight_used_string,
    this.notes,
    this.name,
    this.thumbnail,
  });

  final DateTime? created_on;
  final String? program_id;
  final String? workout_id;
  final String? notes;
  final String? weight_used_string;
  final String? day;
  final String? name;
  final String? thumbnail;
  final num? working_weight_lbs;
  final num? working_weight_kgs;
  final num? seconds;
  final List<dynamic>? categories;

  FirebaseUserWorkoutComplete.fromJson(Map<String, Object?> json)
      : this(
          created_on: (json['created_on'] as Timestamp).toDate(),
          program_id: json['program_id'] as String?,
          workout_id: json['workout_id'] as String?,
          notes: json['notes'] as String?,
          weight_used_string: json['weight_used_string'] as String?,
          name: json['name'] as String?,
          thumbnail: json['thumbnail'] as String?,
          day: json['day'] as String?,
          working_weight_lbs: json['working_weight_lbs'] as num?,
          working_weight_kgs: json['working_weight_kgs'] as num?,
          seconds: json['seconds'] as num?,
          categories: json['categories'] as List<dynamic>?,
        );

  Map<String, Object?> toJson() {
    return {
      'created_on': created_on,
      'program_id': program_id,
      'workout_id': workout_id,
      'working_weight_lbs': working_weight_lbs,
      'working_weight_kgs': working_weight_kgs,
      'seconds': seconds,
      'categories': categories,
      'day': day,
      'weight_used_string': weight_used_string,
      'notes': notes,
      'thumbnail': thumbnail,
      'name': name,
    };
  }

  /// Get a reference to the single program.
  DocumentReference<FirebaseUserWorkoutComplete> getDocumentReference({
    required String doc,
    required String user,
  }) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection("completed_workouts")
        .doc(doc)
        .withConverter<FirebaseUserWorkoutComplete>(
          fromFirestore: (snapshot, _) =>
              FirebaseUserWorkoutComplete.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  CollectionReference<FirebaseUserWorkoutComplete> getCollectionReference({
    required String user,
  }) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection("completed_workouts")
        .withConverter<FirebaseUserWorkoutComplete>(
          fromFirestore: (snapshot, _) =>
              FirebaseUserWorkoutComplete.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  Future<void> addCompletedWorkout({
    required String user,
  }) async {
    getCollectionReference(user: user).add(this);
  }
}
