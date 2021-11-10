import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page4/cupertinoFields.dart';
import 'package:global_strongman/widget_tree/onboarding_screen/view/page4/materialFormFields.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page4Body({
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
            material: (_, __) => MaterialFormFields(
              firebaseUser: firebaseUser,
            ),
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
          ),
        ],
      ),
    ];
