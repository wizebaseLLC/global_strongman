import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  Future<DocumentSnapshot<FirebaseUser>?> _getUser(
    String? user,
  ) async {
    try {
      if (user != null) {
        return FirebaseUser(email: user).getDocumentReference().get();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<FirebaseUser>?>(
        future: _getUser(review?.uid),
        builder: (context, snapshot) {
          final user = snapshot.data?.data();
          return SizedBox(
            height: 150,
            child: SingleChildScrollView(
              child: Column(
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
              ),
            ),
          );
        });
  }
}
