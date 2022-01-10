import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/badges_controller.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class WorkoutListTile extends StatelessWidget {
  const WorkoutListTile({
    required this.program,
    required this.day,
    required this.doc,
    required this.completedWorkout,
    required this.snapshot,
    this.shouldShowDate,
    Key? key,
  }) : super(key: key);

  final String program;
  final String day;
  final String doc;
  final FirebaseUserWorkoutComplete completedWorkout;
  final QueryDocumentSnapshot<FirebaseUserWorkoutComplete> snapshot;
  final bool? shouldShowDate;

  String? get _notes => completedWorkout.notes;
  String? get _previousWeight => completedWorkout.weight_used_string;
  String? get _user => FirebaseAuth.instance.currentUser!.email;
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

  Future<void> _deleteWorkout(BuildContext context) async {
    if (_user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("${_user}_${program}_${completedWorkout.workout_id}");
    }

    HapticFeedback.heavyImpact();
    _decrementUserCompletedWorkouts();
    _updatedCompletedCategorizedWorkout();
    snapshot.reference.delete();
  }

  Future<void> _decrementUserCompletedWorkouts() async {
    if (_user != null) {
      final DocumentReference<FirebaseUser> documentReference =
          FirebaseUser(email: _user!).getDocumentReference();

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
              child: Dismissible(
                background: Container(
                  color: Colors.red,
                  child: Icon(
                    PlatformIcons(context).delete,
                    color: Colors.white,
                  ),
                ),
                key: ValueKey<FirebaseProgramWorkouts>(snapshotData),
                onDismissed: (_) => _deleteWorkout(context),
                child: ListTile(
                  dense: true,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: snapshotData.thumbnail!,
                      fit: BoxFit.cover,
                      memCacheWidth: 270,
                      width: 75,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                        text: snapshotData.name!,
                        style: platformThemeData(
                          context,
                          material: (data) =>
                              data.textTheme.subtitle1?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          cupertino: (data) =>
                              data.textTheme.textStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          if (shouldShowDate == true &&
                              completedWorkout.created_on != null)
                            TextSpan(
                              text:
                                  "  ${timeago.format(completedWorkout.created_on!)}",
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
                        ]),
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
