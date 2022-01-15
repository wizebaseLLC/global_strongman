import 'package:flutter/material.dart';
import 'package:global_strongman/core/providers/user_provider.dart';
import 'package:global_strongman/widget_tree/profile_screen/view/profileBody.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const bool usesAppbar = false;

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = context.watch<UserProvider>();

    if (_user.firebaseUser != null) {
      return ProfileBody(firebaseUser: _user.firebaseUser!);
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
