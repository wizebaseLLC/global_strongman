import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_calendar/workout_list_timeline_tile.dart';
import 'package:provider/provider.dart';

class WorkoutListByDay extends StatelessWidget {
  const WorkoutListByDay({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  final DateTime selectedDate;

  Query<FirebaseUserWorkoutComplete>? _getFilteredWorkouts(String? _user) {
    final DateTime startOfSelectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (_user != null) {
      return FirebaseUserWorkoutComplete()
          .getCollectionReference(user: _user)
          .where(
            "created_on",
            isGreaterThanOrEqualTo: startOfSelectedDay,
          )
          .where("created_on",
              isLessThanOrEqualTo: DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
              ).add(const Duration(days: 1)))
          .orderBy(
            "created_on",
            descending: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();
    final Query<FirebaseUserWorkoutComplete>? filteredWorkouts =
        _getFilteredWorkouts(_user.authUser?.email);

    if (filteredWorkouts != null) {
      return FirestoreQueryBuilder<FirebaseUserWorkoutComplete>(
        query: filteredWorkouts,
        builder: (context, snapshot, _) {
          final List<QueryDocumentSnapshot<FirebaseUserWorkoutComplete>> docs =
              snapshot.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final FirebaseUserWorkoutComplete snapshotData =
                  docs[index].data();

              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                snapshot.fetchMore();
              }

              if (snapshot.hasData) {
                return WorkoutListTimelineTile(
                  program: snapshotData.program_id,
                  day: snapshotData.day,
                  doc: snapshotData.workout_id!,
                  key: ValueKey<String>(docs[index].id),
                  completedWorkout: snapshotData,
                  snapshot: docs[index],
                  isFirst: index == 0,
                  isLast: docs.length == index + 1,
                );
              }

              return const CircularProgressIndicator.adaptive();
            },
          );
        },
      );
    }
    return const CircularProgressIndicator.adaptive();
  }
}
