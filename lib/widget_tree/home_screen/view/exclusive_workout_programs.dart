import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/screens/program.dart';

class ExclusiveWorkoutPrograms extends StatelessWidget {
  const ExclusiveWorkoutPrograms({
    required this.docs,
    Key? key,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<FirebaseProgram>> docs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: docs
            .map((program) => _card(
                  program: program,
                  context: context,
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
          builder: (_) => ProgramScreen(program: program, heroId: heroId),
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
          tag: program.id,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: child!,
            onPressed: () => _navigateToProgram(context, program, program.id),
          ),
        ),
        material: (_, child, __) => Hero(
          tag: program.id,
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
