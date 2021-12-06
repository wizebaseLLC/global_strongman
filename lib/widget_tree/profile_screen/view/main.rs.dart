import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profileBody.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const bool usesAppbar = false;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  Stream<DocumentSnapshot<FirebaseUser>> _firebaseUserStream() {
    final User authenticatedUser = FirebaseUser.getSignedInUserFromFireStore()!;
    return FirebaseUser(email: authenticatedUser.email!)
        .getDocumentReference()
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseUserStream(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<FirebaseUser>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final FirebaseUser streamedUser = snapshot.data!.data()!;
        return ProfileBody(firebaseUser: streamedUser);
      },
    );
  }
}
