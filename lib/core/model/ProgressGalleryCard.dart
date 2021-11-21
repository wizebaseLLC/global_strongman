import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressGalleryCard {
  ProgressGalleryCard({
    required this.date,
    required this.url,
    required this.file_name,
    this.weight,
    this.bust,
    this.bmi,
    this.waist,
    this.hip,
    this.bodyFat,
    this.description,
  });

  final String url;
  final String file_name;
  final String? weight;
  final String? bust;
  final String? bmi;
  final String? waist;
  final String? hip;
  final String? bodyFat;
  final DateTime date;
  final String? description;

  ProgressGalleryCard.fromJson(Map<String, Object?> json)
      : this(
          date: (json['date'] as Timestamp).toDate(),
          url: json['url'] as String,
          file_name: json['file_name'] as String,
          weight: json['weight'] as String,
          bust: json['bust'] as String?,
          waist: json['waist'] as String?,
          bmi: json['bmi'] as String?,
          hip: json['hip'] as String?,
          bodyFat: json['bodyFat'] as String?,
          description: json['description'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'date': date,
      'url': url,
      "file_name": file_name,
      'weight': weight,
      'bust': bust,
      'waist': waist,
      'bmi': bmi,
      'hip': hip,
      'bodyFat': bodyFat,
      'description': description,
    };
  }
}
