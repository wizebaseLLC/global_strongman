import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/exclusive_workout_programs.dart';
import 'package:global_strongman/widget_tree/home_screen/view/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool cardio = true;
  bool strength = true;
  bool endurance = true;
  bool strongman = true;

  Stream<QuerySnapshot<FirebaseProgram>> _getPrograms() => FirebaseProgram()
      .getCollectionReference()
      .where("is_active", isEqualTo: true)
      .snapshots();

  Stream<QuerySnapshot<FirebaseUserStartedProgram>> _getOngoingPrograms() =>
      FirebaseUserStartedProgram()
          .getCollectionReference(
            userId: FirebaseAuth.instance.currentUser!.email!,
          )
          .where("is_active", isEqualTo: true)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<FirebaseUserStartedProgram>>(
        stream: _getOngoingPrograms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator.adaptive();
          }
          final List<String?>? ongoingPrograms =
              snapshot.data?.docs.map((e) => e.data().program_id).toList();
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
                          ExclusiveWorkoutPrograms(
                            docs: snapshot.data!.docs,
                            cardio: cardio,
                            strength: strength,
                            endurance: endurance,
                            strongman: strongman,
                          ),
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
                              cardio: cardio,
                              strength: strength,
                              endurance: endurance,
                              strongman: strongman,
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
            selected: cardio,
            backgroundColor: Colors.redAccent.shade200.withOpacity(.3),
            icon: Icon(
              PlatformIcons(context).heartSolid,
              color: cardio
                  ? Colors.red.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
              size: 25,
            ),
            toggleState: () {
              setState(
                () {
                  cardio = !cardio;
                },
              );
            },
          ),
        ),
        Expanded(
          child: _filterIcon(
            context: context,
            name: "Strength",
            selected: strength,
            backgroundColor: Colors.purpleAccent.shade200.withOpacity(.3),
            icon: FaIcon(
              FontAwesomeIcons.dumbbell,
              color: strength
                  ? Colors.purpleAccent.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
              size: 25,
            ),
            toggleState: () {
              setState(
                () {
                  strength = !strength;
                },
              );
            },
          ),
        ),
        Expanded(
          child: _filterIcon(
            context: context,
            backgroundColor: Colors.tealAccent.shade200.withOpacity(.3),
            selected: endurance,
            name: "Endurance",
            icon: Icon(
              PlatformIcons(context).clockSolid,
              color: endurance
                  ? Colors.tealAccent.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
              size: 25,
            ),
            toggleState: () {
              setState(
                () {
                  endurance = !endurance;
                },
              );
            },
          ),
        ),
        Expanded(
          child: _filterIcon(
            backgroundColor: Colors.blueAccent.shade200.withOpacity(.3),
            context: context,
            name: "Strongman",
            selected: strongman,
            icon: Icon(
              PlatformIcons(context).heartSolid,
              color: strongman
                  ? Colors.blueAccent.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
              size: 25,
            ),
            toggleState: () {
              setState(
                () {
                  strongman = !strongman;
                },
              );
            },
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
    required void Function() toggleState,
    required bool selected,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: kSpacing * 2,
            bottom: kSpacing,
          ),
          child: PlatformWidgetBuilder(
            cupertino: (_, child, __) => CupertinoButton(
              child: child!,
              onPressed: toggleState,
            ),
            material: (_, child, __) => Ink(
              height: 60,
              width: 60,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: backgroundColor,
                onTap: toggleState,
                child: child,
              ),
            ),
            child: CircleAvatar(
              minRadius: 30,
              backgroundColor: selected
                  ? backgroundColor
                  : Platform.isIOS
                      ? CupertinoColors.darkBackgroundGray
                      : Colors.grey.shade900,
              child: icon,
            ),
          ),
        ),
        Text(
          name,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText1,
            cupertino: (data) =>
                data.textTheme.tabLabelTextStyle.copyWith(fontSize: 13),
          ),
        )
      ],
    );
  }
}
