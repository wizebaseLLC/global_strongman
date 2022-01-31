import 'dart:math';

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
  static Badge completeWorkouts({required int value}) => Badge(
        title: "Complete $value ${value == 1 ? 'workout' : 'workouts'}",
        value: value,
        badgeValueType: BadgeValueType.increment,
        badgeImage: "assets/images/workouts.png",
      );

  static Badge completeCategorizedWorkouts({
    required int value,
    required String category,
  }) {
    String badgeImage = "strength";

    switch (category) {
      case "strength":
        break;
      case "cardio":
        badgeImage = "cardio";
        break;
      case "rehab":
        badgeImage = 'rehab';
        break;
      case "strongman":
        badgeImage = 'strongman';
        break;
      default:
        break;
    }

    return Badge(
      title: "Complete $value $category workouts",
      value: value,
      badgeValueType: BadgeValueType.increment,
      badgeImage: "assets/images/$badgeImage.png",
    );
  }

  static Badge surpasSpecificWorkouts({
    required int value,
    required String specificWorkout,
  }) =>
      Badge(
        title: "$specificWorkout $value lbs",
        value: value,
        badgeValueType: BadgeValueType.surpass,
        badgeImage: "assets/images/specific.png",
      );

  static Badge activeDays({required int value}) => Badge(
        title: "$value active ${value == 1 ? 'day' : 'days'}",
        value: value,
        badgeValueType: BadgeValueType.increment,
        badgeImage: "assets/images/active_days.png",
      );

  String get _user => FirebaseAuth.instance.currentUser?.email ?? "n/a";

  Future<void> updatedCompletedCategorizedWorkout({
    required BadgeUpdateType updateType,
    required List<dynamic> category,
  }) async {
    try {
      final DocumentSnapshot<FirebaseUser> snapshot =
          await FirebaseUser(email: _user).getDocumentReference().get();

      if (snapshot.exists && snapshot.data() != null) {
        int strength = snapshot.data()?.strength ?? 0;
        int cardio = snapshot.data()?.cardio ?? 0;
        int rehab = snapshot.data()?.rehab ?? 0;
        int strongman = snapshot.data()?.strongman ?? 0;

        bool isIncrement = updateType == BadgeUpdateType.increment;

        if (category.contains("strength")) {
          strength = isIncrement ? strength + 1 : strength - 1;
        }

        if (category.contains("cardio")) {
          cardio = isIncrement ? cardio + 1 : cardio - 1;
        }

        if (category.contains("rehab")) {
          rehab = isIncrement ? rehab + 1 : rehab - 1;
        }

        if (category.contains("strongman")) {
          strongman = isIncrement ? strongman + 1 : strongman - 1;
        }

        await FirebaseUser(email: _user).getDocumentReference().update({
          'strength': strength,
          'cardio': cardio,
          'rehab': rehab,
          'strongman': strongman,
        });
      }

      // Perform an update on the document

    } catch (e) {
      print(e);
    }
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
        return completedWorkouts.docs.first
            .data()
            .working_sets
            ?.map((e) =>
                WorkoutSetListItem.fromJson(e).working_weight_lbs?.toInt() ?? 0)
            .reduce(max);
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
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
