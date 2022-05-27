import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/overview/overview_tab.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/reviews.dart';
import 'package:global_strongman/widget_tree/home_screen/view/sliver_image_appbar.dart';
import 'package:global_strongman/widget_tree/home_screen/view/sliver_list_content.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({
    required this.program,
    Key? key,
    required this.heroId,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  final String heroId;

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  get tabScreens => [
        OverviewTab(
          program: widget.program,
        ),
        //  WorkoutList(program: widget.program),
        Reviews(program: widget.program),
      ];

  int currentTab = 0;
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
              SliverImageAppBar(program: widget.program, heroId: widget.heroId),
              SliverListContent(
                program: widget.program,
                currentTab: currentTab,
                setState: (value) => setState(
                  () {
                    currentTab = value as int;
                  },
                ),
              ),
              SliverAnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: tabScreens[currentTab],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
