import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workout_history/workout_history_sliver_appbar.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workout_history/workout_history_sliver_list_tile.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/progression_line_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkoutHistoryDetailScreen extends StatelessWidget {
  const WorkoutHistoryDetailScreen({
    required this.completedWorkout,
    Key? key,
  }) : super(key: key);
  final FirebaseUserWorkoutComplete? completedWorkout;

  Future<DocumentSnapshot<FirebaseProgramWorkouts>> _queryGetWorkout() =>
      FirebaseProgramWorkouts()
          .getWorkoutCatalogDocumentReference(doc: completedWorkout?.workout_id)
          .get();

  Future<QuerySnapshot<FirebaseUserWorkoutComplete>> _getRecentCompletedWorkout(
      String? user) async {
    return FirebaseUserWorkoutComplete()
        .getCollectionReference(user: user)
        .where(
          "name",
          isEqualTo: completedWorkout?.name,
        )
        .get()
        .catchError((e) {
      if (true) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider user = context.read<UserProvider>();
    return FutureBuilder<QuerySnapshot<FirebaseUserWorkoutComplete>>(
        future: _getRecentCompletedWorkout(user.authUser?.email),
        builder: (context, lineChartSnapshot) {
          return FutureBuilder<DocumentSnapshot<FirebaseProgramWorkouts>>(
            future: _queryGetWorkout(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final FirebaseProgramWorkouts? workout = snapshot.data?.data();
                if (workout != null && workout.thumbnail != null) {
                  return SafeArea(
                    top: false,
                    child: Container(
                      color: platformThemeData(
                        context,
                        material: (data) => data.scaffoldBackgroundColor,
                        cupertino: (data) => data.scaffoldBackgroundColor,
                      ),
                      child: CustomScrollView(
                        primary: true,
                        slivers: [
                          WorkoutHistorySliverAppBar(
                            workout: workout,
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(kSpacing),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  const SizedBox(
                                    height: kSpacing * 2,
                                  ),
                                  Text(
                                    DateFormat.MMMMEEEEd()
                                        .format(completedWorkout!.created_on!),
                                    style: platformThemeData(
                                      context,
                                      material: (data) =>
                                          data.textTheme.headline6,
                                      cupertino: (data) => data
                                          .textTheme.navLargeTitleTextStyle
                                          .copyWith(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: kSpacing * 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (completedWorkout?.working_sets != null &&
                              completedWorkout!.working_sets!.isNotEmpty)
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Column(
                                  children: [
                                    WorkoutHistorySliverListTile(
                                      index: index + 1,
                                      workingSet: WorkoutSetListItem.fromJson(
                                        completedWorkout?.working_sets?[index],
                                      ),
                                    ),
                                    const Divider(
                                      indent: 50 + kSpacing * 4,
                                      endIndent: kSpacing * 4,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                childCount:
                                    completedWorkout?.working_sets?.length,
                              ),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kSpacing * 2,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  if (completedWorkout?.notes != null &&
                                      completedWorkout!.notes!.isNotEmpty)
                                    const SizedBox(
                                      height: kSpacing * 2,
                                    ),
                                  if (completedWorkout?.notes != null &&
                                      completedWorkout!.notes!.isNotEmpty)
                                    Text(
                                      "Notes",
                                      style: platformThemeData(
                                        context,
                                        material: (data) =>
                                            data.textTheme.headline6,
                                        cupertino: (data) => data
                                            .textTheme.navLargeTitleTextStyle
                                            .copyWith(
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  if (completedWorkout?.notes != null &&
                                      completedWorkout!.notes!.isNotEmpty)
                                    const SizedBox(
                                      height: kSpacing * 2,
                                    ),
                                  if (completedWorkout?.notes != null &&
                                      completedWorkout!.notes!.isNotEmpty)
                                    Text(
                                      completedWorkout!.notes!,
                                      style: platformThemeData(
                                        context,
                                        material: (data) =>
                                            data.textTheme.bodySmall,
                                        cupertino: (data) =>
                                            data.textTheme.textStyle.copyWith(
                                          fontSize: 12,
                                          color: CupertinoColors.systemGrey3,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: kSpacing * 2,
                                  ),
                                  Text(
                                    "All Time",
                                    style: platformThemeData(
                                      context,
                                      material: (data) =>
                                          data.textTheme.headline6,
                                      cupertino: (data) => data
                                          .textTheme.navLargeTitleTextStyle
                                          .copyWith(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  if (lineChartSnapshot.hasData)
                                    const SizedBox(
                                      height: kSpacing * 2,
                                    ),
                                  if (lineChartSnapshot.hasData)
                                    ProgressionLineChart(
                                      seriesList: lineChartSnapshot.data!.docs,
                                      animate: true,
                                    ),
                                  const SizedBox(
                                    height: kSpacing * 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          );
        });
  }
}
