class VaultItem {
  final String title;
  final String subtitle;
  final String image;

  VaultItem({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

final List<VaultItem> vaultItems = [
  VaultItem(
    title: "Browse",
    subtitle: "Find workouts that work for you.",
    image: "fitness_background_1.png",
  ),
  VaultItem(
    title: "Training Programs",
    subtitle: "Premade routines constructed by Hans Pirman himself.",
    image: "fitness_background_2.jpg",
  ),
  VaultItem(
    title: "Strength training",
    subtitle: "Improve muscular health and longevity.",
    image: "fitness_background_6.jpg",
  ),
  VaultItem(
    title: "Strongman",
    subtitle: "Are you a vampire or a viking?",
    image: "fitness_background_3.jpg",
  ),
  VaultItem(
    title: "Cardio",
    subtitle: "Strengthen your heart and mind.",
    image: "fitness_background_4.jpg",
  ),
  VaultItem(
    title: "Rehab",
    subtitle: "Active recovery and injury prevention",
    image: "fitness_background_5.jpg",
  ),
];
