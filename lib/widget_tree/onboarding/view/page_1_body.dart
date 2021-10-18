import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/view/get_started_button.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page1Body({
  required BuildContext context,
  required Color backgroundColor,
  required GlobalKey<IntroductionScreenState> controller,
}) =>
    [
      Container(
        padding: const EdgeInsets.all(kSpacing * 2),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kSpacing * 4),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: kSpacing * 2),
              child: Text(
                '''Looking to be your strongest self?
Looking to lose weight or
improve confidence?''',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: kSpacing * 4),
              child: Text(
                '''
The Global Strongman Module 
will get you there''',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: kSpacing * 4,
            ),
            if (MediaQuery.of(context).size.height > 800)
              GetStartedButton(
                controller: controller,
                backgroundColor: backgroundColor,
              ),
          ],
        ),
      ),
    ];
