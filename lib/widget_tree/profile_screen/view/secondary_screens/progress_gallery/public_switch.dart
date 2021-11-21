import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';

class PublicSwitch extends StatefulWidget {
  const PublicSwitch({
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  @override
  State<PublicSwitch> createState() => _PublicSwitchState();
}

class _PublicSwitchState extends State<PublicSwitch> {
  late bool isActive;

  void _updatePublicStatus(bool value) {
    widget.firebaseUser
        .getDocumentReference()
        .update({"is_gallery_public": value});
  }

  @override
  void initState() {
    isActive = widget.firebaseUser.is_gallery_public ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isActive,
      onChanged: (value) {
        setState(() {
          isActive = value;
        });
        _updatePublicStatus(value);
        if (value == true) {
          showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: const Text('Gallery is now Public!'),
              content: Padding(
                padding: EdgeInsets.all(Platform.isIOS ? kSpacing : 0),
                child: const Text(
                  'Anyone can view the images in your progress gallery.',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText("Ok"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
