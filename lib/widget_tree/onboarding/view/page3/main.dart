import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page3/cupertinoFields.dart';
import 'package:global_strongman/widget_tree/onboarding/view/page3/materialFormFields.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page3Body({
  required BuildContext context,
}) =>
    [
      Column(
        children: [
          PlatformWidget(
            cupertino: (_, __) => const CupertinoFormFields(),
            material: (_, __) => const MaterialFormFields(),
          )
        ],
      ),
    ];
