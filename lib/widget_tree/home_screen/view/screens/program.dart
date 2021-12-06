import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/sliver_image_appbar.dart';
import 'package:global_strongman/widget_tree/home_screen/view/sliver_list_content.dart';

class ProgramScreen extends StatelessWidget {
  const ProgramScreen({
    required this.program,
    Key? key,
    required this.heroId,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  final String heroId;
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverImageAppBar(program: program, heroId: heroId),
              SliverListContent(program: program),
            ],
          ),
        ),
      ),
    );
  }
}
