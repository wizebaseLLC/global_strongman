// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/badges_controller.dart';
import 'package:global_strongman/core/controller/platformPicker.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/activity_interace_provider.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/core/view/animated_sliver_list_wrapper.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/filtered_workout_screen/filtered_workout_screen.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/description.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/progression_line_chart.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/sliver_video_app_bar.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/workout_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:provider/provider.dart";

class ViewWorkoutScreen extends StatefulWidget {
  const ViewWorkoutScreen({
    required this.workout,
    required this.workout_id,
    this.program_id,
    this.programDay,
    Key? key,
  }) : super(key: key);

  final DocumentReference<FirebaseProgram>? programDay;
  final FirebaseProgramWorkouts workout;
  final String? program_id;
  final String workout_id;

  @override
  State<ViewWorkoutScreen> createState() => _ViewWorkoutScreenState();
}

class _ViewWorkoutScreenState extends State<ViewWorkoutScreen> {
  final TextEditingController _notesController = TextEditingController();
  String? foundKey;
  String _pickerValue = "0";

  ListModel<WorkoutSetListItem> list = ListModel<WorkoutSetListItem>(
    listKey: GlobalKey<SliverAnimatedListState>(),
    items: <WorkoutSetListItem>[
      WorkoutSetListItem(),
    ],
  );

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
    ).catchError((err) {
      print(err);
    });
  }

  Future<void> _handleSubmitWorkoutComplete(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
        "${_user}_${widget.program_id}_${widget.workout_id}_notes",
        _notesController.text,
      );

      await FirebaseUserWorkoutComplete(
        created_on: DateTime.now(),
        program_id: widget.program_id,
        working_sets: list.items.map((x) => x.toJson()).toList(),
        workout_id: widget.workout_id,
        categories: widget.workout.categories,
        day: widget.programDay?.id,
        notes: _notesController.text,
        name: widget.workout.name,
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
        .get()
        .catchError((e) {
      if (true) {
        print(e);
      }
    });
  }

  void _setWeight(index) async {
    num lbs = 0;
    num kgs = 0;
    final picker = PlatformPicker(
      pickerValue: _pickerValue,
      list: [
        for (var i = 0; i <= 1200; i++) i.toString(),
      ],
    );

    await picker.showPicker(
      context: context,
      title: "Working Set",
      message: "How much weight (lbs) did you lift this set?",
    );

    if (picker.pickerValue != null && picker.pickerValue!.isNotEmpty) {
      lbs = num.parse(picker.pickerValue!);
      kgs = (num.parse(picker.pickerValue!)) / 2.2046;

      setState(() {
        _pickerValue = picker.pickerValue!;
      });
    }

    setState(
      () {
        list.items[index] = WorkoutSetListItem(
          duration: list.items[index].duration,
          working_weight_kgs: kgs,
          working_weight_lbs: lbs,
          reps: list.items[index].reps,
        );
      },
    );
  }

  void _setReps(index) async {
    num reps = 0;
    final picker = PlatformPicker(
      list: [
        for (var i = 0; i <= 100; i++) i.toString(),
      ],
    );

    await picker.showPicker(
      context: context,
      title: "Working Set",
      message: "How many repetitions did you complete?",
    );

    if (picker.pickerValue != null && picker.pickerValue!.isNotEmpty) {
      reps = num.parse(picker.pickerValue!);
    }

    setState(
      () {
        list.items[index] = WorkoutSetListItem(
          duration: list.items[index].duration,
          working_weight_kgs: list.items[index].working_weight_kgs,
          working_weight_lbs: list.items[index].working_weight_lbs,
          reps: reps,
        );
      },
    );
  }

  void _setDuration(index) async {
    String? duration;
    final picker = PlatformPicker(
      list: [],
    );

    await picker.showDurationTimerPicker(
      context: context,
      title: "Working Set",
      message: "How long did you go for?",
    );

    if (picker.timerPickerValue != null) {
      duration = PlatformPicker.printDuration(picker.timerPickerValue!);
    }

    setState(
      () {
        list.items[index] = WorkoutSetListItem(
          duration: duration,
          working_weight_kgs: list.items[index].working_weight_kgs,
          working_weight_lbs: list.items[index].working_weight_lbs,
          reps: list.items[index].reps,
        );
      },
    );
  }

  void _onHistoryPress({
    required String title,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => FilteredWorkoutScreen(
          title: title,
          query: FirebaseUserWorkoutComplete()
              .getCollectionReference(user: _user)
              .where("workout_id", isEqualTo: widget.workout_id)
              .orderBy("created_on", descending: true),
          previousPageTitle: "Workout",
        ),
      ),
    );
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      foundKey = prefs.getString(
          "${_user}_${widget.program_id}_${widget.workout_id}_notes");
    });

    // To create a workout catalog quick.  Just view this workout and it'll generate one.
    // FirebaseProgramWorkouts()
    //     .getDocumentReference(
    //         program: widget.program_id,
    //         day: widget.programDay.id,
    //         doc: widget.workout_id)
    //     .get()
    //     .then((value) =>
    //         value.data()?.createCatalogWorkout(docName: widget.workout_id));

    // FirebaseProgramWorkouts(
    //   name: "Yushchevel Walk",
    //   categories: [
    //     "strength",
    //     "cardio",
    //     "strongman",
    //     // "rehab",
    //     //"arms",
    //     "legs",
    //     "back",
    //     //"shoulders",
    //     // "chest",
    //     "compound",
    //     //  "traps",
    //     //"isolation",
    //     "core",
    //   ],
    //   description: "temp",
    //   has_video: false,
    //   thumbnail:
    //       "https://firebasestorage.googleapis.com/v0/b/global-strongman.appspot.com/o/Programs%2Fthumbnails%2FB707D09F-03F3-44A2-959F-2F724AA18FF4.jpeg?alt=media&token=510d1716-a083-4ee5-93fc-9b9719f80fa6",
    // ).createCatalogWorkout(
    //   docName: "yushchevel_walk",
    // );

    super.initState();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: GestureDetector(
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
                          slivers: [
                            SliverVideoAppBar(workout: widget.workout),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kSpacing,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    const SizedBox(
                                      height: kSpacing,
                                    ),
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
                                  ],
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kSpacing,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    WorkoutDescription(
                                      title: "Log today's session",
                                      subtitle: "",
                                      trailing: PlatformTextButton(
                                        child: Text(
                                          "History",
                                          style: platformThemeData(
                                            context,
                                            material: (data) => data
                                                .textTheme.bodyText1
                                                ?.copyWith(
                                              color: Colors.blue,
                                            ),
                                            cupertino: (data) => data
                                                .textTheme.textStyle
                                                .copyWith(
                                              color: CupertinoColors.activeBlue,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => _onHistoryPress(
                                          context: context,
                                          title: "History",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing),
                                  ],
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kSpacing,
                              ),
                              sliver: AnimatedSliverListWrapper(
                                dense: true,
                                list: list,
                                onWeightTap: _setWeight,
                                onRepsTap: _setReps,
                                onDurationTap: _setDuration,
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kSpacing,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    // const SizedBox(height: kSpacing * 2),
                                    // MeasurementRadioButtons(
                                    //   measurement: measurement,
                                    //   setState: (value) => setState(
                                    //     () {
                                    //       measurement = value;
                                    //     },
                                    //   ),
                                    // ),
                                    const SizedBox(height: kSpacing * 4),
                                    const WorkoutDescription(
                                      title: "Notes",
                                      subtitle: "",
                                    ),
                                    const SizedBox(height: kSpacing),
                                    if (foundKey != null &&
                                        foundKey!.isNotEmpty)
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
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        hintText:
                                            "What did I learn this session",
                                        minLines: 2,
                                        maxLines: 10,
                                        controller: _notesController,
                                        keyboardType: TextInputType.multiline,
                                        cupertino: (_, __) =>
                                            CupertinoTextFieldData(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: CupertinoColors
                                                .darkBackgroundGray,
                                          ),
                                        ),
                                        material: (_, __) =>
                                            MaterialTextFieldData(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing * 4),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: kSpacing * 2,
                          right: kSpacing * 2,
                          bottom: kSpacing * 2,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: PlatformElevatedButton(
                            material: (_, __) => MaterialElevatedButtonData(
                              style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor,
                              ),
                            ),
                            cupertino: (_, __) => CupertinoElevatedButtonData(
                              color: kPrimaryColor,
                              originalStyle: true,
                            ),
                            onPressed: () =>
                                _handleSubmitWorkoutComplete(context),
                            child: const Text(
                              "Complete Workout",
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
    );
  }
}
