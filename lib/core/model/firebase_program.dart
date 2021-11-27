import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:global_strongman/core/model/ProgressGalleryCard.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_controller.dart';

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
    this.is_gallery_public,
    this.injuries,
    required this.email,
  });

  final int? age;
  final String? avatar;
  final String email;
  final String? experience;
  final String? first_name;
  final String? last_name;
  final String? gender;
  final String? height;
  final String? weight;
  final bool? is_gallery_public;
  final List<dynamic>? goals;
  final List<dynamic>? injuries;

  FirebaseUser.fromJson(Map<String, Object?> json)
      : this(
          age: json['age'] as int?,
          avatar: json['avatar'] as String?,
          email: json['email'] as String,
          experience: json['experience'] as String?,
          first_name: json['first_name'] as String?,
          last_name: json['last_name'] as String?,
          gender: json['gender'] as String?,
          height: json['height'] as String?,
          weight: json['weight'] as String?,
          is_gallery_public: json['is_gallery_public'] as bool?,
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
      "is_gallery_public": is_gallery_public,
    };
  }

  /// Get a reference to the single user.
  DocumentReference<FirebaseUser> getDocumentReference() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .withConverter<FirebaseUser>(
          fromFirestore: (snapshot, _) =>
              FirebaseUser.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  /// Don't forget to add a where clause.
  CollectionReference<FirebaseUser> getCollectionReference() {
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<FirebaseUser>(
          fromFirestore: (snapshot, _) =>
              FirebaseUser.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );
  }

  /// Get a reference to the entire collection.
  /// Don't forget to add a where clause.
  CollectionReference<ProgressGalleryCard>
      getProgressGalleryCollectionReference() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection("progress_photos")
        .withConverter<ProgressGalleryCard>(
          fromFirestore: (snapshot, _) =>
              ProgressGalleryCard.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
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

  /// Updates user Avatar image and firestore's reference to it.
  Future<void> addUserAvatarToStorage({
    required BuildContext context,
    required File file,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref("Users")
          .child(email)
          .child("/avatar.jpg");
      TaskSnapshot uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      getDocumentReference().update({"avatar": url});
    } catch (e) {
      SignInController().showDialog(context, "Failed to upload image: $e");
    }
  }

  /// Adds a progress Photo to storage
  Future<void> addProgressPhoto({
    required BuildContext context,
    required File file,
    required DateTime date,
    String? weight,
    String? bust,
    String? bmi,
    String? waist,
    String? hip,
    String? bodyFat,
    String? description,
  }) async {
    try {
      final imageName = "/${DateTime.now().toString()}";
      final Reference ref = FirebaseStorage.instance
          .ref("Users")
          .child(email)
          .child("progress_photos")
          .child(imageName);

      TaskSnapshot uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      getDocumentReference().collection("progress_photos").add({
        "url": url,
        "date": date,
        "weight": weight,
        "bust": bust,
        "bmi": bmi,
        "waist": waist,
        "hip": hip,
        "bodyFat": bodyFat,
        "description": description,
        "file_name": imageName
      });
    } catch (e) {
      SignInController().showDialog(context, "Failed to upload image: $e");
    }
  }

  /// Removes a progress Photo to storage
  Future<void> removeProgressPhotoFromStorage({
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref("Users")
          .child(email)
          .child("progress_photos")
          .child(fileName);

      ref.delete();
    } catch (e) {
      SignInController().showDialog(context, "Failed to upload image: $e");
    }
  }
}
