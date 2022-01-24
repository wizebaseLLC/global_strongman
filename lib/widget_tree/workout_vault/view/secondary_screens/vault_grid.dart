import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/workout_vault/view/secondary_screens/vault_grid_item.dart';

class VaultGrid extends StatelessWidget {
  const VaultGrid({
    Key? key,
    required this.query,
    required this.title,
  }) : super(key: key);

  final Query<FirebaseProgramWorkouts> query;
  final String title;
  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<FirebaseProgramWorkouts>(
      query: query,
      builder: (context, snapshot, _) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                snapshot.fetchMore();
              }

              if (snapshot.hasData) {
                final FirebaseProgramWorkouts workout =
                    snapshot.docs[index].data();

                return VaultGridItem(
                  workout: workout,
                  workoutId: snapshot.docs[index].id,
                );
              }

              return Container(
                alignment: Alignment.center,
                color: platformThemeData(
                  context,
                  material: (data) => data.cardColor,
                  cupertino: (data) => data.barBackgroundColor,
                ),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
            childCount: snapshot.docs.length,
          ),
        );
      },
    );
  }
}
