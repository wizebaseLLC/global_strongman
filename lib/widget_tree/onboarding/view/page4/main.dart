import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page4/cupertinoFields.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page4/materialFormFields.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page4Body({
  required BuildContext context,
  required Color backgroundColor,
}) =>
    [
      Column(
        children: [
          PlatformWidget(
            cupertino: (_, __) => CupertinoFormFields(
              backgroundColor: backgroundColor,
            ),
            material: (_, __) => const MaterialFormFields(),
          ),
          const SizedBox(
            height: kSpacing * 3,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: kSpacing,
              right: kSpacing,
            ),
            width: MediaQuery.of(context).size.width,
            child: PlatformButton(
              onPressed: () => {print("complete")},
              child: PlatformText(
                'Submit',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              material: (_, __) => MaterialRaisedButtonData(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              )),
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    ];
