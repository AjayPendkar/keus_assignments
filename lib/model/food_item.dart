// lib/models/food_item.dart
class FoodItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final bool favorite;
  final String smallDescription;
  final String bigDescription;
  final Nutrition nutrition;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.favorite,
    required this.smallDescription,
    required this.bigDescription,
    required this.nutrition,
  });

  // Factory method to parse JSON into a FoodItem
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? '', // Provide a default value if null
      name: json['name'] ?? 'Unknown Name',
      category: json['category'] ?? 'Uncategorized',
      imageUrl: json['imageUrl'] ?? '', // Use an empty string if URL is missing
      price: (json['price'] ?? 0).toDouble(),
      favorite: json['favorite'] ?? false,
      smallDescription: json['smallDescription'] ?? '',
      bigDescription: json['bigDescription'] ?? '',
      nutrition: json['nutrition'] != null 
          ? Nutrition.fromJson(json['nutrition']) 
          : Nutrition.empty(),
    );
  }
}

// Nutrition model for storing nutrition details
class Nutrition {
  final int kcal;
  final int grams;
  final int proteins;
  final int fats;
  final int carbs;

  Nutrition({
    required this.kcal,
    required this.grams,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  // Factory method to parse JSON into a Nutrition object
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      kcal: json['kcal'] ?? 0,
      grams: json['grams'] ?? 0,
      proteins: json['proteins'] ?? 0,
      fats: json['fats'] ?? 0,
      carbs: json['carbs'] ?? 0,
    );
  }

  // Provide a default empty Nutrition object if data is missing
  factory Nutrition.empty() {
    return Nutrition(
      kcal: 0,
      grams: 0,
      proteins: 0,
      fats: 0,
      carbs: 0,
    );
  }
}
