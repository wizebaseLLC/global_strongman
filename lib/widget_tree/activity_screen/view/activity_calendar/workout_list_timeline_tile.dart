import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

const String defaultThumbanil =
    "https://firebasestorage.googleapis.com/v0/b/global-strongman.appspot.com/o/Programs%2Fthumbnails%2FB707D09F-03F3-44A2-959F-2F724AA18FF4.jpeg?alt=media&token=510d1716-a083-4ee5-93fc-9b9719f80fa6";

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

  final String program;
  final String day;
  final String doc;
  final bool isFirst;
  final bool isLast;
  final FirebaseUserWorkoutComplete completedWorkout;
  final QueryDocumentSnapshot<FirebaseUserWorkoutComplete> snapshot;
  final bool? shouldShowDate;

  String? get _notes => completedWorkout.notes;
  String? get _previousWeight => completedWorkout.weight_used_string;

  Future<void> _deleteWorkout(BuildContext context, String? _user) async {
    if (_user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("${_user}_${program}_${completedWorkout.workout_id}");
    }

    HapticFeedback.heavyImpact();
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
            indicator: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: CachedNetworkImage(
                imageUrl: completedWorkout.thumbnail ?? defaultThumbanil,
                fit: BoxFit.cover,
                memCacheWidth: 150,
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
