import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/day_container.dart';

class WorkoutListDayTiles extends StatelessWidget {
  const WorkoutListDayTiles({required this.program, Key? key})
      : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  FirebaseProgram get programData => program.data();

  Future<List<DocumentReference<FirebaseProgram>>?> _getProgramDays() async {
    try {
      final day_1 = _getProgramDay("day_1");
      final day_2 = _getProgramDay("day_2");
      final day_3 = _getProgramDay("day_3");

      return Future.wait([day_1, day_2, day_3]);
    } catch (err) {
      print(err.toString());
    }
  }

  Future<DocumentReference<FirebaseProgram>> _getProgramDay(String day) async =>
      programData.getCollectionReference().doc(day);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentReference<FirebaseProgram>>?>(
      future: _getProgramDays(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DayContainer>? programDays = snapshot.data
              ?.map((data) => DayContainer(
                    programDay: data,
                    program: program,
                  ))
              .toList();

          if (programDays != null) {
            return Column(
              children: programDays,
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
