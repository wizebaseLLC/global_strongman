import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';

class FormAvatar extends StatelessWidget {
  const FormAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          width: 75,
          height: 75,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc5NjIyODM0ODM2ODc0Mzc3/dwayne-the-rock-johnson-gettyimages-1061959920.jpg"),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 28,
            decoration: const BoxDecoration(
              gradient: kPrimaryGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 14,
              ),
              onPressed: () {
                print("pressed");
              },
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
