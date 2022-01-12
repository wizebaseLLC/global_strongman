import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/view/platform_scaffold_ios_sliver_title.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/gallery_stream.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/public_switch.dart';

class ProgressGallery extends StatelessWidget {
  const ProgressGallery({
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PlatformScaffoldIosSliverTitle(
        title: "My Progress",
        body: GalleryStream(
          firebaseUser: firebaseUser,
        ),
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
      ),
    );
  }
}
