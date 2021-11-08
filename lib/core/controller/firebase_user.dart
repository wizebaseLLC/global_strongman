import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUser {
  FirebaseUser({
    this.age,
    this.avatar,
    this.experience,
    this.first_name,
    this.last_name,
    this.gender,
    this.height,
    this.weight,
    this.goals,
    this.injuries,
    required this.email,
  });

  final String? age;
  final String? avatar;
  final String email;
  final String? experience;
  final String? first_name;
  final String? last_name;
  final String? gender;
  final String? height;
  final String? weight;
  final List<dynamic>? goals;
  final List<dynamic>? injuries;

  FirebaseUser.fromJson(Map<String, Object?> json)
      : this(
          age: json['age'].toString(),
          avatar: json['avatar'] as String?,
          email: json['email'] as String,
          experience: json['experience'] as String?,
          first_name: json['first_name'] as String?,
          last_name: json['last_name'] as String?,
          gender: json['gender'] as String?,
          height: json['height'] as String?,
          weight: json['weight'] as String?,
          goals: json['goals'] as List<dynamic>?,
          injuries: json['injuries'] as List<dynamic>?,
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

  /// Get a reference to the single user.
  DocumentReference<FirebaseUser> getDocumentReference() {
    return FirebaseFirestore.instance.collection('users').doc(email).withConverter<FirebaseUser>(
          fromFirestore: (snapshot, _) => FirebaseUser.fromJson(snapshot.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  /// Don't forget to add a where clause.
  CollectionReference<FirebaseUser> getCollectionReference() {
    return FirebaseFirestore.instance.collection('users').withConverter<FirebaseUser>(
          fromFirestore: (snapshot, _) => FirebaseUser.fromJson(snapshot.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );
  }

  /// Gets current logged in user.
  static User? getSignedInUserFromFireStore() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print(e);
    }
  }
}
