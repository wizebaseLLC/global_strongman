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

  @override
  Widget build(BuildContext context) {
    final Badge? almostThere = context
        .watch<BadgeCurrentValues>()
        .getAllSortedBadges()
        .firstWhere(
          (element) =>
              element.currentValue < element.value && element.currentValue != 0,
        );

    if (almostThere == null) {
      return Container();
    }

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
      color: platformThemeData(context,
          material: (data) => data.backgroundColor,
          cupertino: (data) => data.barBackgroundColor),
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
