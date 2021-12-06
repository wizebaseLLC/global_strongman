import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/view/premium_chip.dart';

class AppBarBottomRow extends StatelessWidget {
  const AppBarBottomRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: platformThemeData(
        context,
        material: (data) => data.cardColor.withOpacity(.4),
        cupertino: (data) => data.scaffoldBackgroundColor.withOpacity(.4),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: kSpacing,
          ),
          const PremiumChip(),
          const SizedBox(
            width: kSpacing * 2,
          ),
          Icon(
            Icons.star,
            color: Colors.yellowAccent.shade700,
            size: 20,
          ),
          const SizedBox(
            width: kSpacing / 2,
          ),
          Text(
            "4.8 • 5000 reviews",
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.caption,
              cupertino: (data) =>
                  data.textTheme.textStyle.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          PlatformTextButton(
            onPressed: () {},
            padding: const EdgeInsets.symmetric(
              horizontal: kSpacing * 2,
              vertical: 0,
            ),
            child: Text(
              "Get Started",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Platform.isIOS
                    ? CupertinoColors.activeBlue
                    : Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
