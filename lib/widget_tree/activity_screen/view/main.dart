import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workout_set_count/workout_sets_card.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workoutsCategories/workoutsCategories.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/description.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  String get _user => FirebaseAuth.instance.currentUser!.email!;

  Future<ActivityInterface> _createWorkoutInterface() async {
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

    final List<FirebaseUserWorkoutComplete> completedWorkouts =
        await _getCompletedWorkouts();

    return ActivityInterface(
      totalWorkouts: firebaseUserData?.completed_workouts ?? 0,
      activeDays: firebaseUserData?.active_days ?? 0,
      programsComplete: filteredCompletedPrograms.length,
      trophiesEarned: 0,
      completedWorkouts: completedWorkouts,
    );
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ActivityInterface>(
        future: _createWorkoutInterface(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WorkoutSetsCard(
                        activityInterface: snapshot.data!,
                      ),
                      const SizedBox(
                        height: kSpacing * 2,
                      ),
                      const WorkoutDescription(
                        title: "Categories",
                        subtitle: "Workouts completed by category",
                      ),
                      WorkoutsCompletedByCategory(
                        activityInterface: snapshot.data!,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        });
  }
}
