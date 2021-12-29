import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/expanded_workout_list.dart';

class DayContainer extends StatelessWidget {
  const DayContainer({
    required this.program,
    required this.programDay,
    Key? key,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  final DocumentReference<FirebaseProgram> programDay;

  Future<QuerySnapshot<FirebaseProgramWorkouts>?> _getProgramData() async {
    try {
      return FirebaseProgramWorkouts()
          .getCollectionReferenceByString(
              program: program.id, day: programDay.id)
          .get();
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<FirebaseProgramWorkouts>?>(
        future: _getProgramData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orderedDocs = snapshot.data!.docs;

            orderedDocs
                .sort((a, b) => a.data().order!.compareTo(b.data().order!));

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: kSpacing),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kSpacing),
                child: ExpansionTile(
                  backgroundColor: platformThemeData(
                    context,
                    material: (data) => data.cardColor,
                    cupertino: (data) => data.barBackgroundColor,
                  ),
                  collapsedBackgroundColor: platformThemeData(
                    context,
                    material: (data) => data.cardColor,
                    cupertino: (data) => data.barBackgroundColor,
                  ),
                  iconColor: Colors.white60,
                  collapsedIconColor: Colors.white60,
                  title: Text(
                    programDay.id.toUpperCase().replaceAll("_", " "),
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      cupertino: (data) => data.textTheme.navTitleTextStyle,
                    ),
                  ),
                  subtitle: Text(
                    "${snapshot.data?.docs.length} workouts",
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.bodyText1?.copyWith(
                        color: Colors.white70,
                      ),
                      cupertino: (data) => data.textTheme.textStyle.copyWith(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey3,
                      ),
                    ),
                  ),
                  children: [
                    if (orderedDocs != null)
                      ...orderedDocs
                          .map((data) =>
                              ExpandedWorkoutList(workoutTile: data.data()))
                          .toList()
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }
}
