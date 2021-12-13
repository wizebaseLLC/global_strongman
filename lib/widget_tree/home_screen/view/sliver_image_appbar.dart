import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/appbar_bottom_row.dart';
import 'package:global_strongman/widget_tree/home_screen/view/shaded_image.dart';

class SliverImageAppBar extends StatelessWidget {
  const SliverImageAppBar({
    Key? key,
    required this.program,
    required this.heroId,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  final String heroId;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: platformThemeData(
        context,
        material: (data) => data.appBarTheme.backgroundColor,
        cupertino: (data) => data.barBackgroundColor,
      ),
      floating: true,
      expandedHeight: 300,
      stretch: true,
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: AppBarBottomRow(program: program),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        background: ShadedImage(
          program: program,
          heroId: heroId,
        ),
      ),
    );
  }
}
