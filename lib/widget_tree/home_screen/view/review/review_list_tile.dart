import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_reviews.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_tile_data.dart';

class ReviewListTile extends StatelessWidget {
  const ReviewListTile({
    required this.review,
    required this.program,
    required this.reviewId,
    Key? key,
  }) : super(key: key);

  final FirebaseProgramRating? review;
  final QueryDocumentSnapshot<FirebaseProgram> program;
  final String? reviewId;

  Future<DocumentSnapshot<FirebaseUser?>?> _getUser() async {
    if (review != null) {
      return FirebaseUser(email: review!.uid!).getDocumentReference().get();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<FirebaseUser?>?>(
        future: _getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Error",
              style: TextStyle(color: Colors.red),
            );
          }
          if (review == null && !snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: kSpacing * 4,
                ),
                Text(
                  "Be the first to review this program!",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.subtitle1?.copyWith(),
                    cupertino: (data) =>
                        data.textTheme.navTitleTextStyle.copyWith(fontSize: 20),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasData) {
            final FirebaseUser? user = snapshot.data?.data();
            if (user == null) {
              return Container();
            }
            return Column(
              children: [
                if (review != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: kSpacing),
                    child: ReviewTileData(
                      user: user,
                      review: review!,
                      program: program,
                      reviewId: reviewId,
                    ),
                  ),
              ],
            );
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        });
  }
}
