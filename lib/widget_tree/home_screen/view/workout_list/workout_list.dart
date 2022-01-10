import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({required this.program, Key? key}) : super(key: key);
  final QueryDocumentSnapshot<FirebaseProgram> program;

  Future<List<FirebaseProgramWorkouts>> _getWorkouts() async {
    List<FirebaseProgramWorkouts> workoutList = [];
    final Future<QuerySnapshot<FirebaseProgramWorkouts>> day1 =
        generateWorkout(ProgramDays.day_1);
    final Future<QuerySnapshot<FirebaseProgramWorkouts>> day2 =
        generateWorkout(ProgramDays.day_2);
    final Future<QuerySnapshot<FirebaseProgramWorkouts>> day3 =
        generateWorkout(ProgramDays.day_3);

    final List<QuerySnapshot<FirebaseProgramWorkouts>> combinedWorkouts =
        await Future.wait([
      day1,
      day2,
      day3,
    ]);

    for (var workout in combinedWorkouts) {
      for (var item in workout.docs) {
        workoutList.add(item.data());
      }
    }
    return workoutList;
  }

  Future<QuerySnapshot<FirebaseProgramWorkouts>> generateWorkout(
      ProgramDays day) async {
    return FirebaseProgramWorkouts()
        .getCollectionReference(program: program.id, day: day)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FirebaseProgramWorkouts>>(
        future: _getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Error",
              style: TextStyle(color: Colors.red),
            );
          }
          if (snapshot.hasData) {
            final List<FirebaseProgramWorkouts> snapshotData = snapshot.data!;
            snapshotData.sort((a, b) => a.name!.compareTo(b.name!));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing * 2),
              child: SizedBox(
                height: 800,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  children: [
                    for (final workout in snapshotData)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kSpacing),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: workout.thumbnail!,
                              fit: BoxFit.cover,
                              memCacheWidth: 270,
                              width: 90,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          title: Text(
                            workout.name!,
                            style: platformThemeData(
                              context,
                              material: (data) => data.textTheme.bodyText1,
                              cupertino: (data) => data.textTheme.textStyle,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: kSpacing * 4,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        });
  }
}
