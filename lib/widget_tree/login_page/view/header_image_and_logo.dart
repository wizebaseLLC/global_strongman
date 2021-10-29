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
              child: Image.asset(
                "assets/images/global_strongman_logo.png",
                width: 159.0,
                height: 159.0,
                cacheHeight: 159,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
