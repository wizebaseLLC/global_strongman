import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/controller/firebase_user.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_badge.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_header.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_list.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_list_tile.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/progress_card.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child:
                  // The avatar, name and level.
                  ProfileHeader(firebaseUser: firebaseUser),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileBadge(
                  icon: Icon(
                    PlatformIcons(context).clockSolid,
                    color: Colors.white,
                  ),
                  color: Colors.blue,
                  title: "10",
                  subtitle: "Total Time (h)",
                ),
                ProfileBadge(
                  icon: const Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  color: Colors.yellow.shade700,
                  title: "3/28",
                  subtitle: "Goals Achieved",
                ),
                ProfileBadge(
                  icon: const FaIcon(
                    FontAwesomeIcons.award,
                    color: Colors.white,
                  ),
                  color: Colors.red.shade400,
                  title: "5/15",
                  subtitle: "Badges Collected",
                ),
              ],
            ),
            const SizedBox(
              height: kSpacing * 3,
            ),
            const ProgressCard(),
            const SizedBox(
              height: kSpacing * 3,
            ),
            ProfileList(
              header: "Account",
              listTiles: [
                ProfileListTile(
                  title: "Edit Profile",
                  icon: Icon(
                    PlatformIcons(context).personSolid,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onTap: () {},
                ),
                ProfileListTile(
                  title: "Privacy",
                  icon: Icon(
                    PlatformIcons(context).eyeSlashSolid,
                    color: Colors.red.shade400,
                    size: 30,
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(
              height: kSpacing * 2,
            ),
            ProfileList(
              header: "Fitness",
              listTiles: [
                ProfileListTile(
                  title: "Progress Gallery",
                  icon: Icon(
                    PlatformIcons(context).photoLibrarySolid,
                    color: Colors.yellow.shade700,
                    size: 30,
                  ),
                  onTap: () {},
                ),
                ProfileListTile(
                  title: "Fitness Programs",
                  icon: const FaIcon(
                    FontAwesomeIcons.award,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onTap: () {},
                ),
                ProfileListTile(
                  title: "Routines",
                  icon: FaIcon(
                    FontAwesomeIcons.dumbbell,
                    color: Colors.purple.shade300,
                    size: 30,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
