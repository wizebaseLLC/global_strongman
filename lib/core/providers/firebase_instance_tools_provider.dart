import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Provider containing the firebase instances so that they dont have to keep being called.
class FirebaseInstanceToolsProvider with ChangeNotifier {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreInstance => _firestoreInstance;

  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  FirebaseAuth get authInstance => _authInstance;
}
