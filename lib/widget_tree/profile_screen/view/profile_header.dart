import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.firebaseUser,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  Future<void> _uploadImageFromGallery({
    required BuildContext context,
    required ImageSource imageSource,
  }) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: imageSource,
      );
      if (image?.path != null) {
        String? email = FirebaseAuth.instance.currentUser?.email;
        if (email != null) {
          await FirebaseUser(email: email).addUserAvatarToStorage(
              context: context, file: File(image!.path));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _cupertinoActionSheet(BuildContext context) {
    showPlatformModalSheet<void>(
      context: context,
      builder: (BuildContext context) => PlatformWidget(
        material: (_, __) => _buildMaterialBottomSheet(context),
        cupertino: (_, __) => _buildCupertinoActionSheet(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Image.network(
                          firebaseUser.avatar!,
                          cacheHeight: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            PlatformIcons(context).error,
                            size: 60,
                            color: Colors.white,
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
                      onPressed: () => _cupertinoActionSheet(context),
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

  Widget _buildMaterialBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Update Profile Image",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_photo_alternate_rounded),
          title: const Text(
            'Library',
            style: TextStyle(
              color: Colors.lightBlueAccent,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            _uploadImageFromGallery(
                context: context, imageSource: ImageSource.gallery);
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_a_photo_rounded),
          title: const Text(
            'Camera',
            style: TextStyle(
              color: Colors.lightBlueAccent,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            _uploadImageFromGallery(
                imageSource: ImageSource.camera, context: context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.stop_rounded),
          title: Text(
            'Cancel',
            style: TextStyle(color: Colors.red.shade400),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildCupertinoActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('Profile Image'),
      message: const Text('Upload a new Profile image'),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          child: const Text(
            'Library',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onPressed: () {
            _uploadImageFromGallery(
                context: context, imageSource: ImageSource.gallery);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            'Camera',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onPressed: () {
            _uploadImageFromGallery(
                context: context, imageSource: ImageSource.camera);
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          isDefaultAction: true,
          child: const Text(
            'Cancel',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
