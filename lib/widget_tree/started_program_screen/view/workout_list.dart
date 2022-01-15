import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_user_started_program.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/day_container.dart';

class WorkoutListDayTiles extends StatefulWidget {
  const WorkoutListDayTiles({
    required this.program,
    Key? key,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;

  @override
  State<WorkoutListDayTiles> createState() => _WorkoutListDayTilesState();
}

class _WorkoutListDayTilesState extends State<WorkoutListDayTiles> {
  FirebaseProgram get programData => widget.program.data();

  late String _docId;

  String? get _userId => FirebaseAuth.instance.currentUser?.email;

  Future<List<DocumentReference<FirebaseProgram>>?> _getProgramDays() async {
    try {
      final day_1 = _getProgramDay("day_1");
      final day_2 = _getProgramDay("day_2");
      final day_3 = _getProgramDay("day_3");

      return Future.wait([day_1, day_2, day_3]);
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  Future<DocumentReference<FirebaseProgram>> _getProgramDay(String day) async =>
      programData.getCollectionReference().doc(day);

  @override
  void initState() {
    FirebaseUserStartedProgram()
        .getCollectionReference(userId: _userId)
        .get()
        .then((doc) {
      final QueryDocumentSnapshot<FirebaseUserStartedProgram> ongoingPrograms =
          doc.docs.firstWhere((e) => e.data().program_id == widget.program.id);

      if (ongoingPrograms.exists) {
        setState(() {
          _docId = ongoingPrograms.id;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentReference<FirebaseProgram>>?>(
      future: _getProgramDays(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DayContainer>? programDays = snapshot.data
              ?.map((data) => DayContainer(
                    programDay: data,
                    program: widget.program,
                  ))
              .toList();

          if (programDays != null) {
            return Column(
              children: [
                ...programDays,
                const SizedBox(
                  height: kSpacing * 2,
                ),
                SizedBox(
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
                    onPressed: () {
                      FirebaseUserStartedProgram().toggleProgramActiveState(
                        state: false,
                        userId: _userId,
                        docId: _docId,
                      );

                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      "Mark Program as Complete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: kSpacing * 2,
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
