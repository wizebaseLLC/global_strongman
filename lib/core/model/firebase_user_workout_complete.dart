// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserWorkoutComplete {
  FirebaseUserWorkoutComplete({
    this.created_on,
    this.program_id,
    this.workout_id,
    this.day,
    this.categories,
    this.notes,
    this.working_sets,
    this.name,
  });

  final DateTime? created_on;
  final String? program_id;
  final String? workout_id;
  final String? notes;
  final String? day;
  final String? name;
  final List<dynamic>? working_sets;
  final List<dynamic>? categories;

  FirebaseUserWorkoutComplete.fromJson(Map<String, Object?> json)
      : this(
          created_on: (json['created_on'] as Timestamp).toDate(),
          program_id: json['program_id'] as String?,
          workout_id: json['workout_id'] as String?,
          notes: json['notes'] as String?,
          name: json['name'] as String?,
          day: json['day'] as String?,
          categories: json['categories'] as List<dynamic>?,
          working_sets: json['working_sets'] as List<dynamic>?,
        );

  Map<String, Object?> toJson() {
    return {
      'created_on': created_on,
      'program_id': program_id,
      'workout_id': workout_id,
      'categories': categories,
      'day': day,
      'notes': notes,
      'name': name,
      'working_sets': working_sets,
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
    required String? user,
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

class WorkoutSetListItem {
  WorkoutSetListItem({
    this.working_weight_lbs,
    this.working_weight_kgs,
    this.duration,
    this.reps,
  });
  final num? working_weight_lbs;
  final num? working_weight_kgs;
  final String? duration;
  final num? reps;

  WorkoutSetListItem.fromJson(Map<String, Object?> json)
      : this(
          working_weight_lbs: json['working_weight_lbs'] as num?,
          working_weight_kgs: json['working_weight_kgs'] as num?,
          duration: json['duration'] as String?,
          reps: json['reps'] as num?,
        );

  Map<String, Object?> toJson() {
    return {
      'working_weight_lbs': working_weight_lbs,
      'working_weight_kgs': working_weight_kgs,
      'duration': duration,
      'reps': reps,
    };
  }
}
