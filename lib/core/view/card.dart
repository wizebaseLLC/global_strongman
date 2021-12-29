import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class GlobalCard extends StatelessWidget {
  const GlobalCard({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpacing * 2),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSpacing),
        color: platformThemeData(
          context,
          material: (data) => data.cardColor,
          cupertino: (data) => data.barBackgroundColor,
        ),
      ),
      child: child,
    );
  }
}
