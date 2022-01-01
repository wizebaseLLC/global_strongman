import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/screens/program.dart';
import 'package:global_strongman/widget_tree/started_program_screen/view/main.dart';

class ExclusiveWorkoutPrograms extends StatelessWidget {
  const ExclusiveWorkoutPrograms({
    required this.docs,
    this.isContinue,
    Key? key,
    required this.cardio,
    required this.strength,
    required this.endurance,
    required this.strongman,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<FirebaseProgram>> docs;
  final bool? isContinue;
  final bool cardio;
  final bool strength;
  final bool endurance;
  final bool strongman;

  List<String?> get filters => [
        if (cardio) "cardio",
        if (strength) "strength",
        if (endurance) "endurance",
        if (strongman) "strongman",
      ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: docs
            .map((program) => AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: program
                          .data()
                          .categories!
                          .any((element) => filters.contains(element))
                      ? 1
                      : .2,
                  child: _card(
                    program: program,
                    context: context,
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _navigateToProgram(
    BuildContext context,
    QueryDocumentSnapshot<FirebaseProgram> program,
    String heroId,
  ) =>
      Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (_) => isContinue == true
              ? StartedProgramScreen(program: program)
              : ProgramScreen(program: program, heroId: heroId),
        ),
      );

  Widget _card({
    required QueryDocumentSnapshot<FirebaseProgram> program,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: PlatformWidgetBuilder(
        cupertino: (_, child, __) => Hero(
          tag: isContinue == true ? "${program.id}_continue" : program.id,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: child!,
            onPressed: () => _navigateToProgram(context, program, program.id),
          ),
        ),
        material: (_, child, __) => Hero(
          tag: isContinue == true ? "${program.id}_continue" : program.id,
          child: Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: child,
          ),
        ),
        child: SizedBox(
          width: 303,
          height: 185,
          child: Platform.isIOS
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: CachedNetworkImage(
                    imageUrl: program.data().thumbnail_url!,
                    fit: BoxFit.fill,
                    memCacheWidth: 909,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: TextButton(
                    onPressed: () =>
                        _navigateToProgram(context, program, program.id),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Material(
                      child: Ink.image(
                        image: CachedNetworkImageProvider(
                          program.data().thumbnail_url!,
                          maxWidth: 833,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
