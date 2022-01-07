import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_calendar/workout_list_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutListByDay extends StatelessWidget {
  const WorkoutListByDay({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  final DateTime selectedDate;

  String? get _user => FirebaseAuth.instance.currentUser?.email;

  Query<FirebaseUserWorkoutComplete> _getFilteredWorkouts() {
    return FirebaseUserWorkoutComplete()
        .getCollectionReference(user: _user!)
        .where(
          "created_on",
          isGreaterThanOrEqualTo: normalizeDate(selectedDate),
        )
        .where(
          "created_on",
          isLessThanOrEqualTo: normalizeDate(
            selectedDate.add(
              const Duration(days: 1),
            ),
          ),
        )
        .orderBy("created_on", descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<FirebaseUserWorkoutComplete>(
      query: _getFilteredWorkouts(),
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, snapshot) {
        final FirebaseUserWorkoutComplete snapshotData = snapshot.data();

        return Column(
          children: [
            WorkoutListTile(
              program: snapshotData.program_id!,
              day: snapshotData.day!,
              doc: snapshotData.workout_id!,
              key: GlobalKey(),
              completedWorkout: snapshotData,
              snapshot: snapshot,
            ),
          ],
        );
      },
    );
  }
}
