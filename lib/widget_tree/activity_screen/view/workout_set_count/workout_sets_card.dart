import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/core/view/card.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/programs_completed/programs_completed_screen.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workout_set_count/workout_set_count_avatar.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/workout_set_count/workout_set_list_tile.dart';
import 'package:global_strongman/widget_tree/badges_screen/main.dart';
import 'package:provider/provider.dart';

class WorkoutSetsCard extends StatelessWidget {
  const WorkoutSetsCard({
    required this.activityInterface,
    Key? key,
  }) : super(key: key);

  final ActivityInterface activityInterface;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: kSpacing * 2,
      ),
      child: GlobalCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: WorkoutSetCountAvatar(
                activityInterface: activityInterface,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WorkoutSetsListTile(
                    icon: const Hero(
                      tag: "activity_trophy",
                      child: FaIcon(
                        FontAwesomeIcons.trophy,
                        color: Color.fromRGBO(248, 186, 73, 1),
                      ),
                    ),
                    title:
                        "${context.watch<BadgeCurrentValues>().completedBadgeCount}",
                    subtitle: "Badges earned",
                    onTap: () {
                      Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (_) => const BadgesScreen(
                            heroId: 'activity_trophy',
                          ),
                        ),
                      );
                    },
                  ),
                  WorkoutSetsListTile(
                    icon: Icon(
                      PlatformIcons(context).clockSolid,
                      color: Colors.blue.shade300,
                    ),
                    title: "${activityInterface.activeDays}",
                    subtitle: "Active days",
                  ),
                  WorkoutSetsListTile(
                    icon: FaIcon(
                      FontAwesomeIcons.dumbbell,
                      color: Colors.green.shade300,
                    ),
                    title: "${activityInterface.programsComplete}",
                    subtitle: "Programs completed",
                    onTap: () {
                      Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (_) => const ProgramsCompletedScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
