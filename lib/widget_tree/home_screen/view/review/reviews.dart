import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program.dart';
import 'package:global_strongman/core/model/firebase_program_reviews.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_button.dart';
import 'package:global_strongman/widget_tree/home_screen/view/review/review_list_tile.dart';

class Reviews extends StatelessWidget {
  const Reviews({required this.program, Key? key}) : super(key: key);
  final QueryDocumentSnapshot<FirebaseProgram> program;

  Stream<QuerySnapshot<FirebaseProgramRating>> _getReviews() {
    return FirebaseProgramRating()
        .getCollectionReference(
          program: program.id,
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<FirebaseProgramRating>>(
        stream: _getReviews(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Error",
              style: TextStyle(color: Colors.red),
            );
          }
          if (snapshot.hasData) {
            var snapshotData = snapshot.data?.docs;

            snapshotData?.sort(
                (a, b) => b.data().created_on!.compareTo(a.data().created_on!));
            return snapshot.data?.docs != null && snapshot.data!.docs.isNotEmpty
                ? Column(
                    children: [
                      ReviewButton(program: program),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshotData?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return ReviewListTile(
                            program: program,
                            review: snapshotData?[index]?.data(),
                            reviewId: snapshotData?[index]?.id,
                          );
                        },
                      ),
                      const SizedBox(
                        height: kSpacing * 6,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ReviewButton(program: program),
                      ReviewListTile(
                        review: null,
                        program: program,
                        reviewId: null,
                      ),
                    ],
                  );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        });
  }
}
