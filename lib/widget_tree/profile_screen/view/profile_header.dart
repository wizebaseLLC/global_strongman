import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/showPlatformActionSheet.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/profile_image_view.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.firebaseUser,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  Future<void> _uploadImage({
    required BuildContext context,
    required ImageSource imageSource,
    required String? email,
  }) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: imageSource,
      );
      if (image?.path != null) {
        if (email != null) {
          await FirebaseUser(email: email).addUserAvatarToStorage(
              context: context, file: File(image!.path));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _cupertinoActionSheet(
    BuildContext context,
    String? email,
  ) {
    showPlatformActionSheet(
      context: context,
      actionSheetData: PlatformActionSheet(
        title: "Add Progress Photo",
        model: [
          ActionSheetModel(
            title: "Library",
            textStyle: TextStyle(
              color: Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue,
            ),
            onTap: () => _uploadImage(
              context: context,
              imageSource: ImageSource.gallery,
              email: email,
            ),
            iconMaterial: const Icon(
              Icons.add_photo_alternate_rounded,
            ),
          ),
          ActionSheetModel(
            title: "Camera",
            textStyle: TextStyle(
              color: Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue,
            ),
            onTap: () => _uploadImage(
              imageSource: ImageSource.camera,
              context: context,
              email: email,
            ),
            iconMaterial: const Icon(
              Icons.add_a_photo_rounded,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade900,
                ),
                height: 100,
                width: 100,
                child: firebaseUser.avatar != null
                    ? ClipOval(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            platformPageRoute(
                              context: context,
                              iosTitle: "Profile Image",
                              fullscreenDialog: true,
                              builder: (context) => ProfileImageView(
                                url: firebaseUser.avatar!,
                                heroTag: "profile_gallery_avatar",
                              ),
                            ),
                          ),
                          child: Hero(
                            tag: "profile_gallery_avatar",
                            child: CachedNetworkImage(
                              imageUrl: firebaseUser.avatar!,
                              memCacheWidth: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Icon(
                        PlatformIcons(context).person,
                        size: 60,
                        color: Colors.white,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withOpacity(.8),
                    ),
                    child: PlatformIconButton(
                      onPressed: () =>
                          _cupertinoActionSheet(context, _user.authUser?.email),
                      padding: EdgeInsets.zero,
                      materialIcon: const Icon(
                        Icons.photo_camera,
                        size: 20,
                      ),
                      cupertinoIcon: const Icon(
                        CupertinoIcons.photo_camera_solid,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: kSpacing,
        ),
        Text(
          '${firebaseUser.first_name} ${firebaseUser.last_name}',
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.headline5,
            cupertino: (data) =>
                data.textTheme.navTitleTextStyle.copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(
          height: kSpacing,
        ),
        Text(
          '${firebaseUser.experience}',
          style: platformThemeData(
            context,
            material: (data) =>
                data.textTheme.subtitle1?.copyWith(color: Colors.grey),
            cupertino: (data) => data.textTheme.navTitleTextStyle
                .copyWith(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
