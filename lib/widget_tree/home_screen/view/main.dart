import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/exclusive_workout_programs.dart';
import 'package:global_strongman/widget_tree/home_screen/view/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Stream<QuerySnapshot<FirebaseProgram>> _getPrograms() =>
      FirebaseProgram().getCollectionReference().snapshots();

  Stream<QuerySnapshot<FirebaseUserStartedProgram>> _getOngoingPrograms() =>
      FirebaseUserStartedProgram()
          .getCollectionReference(
            userId: FirebaseAuth.instance.currentUser!.email!,
          )
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<FirebaseUserStartedProgram>>(
        stream: _getOngoingPrograms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator.adaptive();
          }
          final List<String?>? ongoingPrograms = snapshot.data?.docs
              .map((e) =>
                  e.data().is_active == true ? e.data().program_id : null)
              .toList();
          return SafeArea(
            child: StreamBuilder<QuerySnapshot<FirebaseProgram>>(
                stream: _getPrograms(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  if (snapshot.hasData) {
                    final bool snapshotHasData = snapshot.data?.docs != null;
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterIconRow(context),
                          const SizedBox(height: kSpacing * 3),
                          if (snapshotHasData)
                            const SectionHeader(
                              text: "Exclusive workout programs",
                            ),
                          const SizedBox(height: kSpacing * 2),
                          ExclusiveWorkoutPrograms(docs: snapshot.data!.docs),
                          const SizedBox(height: kSpacing * 3),
                          if (ongoingPrograms != null &&
                              ongoingPrograms.isNotEmpty)
                            const SectionHeader(
                              text: "Continue where you left off",
                            ),
                          if (ongoingPrograms != null &&
                              ongoingPrograms.isNotEmpty)
                            const SizedBox(height: kSpacing * 2),
                          if (ongoingPrograms != null &&
                              ongoingPrograms.isNotEmpty)
                            ExclusiveWorkoutPrograms(
                              docs: snapshot.data!.docs
                                  .where(
                                      (doc) => ongoingPrograms.contains(doc.id))
                                  .toList(),
                              isContinue: true,
                            ),
                        ],
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator.adaptive();
                  }
                }),
          );
        });
  }

  Widget _buildFilterIconRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _filterIcon(
            context: context,
            name: "Cardio",
            backgroundColor: Colors.redAccent.shade200.withOpacity(.3),
            icon: Icon(
              PlatformIcons(context).heartSolid,
              color: Colors.red.shade700,
              size: 25,
            ),
          ),
        ),
        Expanded(
          child: _filterIcon(
            context: context,
            name: "Strength",
            backgroundColor: Colors.purpleAccent.shade200.withOpacity(.3),
            icon: FaIcon(
              FontAwesomeIcons.dumbbell,
              color: Colors.purpleAccent.shade700,
              size: 25,
            ),
          ),
        ),
        Expanded(
          child: _filterIcon(
            context: context,
            backgroundColor: Colors.tealAccent.shade200.withOpacity(.3),
            name: "Endurance",
            icon: Icon(
              PlatformIcons(context).clockSolid,
              color: Colors.tealAccent.shade700,
              size: 25,
            ),
          ),
        ),
        Expanded(
          child: _filterIcon(
            backgroundColor: Colors.blueAccent.shade200.withOpacity(.3),
            context: context,
            name: "Strongman",
            icon: Icon(
              PlatformIcons(context).heartSolid,
              color: Colors.blueAccent.shade700,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Column _filterIcon({
    required BuildContext context,
    required Widget icon,
    required Color backgroundColor,
    required String name,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: kSpacing * 2,
            bottom: kSpacing,
          ),
          child: CircleAvatar(
            minRadius: 30,
            backgroundColor: backgroundColor,
            child: icon,
          ),
        ),
        Text(
          name,
          style: platformThemeData(context,
              material: (data) => data.textTheme.bodyText1,
              cupertino: (data) =>
                  data.textTheme.tabLabelTextStyle.copyWith(fontSize: 13)),
        )
      ],
    );
  }
}
