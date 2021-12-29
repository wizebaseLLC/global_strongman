import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/program_header.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/workout_list.dart';

class StartedProgramScreen extends StatelessWidget {
  const StartedProgramScreen({required this.program, Key? key})
      : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  FirebaseProgram get programData => program.data();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: Colors.transparent,
        material: (_, __) => MaterialAppBarData(elevation: 0),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProgramHeader(program: program),
                  const SizedBox(height: kSpacing * 2),
                  Text(
                    "Workout list",
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.subtitle1,
                      cupertino: (data) => data.textTheme.navTitleTextStyle,
                    ),
                  ),
                  const SizedBox(height: kSpacing * 2),
                  WorkoutListDayTiles(program: program),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
