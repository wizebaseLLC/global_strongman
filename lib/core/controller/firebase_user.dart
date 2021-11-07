import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUser {
  FirebaseUser(
      {required this.age,
      this.avatar,
      this.experience,
      required this.first_name,
      required this.last_name,
      this.gender,
      required this.height,
      required this.weight,
      this.goals,
      this.injuries,
      required this.email});

  final int age;
  final String? avatar;
  final String email;
  final String? experience;
  final String first_name;
  final String last_name;
  final String? gender;
  final String height;
  final String weight;
  final List<String>? goals;
  final List<String>? injuries;

  FirebaseUser.fromJson(Map<String, Object?> json)
      : this(
          age: json['age']! as int,
          avatar: json['avatar']! as String?,
          email: json['email']! as String,
          experience: json['experience']! as String?,
          first_name: json['first_name']! as String,
          last_name: json['last_name']! as String,
          gender: json['gender']! as String?,
          height: json['height']! as String,
          weight: json['weight']! as String,
          goals: json['goals']! as List<String>?,
          injuries: json['injuries']! as List<String>?,
        );

  Map<String, Object?> toJson() {
    return {
      'age': age,
      'avatar': avatar,
      'experience': experience,
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'height': height,
      'weight': weight,
      'goals': goals,
      'injuries': injuries,
    };
  }

  DocumentReference<FirebaseUser> getDocumentReference() {
    return FirebaseFirestore.instance.collection('users').doc(email).withConverter<FirebaseUser>(
          fromFirestore: (snapshot, _) => FirebaseUser.fromJson(snapshot.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );
  }
}
