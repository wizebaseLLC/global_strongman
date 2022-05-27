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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ExclusiveWorkoutPrograms extends StatelessWidget {
  const ExclusiveWorkoutPrograms({
    required this.docs,
    this.isContinue,
    Key? key,
    required this.cardio,
    required this.strength,
    required this.rehab,
    required this.strongman,
    this.shouldDisplayVertical,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<FirebaseProgram>>? docs;
  final bool? isContinue;
  final bool cardio;
  final bool strength;
  final bool rehab;
  final bool strongman;
  final bool? shouldDisplayVertical;

  bool get _shouldScrollVertically =>
      shouldDisplayVertical != null && shouldDisplayVertical == true;

  List<String?> get filters => [
        if (cardio) "cardio",
        if (strength) "strength",
        if (rehab) "rehab",
        if (strongman) "strongman",
      ];
  @override
  Widget build(BuildContext context) {
    if (docs == null || (docs != null && docs!.isEmpty)) return Container();
    return SingleChildScrollView(
      scrollDirection:
          _shouldScrollVertically ? Axis.vertical : Axis.horizontal,
      child: _shouldScrollVertically
          ? Column(
              children: docs!
                  .map((program) => Padding(
                        padding: const EdgeInsets.only(top: kSpacing * 2),
                        child: _card(
                          program: program,
                          context: context,
                          noHeroAnimation: true,
                        ),
                      ))
                  .toList(),
            )
          : Row(
              children: docs!
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
                          noHeroAnimation: false,
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
        MaterialWithModalsPageRoute(
          builder: (_) => isContinue == true
              ? StartedProgramScreen(program: program)
              : ProgramScreen(program: program, heroId: heroId),
        ),
      );

  Widget _card({
    required QueryDocumentSnapshot<FirebaseProgram> program,
    required BuildContext context,
    required bool noHeroAnimation,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: PlatformWidgetBuilder(
        cupertino: (_, child, __) => noHeroAnimation
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: child!,
                onPressed: () =>
                    _navigateToProgram(context, program, program.id),
              )
            : Hero(
                tag: isContinue == true ? "${program.id}_continue" : program.id,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: child!,
                  onPressed: () =>
                      _navigateToProgram(context, program, program.id),
                ),
              ),
        material: (_, child, __) => noHeroAnimation
            ? Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: child,
              )
            : Hero(
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
                    memCacheWidth: 780,
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
                          maxWidth: 780,
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
