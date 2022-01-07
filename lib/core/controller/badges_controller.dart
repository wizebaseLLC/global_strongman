import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:global_strongman/core/model/badge.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';

enum BadgeUpdateType {
  increment,
  decrement,
}

class BadgesController {
  static final Badge completeFirstWorkout = Badge(
    title: "Complete your first workout",
    value: 1,
    badgeValueType: BadgeValueType.increment,
    badgeImage: "assets/images/kettlebellBadge.png",
  );

  static Badge completeWorkouts({required int value}) => Badge(
        title: "Complete $value ${value == 1 ? 'workout' : 'workouts'}",
        value: value,
        badgeValueType: BadgeValueType.increment,
        badgeImage: "assets/images/kettlebellBadge.png",
      );

  static Badge completeCategorizedWorkouts({
    required int value,
    required String category,
  }) =>
      Badge(
        title: "Complete $value $category workouts",
        value: value,
        badgeValueType: BadgeValueType.increment,
        badgeImage: "assets/images/kettlebellBadge.png",
      );

  static Badge surpasSpecificWorkouts({
    required int value,
    required String specificWorkout,
  }) =>
      Badge(
        title: "$specificWorkout $value lbs",
        value: value,
        badgeValueType: BadgeValueType.surpass,
        badgeImage: "assets/images/kettlebellBadge.png",
      );

  static Badge activeDays({required int value}) => Badge(
        title: "$value active ${value == 1 ? 'day' : 'days'}",
        value: value,
        badgeValueType: BadgeValueType.increment,
        badgeImage: "assets/images/kettlebellBadge.png",
      );

  String get _user => FirebaseAuth.instance.currentUser?.email ?? "n/a";

  Future<void> updatedCompletedCategorizedWorkout({
    required BadgeUpdateType updateType,
    required String category,
  }) async {
    final DocumentReference<FirebaseUser> documentReference =
        FirebaseUser(email: _user).getDocumentReference();

    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        // Get the document
        DocumentSnapshot<FirebaseUser> snapshot =
            await transaction.get(documentReference);

        if (snapshot.exists) {
          int newCompletedWorkoutCount;
          bool isIncrement = updateType == BadgeUpdateType.increment;
          switch (category) {
            case "strength":
              newCompletedWorkoutCount = isIncrement
                  ? (snapshot.data()?.strength ?? 0) + 1
                  : (snapshot.data()?.strength ?? 0) - 1;
              break;
            case "cardio":
              newCompletedWorkoutCount = isIncrement
                  ? (snapshot.data()?.cardio ?? 0) + 1
                  : (snapshot.data()?.cardio ?? 0) - 1;
              break;
            case "rehab":
              newCompletedWorkoutCount = isIncrement
                  ? (snapshot.data()?.rehab ?? 0) + 1
                  : (snapshot.data()?.rehab ?? 0) - 1;
              break;
            case "strongman":
              newCompletedWorkoutCount = isIncrement
                  ? (snapshot.data()?.strongman ?? 0) + 1
                  : (snapshot.data()?.strongman ?? 0) - 1;
              break;
            default:
              return;
          }

          // Perform an update on the document
          transaction.update(documentReference, {
            category:
                newCompletedWorkoutCount < 1 ? 0 : newCompletedWorkoutCount,
          });
        }
      },
    );
  }

  Future<int?> getSpecificWorkoutMaxLift({
    required String workoutId,
  }) async {
    try {
      final QuerySnapshot<FirebaseUserWorkoutComplete> completedWorkouts =
          await FirebaseUserWorkoutComplete()
              .getCollectionReference(user: _user)
              .where("workout_id", isEqualTo: workoutId)
              .orderBy("working_weight_lbs", descending: true)
              .limit(1)
              .get();

      if (completedWorkouts.docs.isNotEmpty) {
        return completedWorkouts.docs.first.data().working_weight_lbs?.toInt();
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<int> getActiveDays() async {
    final DocumentSnapshot<FirebaseUser> activeDays =
        await FirebaseUser(email: _user).getDocumentReference().get();

    return activeDays.data()?.active_days ?? 1;
  }

  Future<DocumentSnapshot<FirebaseUser>> getUserDocument() async =>
      FirebaseUser(email: _user).getDocumentReference().get();

  Future<bool> getCompletedFirstWorkout() async {
    final DocumentSnapshot<FirebaseUser> activeDays =
        await FirebaseUser(email: _user).getDocumentReference().get();

    if (activeDays.data()?.completed_workouts != null) {
      return activeDays.data()!.completed_workouts! > 0;
    }

    return false;
  }
}
