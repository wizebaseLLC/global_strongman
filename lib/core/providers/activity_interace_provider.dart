import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';

/// Provider used by the activity screen.
/// It fetches data and provides the data all in one.
class ActivityInterfaceProvider with ChangeNotifier {
  int _totalWorkouts = 0;
  int get totalWorkouts => _totalWorkouts;

  int _activeDays = 0;
  int get activeDays => _activeDays;

  int _programsComplete = 0;
  int get programsComplete => _programsComplete;

  int _trophiesEarned = 0;
  int get trophiesEarned => _trophiesEarned;

  List<FirebaseUserWorkoutComplete> _completedWorkouts = [];
  List<FirebaseUserWorkoutComplete> get completedWorkouts => _completedWorkouts;

  String get _user => FirebaseAuth.instance.currentUser?.email ?? 'n/a';

  Future<void> createWorkoutInterface() async {
    try {
      final DocumentSnapshot<FirebaseUser> firebaseUser =
          await FirebaseUser(email: _user).getDocumentReference().get();

      final FirebaseUser? firebaseUserData = firebaseUser.data();

      final List<QueryDocumentSnapshot<FirebaseUserStartedProgram>>
          completedPrograms = await _getUniqueCompletedPrograms();

      final List<QueryDocumentSnapshot<FirebaseUserStartedProgram>>
          filteredCompletedPrograms = completedPrograms
              .where(
                (element) => (element.data().is_active != null &&
                        element.data().is_active == false)
                    ? true
                    : false,
              )
              .toList();

      final List<FirebaseUserWorkoutComplete> completedWorkoutsInner =
          await _getCompletedWorkouts();

      _totalWorkouts = firebaseUserData?.completed_workouts ?? 0;
      _activeDays = firebaseUserData?.active_days ?? 0;
      _programsComplete = filteredCompletedPrograms.length;
      _trophiesEarned = 0;
      _completedWorkouts = completedWorkoutsInner;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<QueryDocumentSnapshot<FirebaseUserStartedProgram>>>
      _getUniqueCompletedPrograms() async {
    final QuerySnapshot<FirebaseUserStartedProgram> firebaseUserPrograms =
        await FirebaseUserStartedProgram()
            .getCollectionReference(userId: _user)
            .get();

    return firebaseUserPrograms.docs;
  }

  Future<List<FirebaseUserWorkoutComplete>> _getCompletedWorkouts() async {
    final QuerySnapshot<FirebaseUserWorkoutComplete> firebaseUserPrograms =
        await FirebaseUserWorkoutComplete()
            .getCollectionReference(user: _user)
            .get();

    return firebaseUserPrograms.docs.map((e) => e.data()).toList();
  }
}
