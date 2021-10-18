import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

/// Returns a List of Widgets that is placed in a column
///
/// This is used as the body of the on-boarding page.
List<Widget> page1Body({required BuildContext context}) => [
      Container(
        margin: const EdgeInsets.only(top: kSpacing * 2),
        child: Text(
          "Welcome to",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      Text(
        "Global Strongman",
        style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
      ),
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
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ];
