import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/badge.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:provider/provider.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    Key? key,
  }) : super(key: key);

  Badge getClosestToAchievingBadge(List<Badge> filteredBadges) =>
      filteredBadges.reduce(
        (kingOfTheHill, element) {
          final int elementCurrentValue = element.currentValue;
          final int elementDesiredValue = element.value;

          if (elementCurrentValue >= elementDesiredValue) {
            return kingOfTheHill;
          }

          final int difference = elementDesiredValue - elementCurrentValue;

          final int kingOfTheHillCurrentValue = kingOfTheHill.currentValue;
          final int kingOfTheHillDesiredValue = kingOfTheHill.currentValue;

          final int kingDifference =
              kingOfTheHillDesiredValue - kingOfTheHillCurrentValue;

          return kingDifference > difference ? element : kingOfTheHill;
        },
      );

  @override
  Widget build(BuildContext context) {
    final List<Badge> allSortedBadges =
        context.watch<BadgeCurrentValues>().getAllSortedBadges();

    if (allSortedBadges.isEmpty) {
      return Container();
    }

    final List<Badge> filteredBadges = allSortedBadges
        .where(
          (element) =>
              element.currentValue < element.value && element.currentValue != 0,
        )
        .toList();

    if (filteredBadges.isEmpty) {
      return Container();
    }

    final almostThere = getClosestToAchievingBadge(filteredBadges);

    final int limitedCurrentValue = almostThere.currentValue > almostThere.value
        ? almostThere.value
        : almostThere.currentValue;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: kSpacing,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      color: platformThemeData(
        context,
        material: (data) => data.cardColor,
        cupertino: (data) => data.barBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: kSpacing,
              horizontal: kSpacing * 2,
            ),
            leading: Image.asset(
              almostThere.badgeImage,
              height: 40,
            ),
            title: Text(
              'Almost there, keep it up!',
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.subtitle1,
                cupertino: (data) => data.textTheme.navTitleTextStyle,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: kSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: almostThere.title,
                          style: platformThemeData(
                            context,
                            material: (data) => data.textTheme.bodyText1,
                            cupertino: (data) =>
                                data.textTheme.navTitleTextStyle.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: " ($limitedCurrentValue/${almostThere.value})",
                          style: platformThemeData(
                            context,
                            material: (data) =>
                                data.textTheme.bodyText2?.copyWith(
                              color: Colors.white54,
                            ),
                            cupertino: (data) =>
                                data.textTheme.navTitleTextStyle.copyWith(
                              fontSize: 15,
                              color: CupertinoColors.systemGrey2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: kSpacing * 2,
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbColor: Colors.transparent,
                      overlayShape: SliderComponentShape.noThumb,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                    ),
                    child: AbsorbPointer(
                      child: Slider(
                        onChanged: (_) {},
                        value: limitedCurrentValue.toDouble(),
                        min: 0,
                        max: almostThere.value.toDouble(),
                        activeColor: const Color(0XFFFE7762),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
