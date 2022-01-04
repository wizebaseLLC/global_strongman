import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_calendar/workout_list_tile.dart';

class FilteredWorkoutScreen extends StatelessWidget {
  const FilteredWorkoutScreen({
    required this.title,
    required this.query,
    Key? key,
  }) : super(key: key);

  final Query<FirebaseUserWorkoutComplete> query;
  final String title;
  @override
  Widget build(BuildContext context) {
    return PlatformScaffoldIosSliverTitle(
      title: title,
      trailingActions: const [],
      body: FirestoreListView<FirebaseUserWorkoutComplete>(
          query: query,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, snapshot) {
            final FirebaseUserWorkoutComplete snapshotData = snapshot.data();
            return WorkoutListTile(
              program: snapshotData.program_id!,
              day: snapshotData.day!,
              doc: snapshotData.workout_id!,
              completedWorkout: snapshotData,
              snapshot: snapshot,
              shouldShowDate: true,
            );
          }),
    );
  }
}
