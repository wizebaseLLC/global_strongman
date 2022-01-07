import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/exclusive_workout_programs.dart';
import 'package:global_strongman/widget_tree/home_screen/view/filter_icon.dart';
import 'package:global_strongman/widget_tree/home_screen/view/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool cardio = true;
  bool strength = true;
  bool rehab = true;
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
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilterIconRow(context),
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
                                    .where((doc) =>
                                        ongoingPrograms.contains(doc.id))
                                    .toList(),
                                isContinue: true,
                                cardio: cardio,
                                strength: strength,
                                rehab: rehab,
                                strongman: strongman,
                              ),
                            const SizedBox(height: kSpacing * 3),
                            const SectionHeader(
                              text: "Exclusive workout programs",
                            ),
                            const SizedBox(height: kSpacing * 2),
                            ExclusiveWorkoutPrograms(
                              docs: snapshot.data!.docs,
                              cardio: cardio,
                              strength: strength,
                              rehab: rehab,
                              strongman: strongman,
                            ),
                            const SizedBox(height: kSpacing * 3),
                          ],
                        ),
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
          child: FilterIcon(
            context: context,
            name: "Cardio",
            selected: cardio,
            backgroundColor: Colors.redAccent.shade200.withOpacity(.3),
            icon: SvgPicture.asset(
              "assets/images/pulse.svg",
              color: cardio
                  ? Colors.red.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
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
          child: FilterIcon(
            context: context,
            name: "Strength",
            selected: strength,
            backgroundColor: Colors.purpleAccent.shade200.withOpacity(.3),
            icon: SvgPicture.asset(
              "assets/images/muscle.svg",
              color: strength
                  ? Colors.purpleAccent.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
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
          child: FilterIcon(
            context: context,
            backgroundColor: Colors.tealAccent.shade200.withOpacity(.3),
            selected: rehab,
            name: "Rehab",
            icon: SvgPicture.asset(
              "assets/images/cycling.svg",
              color: rehab
                  ? Colors.tealAccent.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
            ),
            toggleState: () {
              setState(
                () {
                  rehab = !rehab;
                },
              );
            },
          ),
        ),
        Expanded(
          child: FilterIcon(
            backgroundColor: Colors.blueAccent.shade200.withOpacity(.3),
            context: context,
            name: "Strongman",
            selected: strongman,
            icon: SvgPicture.asset(
              "assets/images/weightlifting.svg",
              color: strongman
                  ? Colors.blueAccent.shade700
                  : Platform.isIOS
                      ? CupertinoColors.systemGrey
                      : Colors.grey.shade500,
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
}
