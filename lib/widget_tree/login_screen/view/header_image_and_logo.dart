import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderImageAndLogo extends StatelessWidget {
  const HeaderImageAndLogo({
    required this.image,
    Key? key,
  }) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(
                    0.9,
                  ),
                  BlendMode.dstATop,
                ),
                image: AssetImage(image),
              ),
            ),
          ),
          Positioned(
            bottom: -75.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircleAvatar(
                backgroundColor: Platform.isIOS ? CupertinoTheme.of(context).scaffoldBackgroundColor : Theme.of(context).scaffoldBackgroundColor,
                radius: 79.5,
                child: Hero(
                  tag: "LoginLogo",
                  child: Image.asset(
                    "assets/images/global_strongman_logo.png",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
