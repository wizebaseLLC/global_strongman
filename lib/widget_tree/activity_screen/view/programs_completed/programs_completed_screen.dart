import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/home_screen/view/exclusive_workout_programs.dart';

class ProgramsCompletedScreen extends StatelessWidget {
  const ProgramsCompletedScreen({
    required this.previousPageTitle,
    Key? key,
  }) : super(key: key);

  final String previousPageTitle;

  Future<QuerySnapshot<FirebaseProgram>> _getPrograms() => FirebaseProgram()
      .getCollectionReference()
      .where("is_active", isEqualTo: true)
      .get();

  Stream<QuerySnapshot<FirebaseUserStartedProgram>> _getOngoingPrograms(
          String? _user) =>
      FirebaseUserStartedProgram()
          .getCollectionReference(
            userId: _user,
          )
          .where("is_active", isEqualTo: false)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();
    return FutureBuilder<QuerySnapshot<FirebaseProgram>>(
      future: _getPrograms(),
      builder: (context, programSnapshot) {
        return StreamBuilder<QuerySnapshot<FirebaseUserStartedProgram>>(
          stream: _getOngoingPrograms(_user.authUser?.email),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator.adaptive();
            }
            final List<String?>? ongoingPrograms =
                snapshot.data?.docs.map((e) => e.data().program_id).toList();

            return PlatformScaffoldIosSliverTitle(
              title: "Completed Programs",
              previousPageTitle: previousPageTitle,
              trailingActions: const [],
              body: ExclusiveWorkoutPrograms(
                docs: programSnapshot.data?.docs
                    .where((doc) => ongoingPrograms!.contains(doc.id))
                    .toList(),
                isContinue: false,
                cardio: true,
                strength: true,
                rehab: true,
                strongman: true,
                shouldDisplayVertical: true,
              ),
            );
          },
        );
      },
    );
  }
}
