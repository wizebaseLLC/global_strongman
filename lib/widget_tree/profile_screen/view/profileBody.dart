import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_badge.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_header.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_list.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_list_tile.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/progress_card.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/edit_profile_screen.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/progress_gallery.dart';

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
            _buildProfileBadgeRow(context),
            const SizedBox(
              height: kSpacing * 3,
            ),
            const ProgressCard(),
            const SizedBox(
              height: kSpacing * 3,
            ),
            _buildAccountProfileList(context),
            const SizedBox(
              height: kSpacing * 2,
            ),
            _buildFitnessProfileList(context),
            const SizedBox(
              height: kSpacing * 2,
            ),
            _buildCommunityProfileList(),
            const SizedBox(
              height: kSpacing * 4,
            ),
          ],
        ),
      ),
    );
  }

  ProfileList _buildCommunityProfileList() {
    return ProfileList(
      header: "Community",
      listTiles: [
        ProfileListTile(
          title: "Posts",
          icon: FaIcon(
            FontAwesomeIcons.users,
            color: Colors.indigo.shade400,
            size: 30,
          ),
          onTap: () {},
        ),
        ProfileListTile(
          title: "Likes",
          icon: const FaIcon(
            FontAwesomeIcons.thumbsUp,
            color: Colors.blue,
            size: 30,
          ),
          onTap: () {},
        ),
        ProfileListTile(
          title: "Blocked",
          icon: FaIcon(
            FontAwesomeIcons.userLock,
            color: Colors.amber.shade400,
            size: 30,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  ProfileList _buildFitnessProfileList(BuildContext context) {
    return ProfileList(
      header: "Fitness",
      listTiles: [
        ProfileListTile(
          title: "My Progress Gallery",
          icon: Icon(
            PlatformIcons(context).photoLibrarySolid,
            color: Colors.green.shade300,
            size: 30,
          ),
          onTap: () => Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (context) => ProgressGallery(
                firebaseUser: firebaseUser,
              ),
            ),
          ),
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
    );
  }

  ProfileList _buildAccountProfileList(BuildContext context) {
    return ProfileList(
      header: "Account",
      listTiles: [
        ProfileListTile(
          title: "Edit Profile",
          icon: Icon(
            PlatformIcons(context).personSolid,
            color: Colors.blue,
            size: 30,
          ),
          onTap: () => Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (context) => EditProfileScreen(
                firebaseUser: firebaseUser,
              ),
            ),
          ),
        ),
        ProfileListTile(
          title: "Membership",
          icon: FaIcon(
            FontAwesomeIcons.fire,
            color: Colors.orange.shade300,
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
    );
  }

  Row _buildProfileBadgeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileBadge(
          icon: Icon(
            PlatformIcons(context).clockSolid,
            color: Colors.white,
          ),
          color: Colors.blue,
          title: "10",
          subtitle: "Active Days",
        ),
        ProfileBadge(
          icon: const FaIcon(
            FontAwesomeIcons.solidStar,
            color: Colors.white,
          ),
          color: Colors.yellow.shade700,
          title: "28",
          subtitle: "Workouts Done",
        ),
        ProfileBadge(
          icon: const FaIcon(
            FontAwesomeIcons.trophy,
            color: Colors.white,
          ),
          color: Colors.red.shade400,
          title: "5/15",
          subtitle: "Trophies Earned",
        ),
      ],
    );
  }
}
