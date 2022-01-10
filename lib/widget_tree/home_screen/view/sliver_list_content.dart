import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/overview/overview_tab.dart';
import 'package:global_strongman/widget_tree/home_screen/view/program_tabs.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/reviews.dart';
import 'package:global_strongman/widget_tree/home_screen/view/workout_list/workout_list.dart';

class SliverListContent extends StatefulWidget {
  const SliverListContent({
    required this.program,
    Key? key,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;

  @override
  State<SliverListContent> createState() => _SliverListContentState();
}

class _SliverListContentState extends State<SliverListContent>
    with SingleTickerProviderStateMixin {
  int currentTab = 0;

  get createdOn =>
      "${programData.created_on?.toUtc().month}-${programData.created_on?.toUtc().day}-${programData.created_on?.toUtc().year}";

  FirebaseProgram get programData => widget.program.data();

  get tabScreens => [
        OverviewTab(
          program: widget.program,
        ),
        WorkoutList(program: widget.program),
        Reviews(program: widget.program),
      ];

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        programData.name!,
                        style: platformThemeData(context,
                            material: (data) => data.textTheme.headline6,
                            cupertino: (data) => data
                                .textTheme.navLargeTitleTextStyle
                                .copyWith(fontSize: 22)),
                      ),
                      const SizedBox(height: kSpacing * 2),
                      _buildHighlightsText(
                        context: context,
                        text:
                            "${programData.workout_count.toString()} exclusive trainings",
                        icon: FaIcon(
                          FontAwesomeIcons.dumbbell,
                          size: 16,
                          color: Platform.isIOS
                              ? CupertinoColors.systemGrey2
                              : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: kSpacing),
                      _buildHighlightsText(
                        context: context,
                        text: "Duration: 90 Days",
                        icon: FaIcon(
                          FontAwesomeIcons.calendarDay,
                          size: 16,
                          color: Platform.isIOS
                              ? CupertinoColors.systemGrey2
                              : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: kSpacing),
                      _buildHighlightsText(
                        context: context,
                        text: "Created on $createdOn",
                        icon: Icon(
                          PlatformIcons(context).timeSolid,
                          size: 16,
                          color: Platform.isIOS
                              ? CupertinoColors.systemGrey2
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kSpacing * 2),
                ProgramTabs(
                  currentTab: currentTab,
                  setTab: (value) => setState(() {
                    currentTab = value as int;
                  }),
                ),
                const SizedBox(height: kSpacing * 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: tabScreens[currentTab],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHighlightsText({
    required BuildContext context,
    required String text,
    required Widget icon,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: kSpacing / 2,
        ),
        Text(
          text,
          textAlign: TextAlign.start,
          style: platformThemeData(context,
              material: (data) => data.textTheme.bodyText2
                  ?.copyWith(color: Colors.grey.shade400),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey2,
                  )),
        ),
      ],
    );
  }
}
