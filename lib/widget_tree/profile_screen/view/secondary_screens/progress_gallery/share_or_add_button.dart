import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/controller/showPlatformActionSheet.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/login_screen/controller/sign_in_controller.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/new_progress_photo_screen.dart';
import 'package:image_picker/image_picker.dart';

class ShareOrAddButton extends StatelessWidget {
  const ShareOrAddButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.firebaseUser,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText1?.copyWith(
              color: Colors.grey,
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
        PlatformIconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            color: Colors.yellow.shade600,
            size: 25,
          ),
          onPressed: () => showPlatformActionSheet(
            context: context,
            actionSheetData: PlatformActionSheet(
              title: "Add Progress Photo",
              model: [
                ActionSheetModel(
                  title: "Library",
                  textStyle: const TextStyle(color: Colors.lightBlueAccent),
                  onTap: () => _uploadImage(
                    imageSource: ImageSource.gallery,
                    context: context,
                  ),
                  iconMaterial: const Icon(
                    Icons.add_photo_alternate_rounded,
                  ),
                ),
                ActionSheetModel(
                  title: "Camera",
                  textStyle: const TextStyle(color: Colors.lightBlueAccent),
                  onTap: () => _uploadImage(
                    imageSource: ImageSource.camera,
                    context: context,
                  ),
                  iconMaterial: const Icon(
                    Icons.add_a_photo_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _uploadImage({
    required BuildContext context,
    required ImageSource imageSource,
  }) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: imageSource,
        maxWidth: 1200,
      );
      if (image?.path != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProgressPhotoScreen(
              file: File(image!.path),
              firebaseUser: firebaseUser,
            ),
          ),
        );
      }
    } catch (e) {
      SignInController().showDialog(context, e.toString());
    }
  }
}
