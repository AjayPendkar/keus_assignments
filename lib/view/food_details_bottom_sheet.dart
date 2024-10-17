import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keus/controller/cart_controller.dart';
import 'package:keus/model/food_item.dart';
import 'package:keus/view/cart_bottom_sheet.dart';

void showFoodDetailsBottomSheet(BuildContext context, FoodItem item, CartController cartController) {
  int quantity = cartController.getItemQuantity(item) > 0 ? cartController.getItemQuantity(item) : 1;
  double totalPrice = item.price * quantity;
  bool isInCart = cartController.getItemQuantity(item) > 0;

  Get.bottomSheet(
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FractionallySizedBox(
          heightFactor: 0.8, // 80% of the screen height
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      item.imageUrl,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  item.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  item.bigDescription,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                // Nutritional Info Section
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutritionalInfo(item.nutrition.kcal.toString(), "kcal"),
                      _buildNutritionalInfo(item.nutrition.grams.toString(), "grams"),
                      _buildNutritionalInfo(item.nutrition.proteins.toString(), "proteins"),
                      _buildNutritionalInfo(item.nutrition.fats.toString(), "fats"),
                      _buildNutritionalInfo(item.nutrition.carbs.toString(), "carbs"),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Selector
                    Row(
                      children: [
                        IconButton(
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                    totalPrice = item.price * quantity;
                                    cartController.updateQuantity(item, quantity);
                                  });
                                }
                              : null, // Disable button when quantity <= 1
                          icon: Icon(Icons.remove),
                          color: quantity > 1 ? Colors.grey : Colors.grey[300], // Visual hint when disabled
                        ),
                        Text(
                          "$quantity",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                              totalPrice = item.price * quantity;
                              if (isInCart) {
                                cartController.updateQuantity(item, quantity);
                              }
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    // Add/Remove Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart ? Colors.red : Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                           Get.back();
                          if (isInCart) {
                            cartController.removeFromCart(item);
                            Get.snackbar(
                              'Removed from Cart',
                              '${item.name} has been removed from the cart.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.withOpacity(0.8),
                              colorText: Colors.white,
                            );
                            quantity = 1; // Reset to 1 after removal
                            totalPrice = item.price; // Reset total price
                            isInCart = false;
                          } else {
                            cartController.addToCart(item, quantity);
                            Get.snackbar(
                              'Added to Cart',
                              '${item.name} has been added to the cart.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.8),
                              colorText: Colors.white,
                              onTap: (_) {
                                showCartBottomSheet(context, cartController);
                              },
                            );
                            isInCart = true;
                          }
                         
                        });
                      },
                      child: Text(
                        isInCart ? "Remove from Cart" : "Add to cart • \$${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    isScrollControlled: true,
  );
}

// Helper for Nutritional Info Display
Widget _buildNutritionalInfo(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  );
}
