import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/badge.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/badges_screen/badge_tile.dart';
import 'package:provider/provider.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({required this.heroId, Key? key}) : super(key: key);
  final String heroId;

  @override
  Widget build(BuildContext context) {
    final List<Badge> badgeList =
        context.watch<BadgeCurrentValues>().getAllSortedBadges();
    return PlatformScaffoldIosSliverTitle(
      title: "Badges",
      trailingActions: const [],
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: kSpacing * 4,
              ),
              Hero(
                tag: heroId,
                child: const FaIcon(
                  FontAwesomeIcons.trophy,
                  color: Color.fromRGBO(248, 186, 73, 1),
                  size: 50,
                ),
              ),
              const SizedBox(
                height: kSpacing * 2,
              ),
              Text(
                "Keep it up!",
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.headline6,
                  cupertino: (data) =>
                      data.textTheme.navTitleTextStyle.copyWith(
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                height: kSpacing,
              ),
              Text(
                "${context.watch<BadgeCurrentValues>().completedBadgeCount}/${context.watch<BadgeCurrentValues>().totalBadgeCount} badged earned",
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.bodyText2,
                  cupertino: (data) =>
                      data.textTheme.navTitleTextStyle.copyWith(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey3,
                  ),
                ),
              ),
              if (!Platform.isIOS)
                const SizedBox(
                  height: kSpacing * 4,
                ),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: badgeList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: kSpacing * 2),
                  child: BadgeTile(
                    title: badgeList[index].title,
                    image: badgeList[index].badgeImage,
                    currentValue: badgeList[index].currentValue,
                    maxValue: badgeList[index].value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
