import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_user.dart';
import 'package:global_strongman/core/model/firebase_user_workout_complete.dart';
import 'package:global_strongman/core/providers/activity_interace_provider.dart';
import 'package:global_strongman/core/providers/badge_current_values.dart';
import 'package:global_strongman/widget_tree/activity_screen/model/activity_interface.dart';
import 'package:global_strongman/widget_tree/activity_screen/view/filtered_workout_screen/filtered_workout_screen.dart';
import 'package:global_strongman/widget_tree/badges_screen/main.dart';
import 'package:global_strongman/widget_tree/login_screen/view/main.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_badge.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_header.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_list.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profile_list_tile.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/progress_card.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/edit_profile_screen.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/secondary_screens/progress_gallery/progress_gallery.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    required this.firebaseUser,
    Key? key,
  }) : super(key: key);

  final FirebaseUser firebaseUser;

  String? get _user => FirebaseAuth.instance.currentUser?.email;

  Query<FirebaseUserWorkoutComplete> _getWorkouts() {
    return FirebaseUserWorkoutComplete()
        .getCollectionReference(user: _user!)
        .orderBy("created_on", descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        backgroundColor: kPrimaryColor,
        color: Colors.white,
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          context.read<BadgeCurrentValues>().runSetMetrics();
          context.read<ActivityInterfaceProvider>().createWorkoutInterface();
        },
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
              //#TODO add more fitness tiles

              // const SizedBox(
              //   height: kSpacing * 2,
              // ),
              // _buildCommunityProfileList(),
              const SizedBox(
                height: kSpacing * 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                child: SizedBox(
                  width: double.infinity,
                  child: PlatformElevatedButton(
                    cupertino: (_, __) => CupertinoElevatedButtonData(
                      originalStyle: true,
                      color: kSecondaryColor,
                    ),
                    material: (_, __) => MaterialElevatedButtonData(
                      style: ElevatedButton.styleFrom(primary: kSecondaryColor),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.flight_land,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: kSpacing,
                        ),
                        Text(
                          "Sign out",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: kSpacing * 4,
              ),
            ],
          ),
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
        //#TODO add more fitness tiles
        // ProfileListTile(
        //   title: "Fitness Programs",
        //   icon: const FaIcon(
        //     FontAwesomeIcons.award,
        //     color: Colors.blue,
        //     size: 30,
        //   ),
        //   onTap: () {},
        // ),
        // ProfileListTile(
        //   title: "Routines",
        //   icon: FaIcon(
        //     FontAwesomeIcons.dumbbell,
        //     color: Colors.purple.shade300,
        //     size: 30,
        //   ),
        //   onTap: () {},
        // ),
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
        //#TODO add a membership tile
        // ProfileListTile(
        //   title: "Membership",
        //   icon: FaIcon(
        //     FontAwesomeIcons.fire,
        //     color: Colors.orange.shade300,
        //     size: 30,
        //   ),
        //   onTap: () {},
        // ),
        // ProfileListTile(
        //   title: "Privacy",
        //   icon: Icon(
        //     PlatformIcons(context).eyeSlashSolid,
        //     color: Colors.red.shade400,
        //     size: 30,
        //   ),
        //   onTap: () {},
        // ),
      ],
    );
  }

  Row _buildProfileBadgeRow(BuildContext context) {
    final ActivityInterfaceProvider activityInterfaceProvider =
        context.watch<ActivityInterfaceProvider>();

    final ActivityInterface activityInterface = ActivityInterface(
      totalWorkouts: activityInterfaceProvider.totalWorkouts,
      activeDays: activityInterfaceProvider.activeDays,
      programsComplete: activityInterfaceProvider.programsComplete,
      trophiesEarned: activityInterfaceProvider.trophiesEarned,
      completedWorkouts: activityInterfaceProvider.completedWorkouts,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileBadge(
          icon: Icon(
            PlatformIcons(context).clockSolid,
            color: Colors.white,
          ),
          color: Colors.blue,
          title: "${context.watch<BadgeCurrentValues>().totalActiveDays}",
          subtitle: "Active Days",
          onPressed: null,
        ),
        ProfileBadge(
          icon: const FaIcon(
            FontAwesomeIcons.solidStar,
            color: Colors.white,
          ),
          color: Colors.yellow.shade700,
          title: "${context.watch<BadgeCurrentValues>().totalWorkoutsDone}",
          subtitle: "Workouts Done",
          onPressed: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (_) => FilteredWorkoutScreen(
                  title: "My Workouts",
                  query: _getWorkouts(),
                  key: GlobalKey(),
                ),
              ),
            );
          },
        ),
        ProfileBadge(
          icon: const Hero(
            tag: "profile_trophy",
            child: FaIcon(
              FontAwesomeIcons.trophy,
              color: Colors.white,
            ),
          ),
          color: Colors.red.shade400,
          title:
              "${context.watch<BadgeCurrentValues>().completedBadgeCount}/${context.watch<BadgeCurrentValues>().totalBadgeCount}",
          subtitle: "Badges Earned",
          onPressed: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (_) => const BadgesScreen(
                  heroId: 'profile_trophy',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
