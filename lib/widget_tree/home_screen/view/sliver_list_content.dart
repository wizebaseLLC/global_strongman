import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/program_tabs.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_button.dart';

class SliverListContent extends StatefulWidget {
  const SliverListContent({
    required this.program,
    required this.currentTab,
    required this.setState,
    Key? key,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;
  final int currentTab;
  final void Function(int?) setState;
  @override
  State<SliverListContent> createState() => _SliverListContentState();
}

class _SliverListContentState extends State<SliverListContent>
    with SingleTickerProviderStateMixin {
  get createdOn =>
      "${programData.created_on?.toUtc().month}-${programData.created_on?.toUtc().day}-${programData.created_on?.toUtc().year}";

  FirebaseProgram get programData => widget.program.data();

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
                  currentTab: widget.currentTab,
                  setTab: widget.setState,
                ),
                const SizedBox(height: kSpacing * 2),
                if (widget.currentTab == 1)
                  ReviewButton(program: widget.program),
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
