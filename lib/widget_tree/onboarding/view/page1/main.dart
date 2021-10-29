import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/view/get_started_button.dart';
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
              margin: const EdgeInsets.only(top: kSpacing * 2),
              child: Text(
                '''Looking to be your strongest self?
Looking to lose weight or
improve confidence?''',
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.subtitle1,
                  cupertino: (data) => data.textTheme.textStyle,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: kSpacing * 8,
            ),
            GetStartedButton(
              controller: controller,
              backgroundColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    ];
