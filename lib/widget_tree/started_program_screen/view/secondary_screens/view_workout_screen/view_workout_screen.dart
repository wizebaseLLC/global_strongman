import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/measurement_radio_buttons.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/description.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/progression_line_chart.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/sliver_video_app_bar.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/secondary_screens/view_workout_screen/workout_title.dart';

enum Measurement { lbs, kgs, seconds }

class ViewWorkoutScreen extends StatefulWidget {
  const ViewWorkoutScreen({
    required this.workout,
    required this.workout_id,
    required this.program_id,
    Key? key,
  }) : super(key: key);

  final FirebaseProgramWorkouts workout;
  final String program_id;
  final String workout_id;

  @override
  State<ViewWorkoutScreen> createState() => _ViewWorkoutScreenState();
}

class _ViewWorkoutScreenState extends State<ViewWorkoutScreen> {
  Measurement? measurement = Measurement.lbs;
  final TextEditingController _controller = TextEditingController();
  String get _user => FirebaseAuth.instance.currentUser!.email!;

  Future<void> _handleSubmitWorkoutComplete(BuildContext context) async {
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

    FirebaseUserWorkoutComplete(
      created_on: DateTime.now(),
      seconds: seconds,
      program_id: widget.program_id,
      working_weight_kgs: kgs,
      working_weight_lbs: lbs,
      workout_id: widget.workout_id,
    ).addCompletedWorkout(
      user: _user,
    );

    Navigator.pop(context, true);
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
        .get();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  return CustomScrollView(
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kSpacing,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: PlatformTextField(
                                      hintText:
                                          measurement == Measurement.seconds
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
                                        decoration: const InputDecoration(
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kSpacing),
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
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: kSpacing * 8),
                          ],
                        ),
                      )
                    ],
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
