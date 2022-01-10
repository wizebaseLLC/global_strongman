// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/badges_controller.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/activity_interace_provider.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/measurement_radio_buttons.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/description.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/progression_line_chart.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/sliver_video_app_bar.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/workout_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:provider/provider.dart";

enum Measurement { lbs, kgs, seconds }

class ViewWorkoutScreen extends StatefulWidget {
  const ViewWorkoutScreen({
    required this.workout,
    required this.workout_id,
    required this.program_id,
    required this.programDay,
    Key? key,
  }) : super(key: key);

  final DocumentReference<FirebaseProgram> programDay;
  final FirebaseProgramWorkouts workout;
  final String program_id;
  final String workout_id;

  @override
  State<ViewWorkoutScreen> createState() => _ViewWorkoutScreenState();
}

class _ViewWorkoutScreenState extends State<ViewWorkoutScreen> {
  Measurement? measurement = Measurement.lbs;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? foundKey;

  String get _user => FirebaseAuth.instance.currentUser!.email!;

  Future<void> _incrementUserCompletedWorkouts() async {
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
                (snapshot.data()?.completed_workouts ?? 0) + 1;

            // Perform an update on the document
            transaction.update(documentReference, {
              'completed_workouts': newCompletedWorkoutCount,
            });
          }
        } catch (e) {
          print(e);
        }
      },
    ).catchError((err) => print(err));
  }

  Future<void> _handleSubmitWorkoutComplete(BuildContext context) async {
    try {
      num lbs = 0;
      num kgs = 0;
      num seconds = 0;

      if (_controller.text.isNotEmpty) {
        if (measurement == Measurement.lbs) {
          lbs = num.parse(_controller.text);
          kgs = (num.parse(_controller.text)) / 2.2046;
        } else if (measurement == Measurement.kgs) {
          kgs = num.parse(_controller.text);
          lbs = (num.parse(_controller.text)) * 2.2046;
        } else {
          seconds = num.parse(_controller.text);
        }
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
        "${_user}_${widget.program_id}_${widget.workout_id}_notes",
        _notesController.text,
      );

      final String previousWeight = lbs > 0
          ? ",  current: ${lbs.toStringAsFixed(1)} lbs (${kgs.toStringAsFixed(1)} kgs)"
          : seconds > 0
              ? ",  current: $seconds seconds"
              : "";
      prefs.setString(
        "${_user}_${widget.program_id}_${widget.workout_id}_previousWeight",
        previousWeight,
      );

      await FirebaseUserWorkoutComplete(
        created_on: DateTime.now(),
        seconds: seconds,
        program_id: widget.program_id,
        working_weight_kgs: kgs,
        working_weight_lbs: lbs,
        workout_id: widget.workout_id,
        categories: widget.workout.categories,
        day: widget.programDay.id,
        notes: _notesController.text,
        weight_used_string: previousWeight.replaceAll(",  current: ", ""),
        name: widget.workout.name,
        thumbnail: widget.workout.thumbnail,
      ).addCompletedWorkout(
        user: _user,
      );

      await _incrementUserCompletedWorkouts();
      await _updatedCompletedCategorizedWorkout();
      _setMetricsAsDirty(context);
      Navigator.pop(context, true);
    } catch (e) {
      if (true) {
        print(e);
      }
    }
  }

  void _setMetricsAsDirty(BuildContext context) {
    try {
      context.read<BadgeCurrentValues>().setIsDirty();
      context.read<ActivityInterfaceProvider>().setIsDirty();
    } catch (e) {
      if (true) {
        print(e);
      }
    }
  }

  Future<void> _updatedCompletedCategorizedWorkout() async {
    try {
      if (widget.workout.categories != null &&
          widget.workout.categories!.isNotEmpty) {
        await BadgesController().updatedCompletedCategorizedWorkout(
          updateType: BadgeUpdateType.increment,
          category: widget.workout.categories!,
        );
      }
    } catch (e) {
      if (true) {
        print(e);
      }
    }
  }

  Future<QuerySnapshot<FirebaseUserWorkoutComplete>>
      _getRecentCompletedWorkout() async {
    return FirebaseUserWorkoutComplete()
        .getCollectionReference(user: _user)
        .where(
          "program_id",
          isEqualTo: widget.program_id,
        )
        .where("workout_id", isEqualTo: widget.workout_id)
        // .limit(20)
        .get()
        .catchError((e) {
      if (true) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      foundKey = prefs.getString(
          "${_user}_${widget.program_id}_${widget.workout_id}_notes");
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: FutureBuilder<QuerySnapshot<FirebaseUserWorkoutComplete>>(
              future: _getRecentCompletedWorkout(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 10,
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverVideoAppBar(workout: widget.workout),
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    WorkoutTitle(workout: widget.workout),
                                    if (snapshot.data!.docs.length > 1)
                                      const SizedBox(height: kSpacing * 3),
                                    if (snapshot.data!.docs.length > 1)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kSpacing,
                                        ),
                                        child: ProgressionLineChart(
                                          seriesList: snapshot.data!.docs,
                                          animate: true,
                                        ),
                                      ),
                                    const SizedBox(height: kSpacing * 4),
                                    WorkoutDescription(
                                      title: "Training tips",
                                      subtitle: widget.workout.description!,
                                    ),
                                    if (widget.workout.weekly_increment != null)
                                      const SizedBox(height: kSpacing * 4),
                                    if (widget.workout.weekly_increment != null)
                                      WorkoutDescription(
                                        title: "Progression",
                                        subtitle:
                                            "Increase the weight by ${widget.workout.weekly_increment!}lbs (${(widget.workout.weekly_increment! / 2.2046).toStringAsFixed(1)}kg) weekly",
                                      ),
                                    const SizedBox(height: kSpacing * 4),
                                    const WorkoutDescription(
                                      title: "Log today's session",
                                      subtitle: "",
                                    ),
                                    const SizedBox(height: kSpacing),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: kSpacing,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: PlatformTextField(
                                              hintText: measurement ==
                                                      Measurement.seconds
                                                  ? "Seconds"
                                                  : "Working weight",
                                              controller: _controller,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(),
                                              cupertino: (_, __) =>
                                                  CupertinoTextFieldData(
                                                decoration: const BoxDecoration(
                                                  color: CupertinoColors
                                                      .darkBackgroundGray,
                                                ),
                                              ),
                                              material: (_, __) =>
                                                  MaterialTextFieldData(
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: MeasurementRadioButtons(
                                              measurement: measurement,
                                              setState: (value) => setState(
                                                () {
                                                  measurement = value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing * 4),
                                    const WorkoutDescription(
                                      title: "Notes",
                                      subtitle: "",
                                    ),
                                    const SizedBox(height: kSpacing),
                                    if (foundKey != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kSpacing,
                                        ),
                                        child: Text(
                                          foundKey!,
                                          style: platformThemeData(
                                            context,
                                            material: (data) => data
                                                .textTheme.headline6
                                                ?.copyWith(
                                              fontSize: 14,
                                              color: Colors.white30,
                                            ),
                                            cupertino: (data) => data
                                                .textTheme.navTitleTextStyle
                                                .copyWith(
                                              fontSize: 14,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (foundKey != null)
                                      const SizedBox(
                                        height: kSpacing * 2,
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: kSpacing,
                                      ),
                                      child: PlatformTextField(
                                        hintText:
                                            "What did I learn this session",
                                        minLines: 2,
                                        maxLines: 10,
                                        controller: _notesController,
                                        keyboardType: TextInputType.multiline,
                                        cupertino: (_, __) =>
                                            CupertinoTextFieldData(
                                          decoration: const BoxDecoration(
                                            color: CupertinoColors
                                                .darkBackgroundGray,
                                          ),
                                        ),
                                        material: (_, __) =>
                                            MaterialTextFieldData(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing * 4),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kSpacing,
                            right: kSpacing,
                            bottom: kSpacing,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: PlatformElevatedButton(
                              material: (_, __) => MaterialElevatedButtonData(
                                  style: ElevatedButton.styleFrom(
                                      primary: kPrimaryColor)),
                              onPressed: () =>
                                  _handleSubmitWorkoutComplete(context),
                              child: const Text(
                                "Mark Workout as Completed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }),
        ),
      ),
    );
  }
}
