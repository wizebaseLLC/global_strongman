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
  VaultItem(
    title: "Compound",
    subtitle: "Train multiple muscles at once",
    image: "compound.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "compound")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Isolation",
    subtitle: "Give your specific muscle groups some love",
    image: "isolation.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "isolation")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Arms",
    subtitle: "Experience a sick arm pump",
    image: "bicep_curls.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "arms")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Legs",
    subtitle: "Never skip leg day",
    image: "fitness_background_2.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "legs")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Back",
    subtitle: "Earn your wings with these lat workouts",
    image: "pullups.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "back")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Shoulders",
    subtitle: "Activate your delts with these workouts",
    image: "barbell_press.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "shoulders")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Chest",
    subtitle: "Fill out your shirts with these chest workouts",
    image: "bench_press.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "chest")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Traps",
    subtitle: "Get Yoked with these trap workouts",
    image: "traps.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "traps")
        .orderBy("name"),
  ),
  VaultItem(
    title: "Core",
    subtitle: "Washboard abs are built here",
    image: "abs.jpg",
    query: FirebaseProgramWorkouts()
        .getWorkoutCatalogCollectionReference()
        .where("categories", arrayContains: "core")
        .orderBy("name"),
  ),
];
