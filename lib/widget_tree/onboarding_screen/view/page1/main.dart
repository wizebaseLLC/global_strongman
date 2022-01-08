import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/get_started_button.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page1Body({
  required BuildContext context,
  required GlobalKey<IntroductionScreenState> controller,
}) =>
    [
      Container(
        padding: const EdgeInsets.all(
          kSpacing * 2,
        ).copyWith(
          bottom: kSpacing * 4,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: kSpacing),
              child: Text(
                '''The best strongman platform on the market''',
                style: platformThemeData(
                  context,
                  material: (data) =>
                      data.textTheme.subtitle1?.copyWith(color: Colors.grey),
                  cupertino: (data) =>
                      data.textTheme.textStyle.copyWith(color: Colors.grey),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: kSpacing * 2,
            ),
            Text(
              '''Learn from the best Strongman Trainer in the world''',
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.subtitle1,
                cupertino: (data) => data.textTheme.textStyle,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kSpacing * 4,
            ),
            Text(
              'Global Strongman helps you easily track your fitness.  Train interactively and plan your workouts.',
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.subtitle1
                    ?.copyWith(color: Colors.grey, fontSize: 14),
                cupertino: (data) => data.textTheme.textStyle
                    .copyWith(color: Colors.grey, fontSize: 14),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kSpacing * 4,
            ),
            GetStartedButton(
              controller: controller,
              backgroundColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    ];
