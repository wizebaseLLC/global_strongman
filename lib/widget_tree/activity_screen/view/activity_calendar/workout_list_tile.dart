import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';

class WorkoutListTile extends StatelessWidget {
  const WorkoutListTile({
    required this.program,
    required this.day,
    required this.doc,
    required this.completedWorkout,
    Key? key,
  }) : super(key: key);

  final String program;
  final String day;
  final String doc;
  final FirebaseUserWorkoutComplete completedWorkout;

  String? get _notes => completedWorkout.notes;
  String? get _previousWeight => completedWorkout.weight_used_string;

  Future<DocumentSnapshot<FirebaseProgramWorkouts>?> _getWorkoutData() async {
    try {
      return FirebaseProgramWorkouts()
          .getDocumentReference(
            program: program,
            day: day,
            doc: doc,
          )
          .get();
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<FirebaseProgramWorkouts>?>(
      future: _getWorkoutData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final FirebaseProgramWorkouts? snapshotData = snapshot.data?.data();

          if (snapshotData != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: kSpacing),
              child: ListTile(
                dense: true,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: snapshotData.thumbnail!,
                    fit: BoxFit.cover,
                    memCacheWidth: 270,
                    width: 90,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(
                  snapshotData.name!,
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.subtitle1,
                    cupertino: (data) => data.textTheme.textStyle,
                  ),
                ),
                subtitle: (_previousWeight == null && _notes == null)
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_previousWeight != null)
                              Text(
                                _previousWeight!,
                                style: platformThemeData(
                                  context,
                                  material: (data) =>
                                      data.textTheme.bodyText2?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  cupertino: (data) =>
                                      data.textTheme.textStyle.copyWith(
                                    fontSize: 12,
                                    color: CupertinoColors.systemGrey3,
                                  ),
                                ),
                              ),
                            if (_notes != null && _previousWeight != null)
                              const SizedBox(
                                height: 4,
                              ),
                            if (_notes != null)
                              Text(
                                _notes!,
                                style: platformThemeData(
                                  context,
                                  material: (data) =>
                                      data.textTheme.bodyText2?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                  cupertino: (data) =>
                                      data.textTheme.textStyle.copyWith(
                                    fontSize: 10,
                                    color: CupertinoColors.systemGrey3,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: kSpacing,
                            ),
                            Divider(
                              color: Platform.isIOS
                                  ? CupertinoColors.systemGrey
                                  : Colors.white30,
                            ),
                          ],
                        ),
                      ),
              ),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
