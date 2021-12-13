import 'package:cloud_firestore/cloud_firestore.dart';

enum Programs {
  beginner,
  intermediate_strongman_program,
}

class FirebaseProgram {
  FirebaseProgram({
    this.created_on,
    this.description,
    this.duration,
    this.long_description,
    this.long_video_url,
    this.name,
    this.progression,
    this.workout_count,
    this.thumbnail_url,
    this.warmup,
    this.average_rating,
    this.rating_count,
  });

  final DateTime? created_on;
  final String? description;
  final int? duration;
  final int? workout_count;
  final String? long_description;
  final String? long_video_url;
  final String? name;
  final String? progression;
  final String? thumbnail_url;
  final String? warmup;
  final num? average_rating;
  final int? rating_count;

  FirebaseProgram.fromJson(Map<String, Object?> json)
      : this(
          workout_count: json['workout_count'] as int?,
          created_on: (json['created_on'] as Timestamp).toDate(),
          description: json['description'] as String?,
          duration: json['duration'] as int?,
          long_description: json['long_description'] as String?,
          long_video_url: json['long_video_url'] as String?,
          name: json['name'] as String?,
          progression: json['progression'] as String?,
          thumbnail_url: json['thumbnail_url'] as String?,
          warmup: json['warmup'] as String?,
          average_rating: json['average_rating'] as num?,
          rating_count: json['rating_count'] as int?,
        );

  Map<String, Object?> toJson() {
    return {
      'workout_count': workout_count,
      'created_on': created_on,
      'description': description,
      'duration': duration,
      'long_description': long_description,
      'long_video_url': long_video_url,
      'name': name,
      'progression': progression,
      'thumbnail_url': thumbnail_url,
      'warmup': warmup,
      'average_rating': average_rating,
      'rating_count': rating_count,
    };
  }

  /// Get a reference to the single program.
  DocumentReference<FirebaseProgram> getDocumentReference(Programs program) {
    return FirebaseFirestore.instance
        .collection('programs')
        .doc(program.toString())
        .withConverter<FirebaseProgram>(
          fromFirestore: (snapshot, _) =>
              FirebaseProgram.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the single program.
  DocumentReference<FirebaseProgram> getDocumentReferenceByString(
      String program) {
    return FirebaseFirestore.instance
        .collection('programs')
        .doc(program)
        .withConverter<FirebaseProgram>(
          fromFirestore: (snapshot, _) =>
              FirebaseProgram.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  /// Don't forget to add a where clause.
  CollectionReference<FirebaseProgram> getCollectionReference() {
    return FirebaseFirestore.instance
        .collection('programs')
        .withConverter<FirebaseProgram>(
          fromFirestore: (snapshot, _) =>
              FirebaseProgram.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }
}
