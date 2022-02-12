// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/view_workout_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpandedWorkoutList extends StatefulWidget {
  const ExpandedWorkoutList({
    required this.workoutTile,
    required this.program_id,
    required this.workout_id,
    required this.programDay,
    required this.isLast,
    Key? key,
  }) : super(key: key);

  final DocumentReference<FirebaseProgram> programDay;
  final FirebaseProgramWorkouts workoutTile;
  final String program_id;
  final String workout_id;
  final bool isLast;

  static String getSubtitle({required FirebaseProgramWorkouts workoutTile}) {
    if (workoutTile.reps != null &&
        workoutTile.sets != null &&
        workoutTile.percent != null) {
      return "${workoutTile.sets} ${workoutTile.sets == 1 ? 'set' : 'sets'} of ${workoutTile.reps} reps at ${workoutTile.percent}% of your 1 rep max";
    } else if (workoutTile.reps != null && workoutTile.sets != null) {
      return "${workoutTile.sets} sets of ${workoutTile.reps} reps";
    } else if (workoutTile.reps == null && workoutTile.sets != null) {
      return "${workoutTile.sets} sets";
    } else if (workoutTile.minutes != null) {
      return "${workoutTile.minutes} minutes";
    }
    return "";
  }

  @override
  State<ExpandedWorkoutList> createState() => _ExpandedWorkoutListState();
}

class _ExpandedWorkoutListState extends State<ExpandedWorkoutList> {
  bool _workoutComplete = false;
  String? get user => FirebaseAuth.instance.currentUser?.email;

  Future<void> _checkIfWorkoutWasCompleted({
    required SharedPreferences prefs,
  }) async {
    final String? foundKey =
        prefs.getString("${user}_${widget.program_id}_${widget.workout_id}");

    if (foundKey != null) {
      if (foundKey.substring(0, 10) ==
          DateTime.now().toString().substring(0, 10)) {
        setState(() {
          _workoutComplete = true;
        });
      }
    }
  }

  Future<void> _incrementActiveDays() async {
    if (user != null) {
      final DocumentReference<FirebaseUser> documentReference = FirebaseUser(
        email: user!,
      ).getDocumentReference();

      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          try {
            // Get the document
            DocumentSnapshot<FirebaseUser> snapshot =
                await transaction.get(documentReference);

            if (snapshot.exists) {
              int newActiveDays = (snapshot.data()?.active_days ?? 0) + 1;

              // Perform an update on the document
              transaction.update(documentReference, {
                'active_days': newActiveDays,
              });
            }
          } catch (e) {
            print(e);
          }
        },
      ).catchError((err) => print(err));
    }
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      _checkIfWorkoutWasCompleted(prefs: prefs);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.workoutTile.name!,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1?.copyWith(
                color: Colors.white,
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                fontSize: 14,
                color: CupertinoColors.white,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_workoutComplete)
                Icon(
                  PlatformIcons(context).checkMark,
                  color:
                      Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue,
                  size: 16,
                ),
              if (_workoutComplete)
                const SizedBox(
                  width: kSpacing,
                ),
              Icon(
                PlatformIcons(context).rightChevron,
                color: Colors.white60,
              ),
            ],
          ),
          dense: true,
          onTap: () async {
            if (user != null) {
              final bool? didCompleteWorkout = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (_) => ViewWorkoutScreen(
                    workout: widget.workoutTile,
                    program_id: widget.program_id,
                    workout_id: widget.workout_id,
                    programDay: widget.programDay,
                  ),
                ),
              );
              if (didCompleteWorkout != null && didCompleteWorkout == true) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                final DateTime now = DateTime.now();

                final String? previousDate = prefs
                    .getString("${user}_${now.day}_${now.month}_${now.year}");
                await prefs.setString(
                  "${user}_${now.day}_${now.month}_${now.year}",
                  "${user}_${now.day}_${now.month}_${now.year}",
                );

                if (previousDate == null) {
                  await _incrementActiveDays();
                }

                setState(
                  () {
                    _workoutComplete = true;
                  },
                );
              }
            }
          },
        ),
        if (!widget.isLast)
          const Divider(
            color: Colors.grey,
            height: 2,
            indent: kSpacing * 2,
            endIndent: kSpacing * 2,
          )
      ],
    );
  }
}
