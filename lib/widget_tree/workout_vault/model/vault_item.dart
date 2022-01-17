import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_strongman/core/model/firebase_program_workouts.dart';

class VaultItem {
  final String title;
  final String subtitle;
  final String image;
  final Query<FirebaseProgramWorkouts> query;

  VaultItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.query,
  });
}

final List<VaultItem> vaultItems = [
  VaultItem(
    title: "Browse",
    subtitle: "Find workouts that work for you.",
    image: "fitness_background_1.png",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .orderBy("name"),
  ),
  VaultItem(
    title: "Strength",
    subtitle: "Improve muscular health and longevity.",
    image: "fitness_background_6.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "strength")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Strongman",
    subtitle: "Are you a vampire or a viking?",
    image: "fitness_background_3.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "strongman")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Cardio",
    subtitle: "Strengthen your heart and mind.",
    image: "fitness_background_4.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "cardio")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Rehab",
    subtitle: "Active recovery and injury prevention",
    image: "fitness_background_5.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "rehab")
        .orderBy("name"),
  ),
];
