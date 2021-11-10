import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page2/avatar.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page2/cupertinoFields.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page2/materialFormFields.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page2Body({
  required BuildContext context,
  bool shouldShowAvatar = true,
  FirebaseUser? firebaseUser,
}) =>
    [
      Column(
        children: [
          if (shouldShowAvatar)
            const SizedBox(
              width: 75,
              height: 75,
              child: FormAvatar(),
            ),
          if (shouldShowAvatar)
            const SizedBox(
              height: kSpacing * 2,
            ),
          PlatformWidget(
            cupertino: (_, __) => CupertinoFormFields(
              firebaseUser: firebaseUser,
            ),
            material: (_, __) => MaterialFormFields(
              firebaseUser: firebaseUser,
            ),
          )
        ],
      ),
    ];
