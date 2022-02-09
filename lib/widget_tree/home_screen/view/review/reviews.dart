import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_reviews.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_list_tile.dart';

class Reviews extends StatelessWidget {
  const Reviews({required this.program, Key? key}) : super(key: key);
  final QueryDocumentSnapshot<FirebaseProgram> program;

  Query<FirebaseProgramRating> _getReviews() {
    return FirebaseProgramRating()
        .getCollectionReference(
          program: program.id,
        )
        .orderBy(
          "created_on",
          descending: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<FirebaseProgramRating>(
      query: _getReviews(),
      // padding: EdgeInsets.zero,
      // physics: const ScrollPhysics(),
      builder: (context, snapshot, _) {
        final List<QueryDocumentSnapshot<FirebaseProgramRating>> docs =
            snapshot.docs;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }
            final FirebaseProgramRating snapshotData = docs[index].data();

            return ReviewListTile(
              program: program,
              review: snapshotData,
              reviewId: docs[index].id,
            );
          }, childCount: docs.length),
        );
      },
    );
  }
}
// padding: const EdgeInsets.symmetric(horizontal: kSpacing * 2),