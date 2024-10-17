// lib/controllers/food_controller.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keus/model/food_item.dart';

class FoodController extends GetxController {
  List<FoodItem> allFoodItems = []; // Original list of all items
  List<FoodItem> foodItems = []; // Filtered list to display
  String selectedCategory = "All"; // Track the selected category

  @override
  void onInit() {
    super.onInit();
    loadFoodItems();
  }

  Future<void> loadFoodItems() async {
    final String response = await rootBundle.loadString('assets/food_items.json');
    final List<dynamic> data = json.decode(response);
    allFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
    foodItems = List.from(allFoodItems); // Set initial display to all items
    update(); // Notify listeners for the initial load
  }

  // Update selected category and filter items
  void selectCategory(String category) {
    selectedCategory = category;
    filterByCategory();
  }

  // Filter items by the current selected category
  void filterByCategory() {
    if (selectedCategory == "All") {
      foodItems = List.from(allFoodItems); // Show all items
    } else {
      foodItems = allFoodItems.where((item) => item.category == selectedCategory).toList();
    }
    update(); // Notify listeners to update the UI
  }
}
