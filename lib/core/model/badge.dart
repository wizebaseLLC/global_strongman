class Badge {
  Badge({
    required this.title,
    required this.value,
    required this.badgeValueType,
    required this.badgeImage,
    this.currentValue = 0,
    this.meetsCriteria = false,
  });

  final String title;
  final int value;
  final BadgeValueType badgeValueType;
  final String badgeImage;
  int currentValue;
  bool meetsCriteria;
}

enum BadgeValueType {
  /// Each time the user completes a workout, the value will increment.
  /// The badge value will have to reach an incremented value.  For example, reach 50 workouts.
  increment,

  /// If a user submits a workout whose lbs surpass the desired amount.
  surpass
}
