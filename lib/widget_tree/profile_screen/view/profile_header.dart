import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.firebaseUser,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                backgroundImage: firebaseUser.avatar != null ? NetworkImage(firebaseUser.avatar!) : null,
                child: firebaseUser.avatar != null
                    ? null
                    : Icon(
                        PlatformIcons(context).person,
                        size: 50,
                      ),
                radius: 50,
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
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      materialIcon: const Icon(Icons.photo_camera,
                        size: 20,),
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
            cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(
          height: kSpacing,
        ),
        Text(
          '${firebaseUser.experience}',
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.subtitle1?.copyWith(color: Colors.grey),
            cupertino: (data) => data.textTheme.navTitleTextStyle.copyWith(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
