import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/constants.dart';

class CategoryStackContainer extends StatelessWidget {
  const CategoryStackContainer({
    required this.child,
    required this.count,
    Key? key,
  }) : super(key: key);

  final int count;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              color: kPrimaryColor,
              height: 25,
              width: 25,
              child: Center(
                child: Text(
                  "$count",
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.caption?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
