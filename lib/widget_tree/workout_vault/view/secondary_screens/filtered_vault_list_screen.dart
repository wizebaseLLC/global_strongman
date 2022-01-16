import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';
import 'package:global_strongman/widget_tree/workout_vault/view/secondary_screens/filtered_vault_app_bar.dart';

class FilteredVaultListScreen extends StatelessWidget {
  const FilteredVaultListScreen({
    required this.image,
    required this.heroId,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String image;
  final String heroId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              FilteredVaultAppBar(
                title: title,
                heroId: heroId,
                image: image,
              ),
              VaultGrid(
                query: FirebaseProgramWorkouts()
                    .getWorkoutCatalogCollectionReference()
                    .orderBy("name"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VaultGrid extends StatelessWidget {
  const VaultGrid({
    Key? key,
    required this.query,
  }) : super(key: key);

  final Query<FirebaseProgramWorkouts> query;
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

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        workout.thumbnail!,
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Text(
                    workout.name!,
                    style: platformThemeData(
                      context,
                      material: (data) => data.textTheme.subtitle1?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                      cupertino: (data) =>
                          data.textTheme.navTitleTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
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
