import 'package:cloud_firestore/cloud_firestore.dart';

enum ProgramDays {
  day_1,
  day_2,
  day_3,
}

class FirebaseProgramWorkouts {
  FirebaseProgramWorkouts({
    this.description,
    this.long_video_url,
    this.name,
    this.order,
    this.reps,
    this.sets,
    this.short_video_url,
    this.thumbnail,
    this.minutes,
    this.percent,
    this.weekly_increment,
  });

  final String? description;
  final String? long_video_url;
  final String? name;
  final int? order;
  final int? reps;
  final int? sets;
  final String? short_video_url;
  final String? thumbnail;
  final int? minutes;
  final String? percent;
  final int? weekly_increment;

  FirebaseProgramWorkouts.fromJson(Map<String, Object?> json)
      : this(
          description: json['description'] as String?,
          long_video_url: json['long_video_url'] as String?,
          name: json['name'] as String?,
          order: json['order'] as int?,
          reps: json['reps'] as int?,
          sets: json['sets'] as int?,
          short_video_url: json['short_video_url'] as String?,
          thumbnail: json['thumbnail'] as String?,
          minutes: json['minutes'] as int?,
          percent: json['percent'] as String?,
          weekly_increment: json['weekly_increment'] as int?,
        );

  Map<String, Object?> toJson() {
    return {
      'description': description,
      'long_video_url': long_video_url,
      'name': name,
      'order': order,
      'reps': reps,
      'sets': sets,
      'short_video_url': short_video_url,
      'thumbnail': thumbnail,
      'minutes': minutes,
      'percent': percent,
      'weekly_increment': weekly_increment
    };
  }

  // /// Get a reference to the single program.
  // DocumentReference<FirebaseProgramWorkouts> getDocumentReference(
  //     Programs program) {
  //   return FirebaseFirestore.instance
  //       .collection('programs')
  //       .doc(program.toString())
  //       .withConverter<FirebaseProgramWorkouts>(
  //         fromFirestore: (snapshot, _) =>
  //             FirebaseProgramWorkouts.fromJson(snapshot.data()!),
  //         toFirestore: (data, _) => data.toJson(),
  //       );
  // }

  /// Get a reference to the entire collection.
  /// Don't forget to add a where clause.
  CollectionReference<FirebaseProgramWorkouts> getCollectionReference({
    required String program,
    required ProgramDays day,
  }) {
    return FirebaseFirestore.instance
        .collection('programs')
        .doc(program)
        .collection(day.toString().replaceAll("ProgramDays.", ""))
        .withConverter<FirebaseProgramWorkouts>(
          fromFirestore: (snapshot, _) =>
              FirebaseProgramWorkouts.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }
}
