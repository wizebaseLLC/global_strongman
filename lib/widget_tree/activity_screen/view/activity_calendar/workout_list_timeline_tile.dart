import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/badges_controller.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

final dateFormat = DateFormat('hh:mm a');

class WorkoutListTimelineTile extends StatelessWidget {
  const WorkoutListTimelineTile({
    required this.program,
    required this.day,
    required this.doc,
    required this.completedWorkout,
    required this.snapshot,
    this.isFirst = false,
    this.isLast = false,
    this.shouldShowDate,
    Key? key,
  }) : super(key: key);

  final String? program;
  final String? day;
  final String doc;
  final bool isFirst;
  final bool isLast;
  final FirebaseUserWorkoutComplete completedWorkout;
  final QueryDocumentSnapshot<FirebaseUserWorkoutComplete> snapshot;
  final bool? shouldShowDate;

  String? get _notes => completedWorkout.notes;
  String? get _previousWeight => _workingSets
      ?.map((workingSet) {
        if (workingSet.seconds != null && workingSet.seconds! > 0) {
          return workingSet.seconds?.toInt() ?? 0;
        } else {
          return workingSet.working_weight_lbs?.toInt() ?? 0;
        }
      })
      .reduce(max)
      .toString();

  List<WorkoutSetListItem>? get _workingSets => completedWorkout.working_sets
      ?.map((e) => WorkoutSetListItem.fromJson(e))
      .toList();

  Future<void> _deleteWorkout(BuildContext context, String? _user) async {
    if (_user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("${_user}_${program}_${completedWorkout.workout_id}");
    }

    HapticFeedback.mediumImpact();
    _decrementUserCompletedWorkouts(_user);
    _updatedCompletedCategorizedWorkout();
    snapshot.reference.delete();
  }

  Future<void> _decrementUserCompletedWorkouts(String? _user) async {
    if (_user != null) {
      final DocumentReference<FirebaseUser> documentReference =
          FirebaseUser(email: _user).getDocumentReference();

      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          try {
            // Get the document
            DocumentSnapshot<FirebaseUser> snapshot =
                await transaction.get(documentReference);

            if (snapshot.exists) {
              int newCompletedWorkoutCount =
                  (snapshot.data()?.completed_workouts ?? 0) - 1;

              // Perform an update on the document
              transaction.update(documentReference, {
                'completed_workouts': newCompletedWorkoutCount,
              });
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },
      ).catchError((err) => print(err));
    }
  }

  void _updatedCompletedCategorizedWorkout() {
    if (completedWorkout.categories != null &&
        completedWorkout.categories!.isNotEmpty) {
      BadgesController().updatedCompletedCategorizedWorkout(
        updateType: BadgeUpdateType.decrement,
        category: completedWorkout.categories!,
      );
    }
  }

  String _chooseIconImage(List<dynamic>? categories) {
    if (categories != null) {
      if (categories.contains("strongman")) {
        return "weightlifting";
      } else if (categories.contains("cardio")) {
        return "pulse";
      } else if (categories.contains("rehab")) {
        return "pulse 2";
      } else if (categories.contains("strength")) {
        return "muscle";
      }
    }

    return "muscle";
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Icon(
          PlatformIcons(context).delete,
          color: Colors.white,
        ),
      ),
      key: ValueKey<String>(snapshot.id),
      onDismissed: (_) => _deleteWorkout(context, _user.authUser?.email),
      child: SizedBox(
        height: _notes?.isEmpty == true ? 100 : 150,
        child: TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          axis: TimelineAxis.vertical,
          alignment: TimelineAlign.manual,
          lineXY: 0.35,
          indicatorStyle: IndicatorStyle(
            width: 50,
            height: 50,
            indicator: CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: SvgPicture.asset(
                "assets/images/${_chooseIconImage(completedWorkout.categories)}.svg",
                color: Colors.white,
              ),
            ),
          ),
          startChild: Padding(
            padding: const EdgeInsets.only(left: kSpacing * 2),
            child: Text(
              dateFormat.format(completedWorkout.created_on!),
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.bodyText2?.copyWith(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                cupertino: (data) => data.textTheme.textStyle.copyWith(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey3,
                ),
              ),
            ),
          ),
          endChild: (_notes == null || _notes?.isEmpty == true) &&
                  _previousWeight?.isEmpty == true
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: kSpacing * 2,
                  ),
                  child: Text(
                    completedWorkout.name ?? "",
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.subtitle1?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      cupertino: (data) => data.textTheme.textStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: kSpacing * 2),
                  child: ListTile(
                    dense: true,
                    isThreeLine: true,
                    title: Text(
                      completedWorkout.name ?? "",
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.subtitle1?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        cupertino: (data) => data.textTheme.textStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: (_previousWeight == null && _notes == null)
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(
                              bottom: kSpacing * 3,
                              top: kSpacing / 2,
                            ),
                            child: SingleChildScrollView(
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
                                  if (_notes != null &&
                                      _notes!.isNotEmpty &&
                                      _previousWeight != null)
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  if (_notes != null && _notes!.isNotEmpty)
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
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
        ),
      ),
    );
  }
}
