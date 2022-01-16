import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_strongman/constants.dart';
import 'package:global_strongman/widget_tree/workout_vault/model/vault_item.dart';
import 'package:global_strongman/widget_tree/workout_vault/view/workout_vault_card.dart';

class WorkoutVaultScreen extends StatelessWidget {
  const WorkoutVaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: kSpacing * 2,
          left: kSpacing,
          right: kSpacing,
        ),
        child: ListView.builder(
          itemCount: vaultItems.length,
          itemBuilder: (BuildContext context, int index) => Column(
            children: [
              WorkoutVaultCard(
                title: vaultItems[index].title,
                subtitle: vaultItems[index].subtitle,
                image: vaultItems[index].image,
              ),
              const SizedBox(
                height: kSpacing * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
