import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page2Body({
  required BuildContext context,
  required Color backgroundColor,
}) =>
    [
      Container(
        margin: const EdgeInsets.only(top: kSpacing * 2),
        child: Text(
          "Welcome to",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    ];
