import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/core/view/premium_chip.dart';
import 'package:global_strongman/widget_tree/home_screen/view/overview/overview_tab.dart';
import 'package:provider/provider.dart';

class AppBarBottomRow extends StatelessWidget {
  const AppBarBottomRow({
    required this.program,
    Key? key,
  }) : super(key: key);
  final QueryDocumentSnapshot<FirebaseProgram> program;

  FirebaseProgram get programData => program.data();
  String get averageRating => programData.average_rating.toString();

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();
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
            "${averageRating.length <= 3 ? averageRating : averageRating.substring(0, 3)} • ${programData.rating_count.toString()} reviews",
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
            onPressed: () => OverviewTab.handleGetStarted(
              programId: program.id,
              userId: _user.authUser?.email ?? 'n/a',
              context: context,
              program: program,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: kSpacing * 2,
              vertical: 0,
            ),
            child: Text(
              "Get Started",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
