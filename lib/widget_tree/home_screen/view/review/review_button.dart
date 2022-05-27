import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/slidingBottomSheetBuilder.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_bottom_sheet_widget.dart';

class ReviewButton extends StatelessWidget {
  const ReviewButton({
    required this.program,
    Key? key,
  }) : super(key: key);

  final QueryDocumentSnapshot<FirebaseProgram> program;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PlatformTextButton(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(right: kSpacing),
            child: Row(
              children: [
                Text(
                  "Review this program",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodyText1?.copyWith(
                      color: Colors.blueAccent,
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
                const SizedBox(width: kSpacing),
                Icon(
                  PlatformIcons(context).edit,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          onPressed: () => SlidingBottomSheetBuilder(
            context: context,
            child: ReviewBottomSheetWidget(program: program),
            expand: true,
          ).showAsBottomSheet(),
        ),
      ],
    );
  }
}
