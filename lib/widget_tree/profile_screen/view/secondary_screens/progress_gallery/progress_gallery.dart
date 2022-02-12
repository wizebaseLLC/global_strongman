import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/ProgressGalleryCard.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/view/platform_sliver_scaffold_ios_title_appbar.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/gallery_stream.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/public_switch.dart';

class ProgressGallery extends StatelessWidget {
  const ProgressGallery({
    required this.firebaseUser,
    this.previousPageTitle,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;
  final String? previousPageTitle;

  Query<ProgressGalleryCard> _firebaseUserProgressGalleryStream() {
    final User authenticatedUser = FirebaseUser.getSignedInUserFromFireStore()!;
    return FirebaseUser(email: authenticatedUser.email!)
        .getProgressGalleryCollectionReference()
        .orderBy('date', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<ProgressGalleryCard>(
      query: _firebaseUserProgressGalleryStream(),
      builder: (context, snapshot, _) {
        final List<QueryDocumentSnapshot<ProgressGalleryCard>>?
            streamedGallery = snapshot.docs;

        return SafeArea(
          top: false,
          child: PlatformSliverScaffold(
            title: "My Progress",
            previousPageTitle: previousPageTitle ?? "My Profile",
            trailingActions: [
              Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    "Public",
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.caption,
                      cupertino: (data) => data.textTheme.textStyle.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: PublicSwitch(firebaseUser: firebaseUser),
              ),
            ],
            sliverChildren: [
              GalleryStream(
                firebaseUser: firebaseUser,
                snapshot: snapshot,
              ),
              streamedGallery != null && streamedGallery.isNotEmpty
                  ? GallerySliverList(
                      firebaseUser: firebaseUser,
                      streamedGallery: streamedGallery,
                      snapshot: snapshot,
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Material(
                            color: platformThemeData(
                              context,
                              material: (data) => data.scaffoldBackgroundColor,
                              cupertino: (data) => data.scaffoldBackgroundColor,
                            ),
                            child: Column(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: kSpacing * 4),
                                  child: Text(
                                    "Press Add to upload your first progress photo!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
