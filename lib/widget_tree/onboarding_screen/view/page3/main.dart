import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page3/cupertinoFields.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page3/materialFormFields.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page3Body({
  required BuildContext context,
  FirebaseUser? firebaseUser,
}) =>
    [
      Column(
        children: [
          PlatformWidget(
            cupertino: (_, __) => CupertinoFormFields(
              firebaseUser: firebaseUser,
            ),
            material: (_, __) => const MaterialFormFields(),
          )
        ],
      ),
    ];
