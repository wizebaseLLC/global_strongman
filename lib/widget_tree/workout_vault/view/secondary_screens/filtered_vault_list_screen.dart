import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/workout_vault/view/secondary_screens/filtered_vault_app_bar.dart';
import 'package:global_strongman/widget_tree/workout_vault/view/secondary_screens/vault_grid.dart';

class FilteredVaultListScreen extends StatelessWidget {
  const FilteredVaultListScreen({
    required this.image,
    required this.heroId,
    required this.title,
    required this.query,
    Key? key,
  }) : super(key: key);

  final String image;
  final String heroId;
  final String title;
  final Query<FirebaseProgramWorkouts> query;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            FilteredVaultAppBar(
              title: title,
              heroId: heroId,
              image: image,
            ),
            VaultGrid(
              query: query,
              title: title,
            )
          ],
        ),
      ),
    );
  }
}
