import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_reviews.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_button.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_list_tile.dart';

class Reviews extends StatelessWidget {
  const Reviews({required this.program, Key? key}) : super(key: key);
  final QueryDocumentSnapshot<FirebaseProgram> program;

  Query<FirebaseProgramRating> _getReviews() {
    return FirebaseProgramRating()
        .getCollectionReference(
          program: program.id,
        )
        .orderBy("created_on", descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing * 2),
      child: Column(
        children: [
          ReviewButton(program: program),
          SizedBox(
            height: 800,
            child: FirestoreListView<FirebaseProgramRating>(
              query: _getReviews(),
              padding: EdgeInsets.zero,
              physics: const ScrollPhysics(),
              itemBuilder: (context, snapshot) {
                final FirebaseProgramRating snapshotData = snapshot.data();

                return ReviewListTile(
                  program: program,
                  review: snapshotData,
                  reviewId: snapshot.id,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
