import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/slidingBottomSheetBuilder.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_reviews.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_bottom_sheet_widget.dart';

class ReviewTileData extends StatelessWidget {
  const ReviewTileData({
    Key? key,
    required this.user,
    required this.review,
    required this.reviewId,
    required this.program,
  }) : super(key: key);

  final FirebaseUser? user;
  final FirebaseProgramRating review;
  final String? reviewId;
  final QueryDocumentSnapshot<FirebaseProgram> program;
  String? get myUserId => FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: user?.avatar != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: user!.avatar!,
                fit: BoxFit.cover,
                width: 45,
                height: 45.0,
                memCacheWidth: 135,
              ),
            )
          : null,
      title: Text(
        '${user?.first_name} ${user?.last_name}',
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.subtitle1,
          cupertino: (data) => data.textTheme.textStyle,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: kSpacing / 2,
          ),
          Text(
            review.created_on!.toUtc().toString().substring(0, 10),
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText2?.copyWith(
                color: Colors.white70,
                fontSize: 10,
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                fontSize: 14,
                color: CupertinoColors.systemGrey3,
              ),
            ),
          ),
          const SizedBox(
            height: kSpacing / 2,
          ),
          Text(
            review.review!,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText2?.copyWith(
                fontSize: 12,
              ),
              cupertino: (data) => data.textTheme.textStyle,
            ),
          ),
          const SizedBox(
            height: kSpacing / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBarIndicator(
                rating: review.rating!.toDouble(),
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.yellowAccent.shade700,
                ),
                itemCount: 5,
                itemSize: 12.0,
              ),
              if (myUserId! == review.uid)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlatformIconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => SlidingBottomSheetBuilder(
                        context: context,
                        child: ReviewBottomSheetWidget(
                          program: program,
                          currentReview: review.review,
                          currentRating: review.rating,
                        ),
                      ).showAsBottomSheet(),
                      icon: Icon(
                        PlatformIcons(context).edit,
                        size: 18,
                        color: Platform.isIOS
                            ? CupertinoColors.systemGrey3
                            : Colors.white,
                      ),
                    ),
                    PlatformIconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showPlatformDialog(
                          context: context,
                          builder: (_) => PlatformAlertDialog(
                            title: const Text('Delete Review'),
                            content: const Text(
                                'Are you sure you would like to delete this review?'),
                            actions: <Widget>[
                              PlatformDialogAction(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              PlatformDialogAction(
                                child: const Text(
                                  "Delete",
                                ),
                                onPressed: () {
                                  review.removeRating(
                                      docId: reviewId!, program: program.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(
                        PlatformIcons(context).delete,
                        size: 18,
                        color: Platform.isIOS
                            ? CupertinoColors.systemGrey3
                            : Colors.white,
                      ),
                    )
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }
}

// style: TextStyle(
// color: Platform.isIOS
// ? CupertinoColors.systemBlue
//     : Colors.blueAccent,
// ),
