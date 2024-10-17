// lib/views/home_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:keus/controller/cart_controller.dart';
import 'package:keus/controller/food_controller.dart';
import 'package:keus/view/cart_bottom_sheet.dart';
import 'package:keus/view/food_details_bottom_sheet.dart';
import 'widgets/food_card.dart';

class HomeScreen extends StatelessWidget {
  final FoodController foodController = Get.put(FoodController());
  final CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "100a Ealing Rd",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Icon(Icons.circle, color: Colors.black, size: 5),
            Text(
              " 24 mins",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          GetBuilder<CartController>(
            builder: (controller) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      showCartBottomSheet(context, cartController);
                    },
                  ),
                  if (controller.totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${controller.totalItems}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Hits of the week",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // Slider Section
            _buildSlider(),

            const SizedBox(height: 16),

            // Categories

            const SizedBox(height: 8),
            _buildCategoryChips(),

            // Food List
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Popular Dishes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildFoodList(context, cartController),
          ],
        ),
      ),
      // Bottom Cart Section
    );
  }

  // Generate a random color gradient from light to dark
  List<Color> _getGradientColors() {
    final Random random = Random();
    Color baseColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    // Create a gradient by adjusting the brightness of the base color
    Color lightColor = baseColor.withOpacity(0.7);
    Color darkColor =
        baseColor.withOpacity(1.0).withRed((baseColor.red * 0.8).toInt());

    return [lightColor, darkColor];
  }

  // Build the Slider Section
  Widget _buildSlider() {
    return GetBuilder<FoodController>(
      builder: (controller) {
        // Check if foodItems is empty and display a loading indicator or placeholder
        if (controller.foodItems.isEmpty) {
          return const Center(
              child: CircularProgressIndicator()); // Loading indicator
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: 250.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: controller.foodItems.take(5).map((item) {
            return Builder(
              builder: (BuildContext context) {
                List<Color> gradientColors = _getGradientColors();
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Background Container with Gradient
                    Container(
                      margin: const EdgeInsets.only(
                          top: 50.0), // Push down to align image on top
                      padding: const EdgeInsets.only(top: 60.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Floating Product Image
                    Positioned(
                      top: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.asset(
                          item.imageUrl,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  // Build Category Chips Section
  Widget _buildCategoryChips() {
    List<String> categories = [
      "All",
      "Vegetables",
      "Main Course",
      "Fruits",
      "Snacks",
      "Desserts"
    ];
    return GetBuilder<FoodController>(
      builder: (controller) {
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category = categories[index];
              bool isSelected = controller.selectedCategory == category;

              return GestureDetector(
                onTap: () {
                  controller.selectCategory(
                      category); // Update category and filter items
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  } // Build Food List Section

  Widget _buildFoodList(context, cartController) {
    return GetBuilder<FoodController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: controller.foodItems.map((item) {
              return GestureDetector(
                onTap: () =>
                    showFoodDetailsBottomSheet(context, item, cartController),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Food Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.smallDescription,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '325 Kcal',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Additional Details
                            Row(
                              children: [
                                const Icon(Icons.timer, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  "24 mins",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  } // Build Bottom Cart Bar
}
