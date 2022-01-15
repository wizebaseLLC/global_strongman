import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:global_strongman/core/model/firebase_user.dart';

/// Provider with all things pertaining to the current user.
class UserProvider with ChangeNotifier {
  User? _authUser;
  User? get authUser => _authUser;

  FirebaseUser? _firebaseUser;
  FirebaseUser? get firebaseUser => _firebaseUser;

  void updateAuthUser(User value) {
    _authUser = value;
    notifyListeners();
  }

  void updateFirebaseUser(FirebaseUser value) {
    _firebaseUser = value;
    notifyListeners();
  }

  void resetToDefault() {
    _authUser = null;
    _firebaseUser = null;
    notifyListeners();
  }
}
