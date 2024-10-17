import 'package:get/get.dart';
import 'package:keus/model/food_item.dart';

class CartController extends GetxController {
  // Store cart items with their quantities
  final Map<FoodItem, int> cartItems = {};

  // Add an item to the cart, with an optional quantity
  void addToCart(FoodItem item, [int quantity = 1]) {
    if (cartItems.containsKey(item)) {
      cartItems[item] = cartItems[item]! + quantity; // Update quantity if item exists
    } else {
      cartItems[item] = quantity; // Add item with initial quantity
    }
    update(); // Notify listeners about the change
  }

  // Remove a specific quantity or the entire item from the cart
  void removeFromCart(FoodItem item, [int quantity = 1]) {
    if (cartItems.containsKey(item)) {
      final currentQuantity = cartItems[item]!;
      if (currentQuantity <= quantity) {
        cartItems.remove(item); // Remove item if quantity is zero or less
      } else {
        cartItems[item] = currentQuantity - quantity; // Decrease quantity
      }
      update(); // Notify listeners about the change
    }
  }

  // Clear all items from the cart
  void clearCart() {
    cartItems.clear();
    update();
  }

  // Calculate the total price of all items in the cart
  double get totalPrice {
    double total = 0.0;
    cartItems.forEach((item, quantity) {
      total += item.price * quantity;
    });
    return total;
  }

  // Calculate the total quantity of items in the cart
  int get totalItems {
    int total = 0;
    cartItems.forEach((item, quantity) {
      total += quantity;
    });
    return total;
  }

  // Get the quantity of a specific item in the cart
  int getItemQuantity(FoodItem item) {
    return cartItems[item] ?? 0;
  }

  // Update the quantity of a specific item in the cart
  void updateQuantity(FoodItem item, int quantity) {
    if (quantity > 0) {
      cartItems[item] = quantity;
    } else {
      cartItems.remove(item); // Remove item if quantity is zero
    }
    update(); // Notify listeners about the change
  }
}
