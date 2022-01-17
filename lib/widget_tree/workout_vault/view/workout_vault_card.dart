import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/workout_vault/view/secondary_screens/filtered_vault_list_screen.dart';
import '../../../constants.dart';

class WorkoutVaultCard extends StatelessWidget {
  const WorkoutVaultCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.query,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String image;
  final Query<FirebaseProgramWorkouts> query;

  void _onPress(BuildContext context) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => FilteredVaultListScreen(
          heroId: "assets/images/$image",
          image: "assets/images/$image",
          title: title,
          query: query,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 3;
    if (_height > 350) {
      _height = 350;
    }

    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => CupertinoButton(
        child: Hero(
          tag: "assets/images/$image",
          child: Container(
            width: double.infinity,
            height: _height,
            decoration: _buildDecoration(),
            child: child!,
          ),
        ),
        onPressed: () => _onPress(context),
        padding: EdgeInsets.zero,
      ),
      material: (_, child, __) => Hero(
        tag: "assets/images/$image",
        child: Material(
          child: Ink(
            width: double.infinity,
            height: _height,
            decoration: _buildDecoration(),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: kPrimaryColor.withOpacity(.5),
              child: child,
              onTap: () => _onPress(context),
            ),
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(kSpacing * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.subtitle1?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  cupertino: (data) =>
                      data.textTheme.navTitleTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: kSpacing / 2,
              ),
              Text(
                subtitle,
                style: platformThemeData(
                  context,
                  material: (data) => data.textTheme.bodyText1?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                  cupertino: (data) => data.textTheme.textStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemGrey2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(
        image: AssetImage(
          "assets/images/$image",
        ),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.4),
          BlendMode.darken,
        ),
      ),
    );
  }
}
