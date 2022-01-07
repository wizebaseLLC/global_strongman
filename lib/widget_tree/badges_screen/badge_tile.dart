import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class BadgeTile extends StatelessWidget {
  const BadgeTile({
    required this.title,
    required this.image,
    required this.currentValue,
    required this.maxValue,
    Key? key,
  }) : super(key: key);

  final String title;
  final String image;
  final int currentValue;
  final int maxValue;

  int get limitedCurrentValue =>
      currentValue > maxValue ? maxValue : currentValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: platformThemeData(
            context,
            material: (data) => data.cardColor,
            cupertino: (data) => data.barBackgroundColor,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: kSpacing,
            horizontal: kSpacing * 2,
          ),
          leading: Image.asset(
            image,
            height: 50,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: kSpacing),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
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
                    text: " ($limitedCurrentValue/$maxValue)",
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.bodyText2?.copyWith(
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
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: kSpacing),
            child: SliderTheme(
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
                  max: maxValue.toDouble(),
                  activeColor: const Color(0XFFFE7762),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
