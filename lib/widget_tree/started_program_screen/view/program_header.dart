import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/view/card.dart';

class ProgramHeader extends StatelessWidget {
  const ProgramHeader({required this.program, Key? key}) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  FirebaseProgram get programData => program.data();

  @override
  Widget build(BuildContext context) {
    return GlobalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            programData.name!,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.headline6,
              cupertino: (data) => data.textTheme.navTitleTextStyle,
            ),
          ),
          const SizedBox(
            height: kSpacing,
          ),
          Text(
            "${programData.workout_count} workouts",
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1?.copyWith(
                color: Colors.white60,
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                fontSize: 14,
                color: CupertinoColors.systemGrey2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
