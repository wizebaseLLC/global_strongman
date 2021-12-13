import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
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
    return Column(
      children: [
        ReviewButton(program: program),
        FirestoreListView<FirebaseProgramRating>(
            query: _getReviews(),
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, snapshot) {
              var snapshotData = snapshot.data();

              return ReviewListTile(
                program: program,
                review: snapshotData,
                reviewId: snapshot.id,
              );
            }),
      ],
    );
  }
}
