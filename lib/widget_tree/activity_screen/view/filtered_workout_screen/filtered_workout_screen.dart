import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/view/platform_sliver_scaffold_ios_title_appbar.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/activity_calendar/workout_list_timeline_tile.dart';

class FilteredWorkoutScreen extends StatelessWidget {
  const FilteredWorkoutScreen({
    required this.title,
    required this.query,
    required this.previousPageTitle,
    Key? key,
  }) : super(key: key);

  final Query<FirebaseUserWorkoutComplete> query;
  final String title;
  final String previousPageTitle;
  @override
  Widget build(BuildContext context) {
    return PlatformSliverScaffold(
      title: title,
      previousPageTitle: previousPageTitle,
      trailingActions: const [],
      sliverChildren: [
        FirestoreQueryBuilder<FirebaseUserWorkoutComplete>(
          query: query,
          builder: (context, snapshot, _) {
            final List<QueryDocumentSnapshot<FirebaseUserWorkoutComplete>>
                docs = snapshot.docs;

            return SliverPadding(
              padding: const EdgeInsets.only(top: kSpacing * 2),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverList(
                  delegate: (SliverChildBuilderDelegate(
                    ((context, index) {
                      final FirebaseUserWorkoutComplete snapshotData =
                          docs[index].data();

                      if (snapshot.hasMore &&
                          index + 1 == snapshot.docs.length) {
                        // Tell FirestoreQueryBuilder to try to obtain more items.
                        // It is safe to call this function from within the build method.
                        snapshot.fetchMore();
                      }

                      if (snapshot.hasData) {
                        return WorkoutListTimelineTile(
                          program: snapshotData.program_id,
                          day: snapshotData.day,
                          key: ValueKey<String>(docs[index].id),
                          completedWorkout: snapshotData,
                          snapshot: docs[index],
                          isFirst: index == 0,
                          isLast: docs.length == index + 1,
                        );
                      }
                      return null;
                    }),
                    childCount: docs.length,
                  )),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
