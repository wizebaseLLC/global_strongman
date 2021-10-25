import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:image_picker/image_picker.dart';

class FormAvatar extends StatefulWidget {
  const FormAvatar({
    Key? key,
  }) : super(key: key);

  @override
  State<FormAvatar> createState() => _FormAvatarState();
}

class _FormAvatarState extends State<FormAvatar> {
  final ImagePicker _picker = ImagePicker();
  XFile? file;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 75,
          height: 75,
          child: CircleAvatar(
            child: file?.path == null
                ? Icon(
                    PlatformIcons(context).person,
                    size: 50,
                  )
                : null,
            backgroundImage: file?.path != null
                ? ResizeImage(
                    FileImage(
                      File(file!.path),
                    ),
                    width: 262,
                  )
                : null,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 28,
            decoration: const BoxDecoration(
              gradient: kSecondaryGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                PlatformIcons(context).edit,
                color: Colors.white,
                size: 14,
              ),
              onPressed: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image?.path != null) {
                  setState(() {
                    file = image;
                  });
                }
              },
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
