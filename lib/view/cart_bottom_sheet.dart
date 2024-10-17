import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keus/controller/cart_controller.dart';
import 'package:keus/model/food_item.dart';

void showCartBottomSheet(BuildContext context, CartController cartController) {
  Get.bottomSheet(
    FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We will deliver in 24 minutes to the address:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "100a Ealing Rd",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Change address",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            Divider(),
            // Wrap ListView in GetBuilder to listen to updates
            Expanded(
              child: GetBuilder<CartController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = controller.cartItems.keys.toList()[index];
                      final quantity = controller.cartItems[item]!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                item.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '\$${(item.price * quantity).toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.grey),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      controller.updateQuantity(item, quantity - 1);
                                    } else {
                                      controller.removeFromCart(item);
                                    }
                                  },
                                ),
                                Text(
                                  '$quantity',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.grey),
                                  onPressed: () {
                                    controller.updateQuantity(item, quantity + 1);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(),
            // Delivery Fee and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "\$0.00", // Hardcoded example, update as needed
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Text(
              "Free delivery from \$30",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GetBuilder<CartController>(
                  builder: (controller) {
                    return Text(
                      "\$${controller.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // Payment Method and Pay Button
            Text(
              "Payment method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                Icon(Icons.apple, size: 24),
                SizedBox(width: 8),
                Text("Apple Pay"),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Implement payment logic here
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pay",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 16),
                  GetBuilder<CartController>(
                    builder: (controller) {
                      return Text("24 min • \$${controller.totalPrice.toStringAsFixed(2)}");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
