import "dart:developer";

import "package:flutter/foundation.dart";
import "package:state_management/api.dart";

class Cart {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  int qty = 1;

  Cart(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image});

  factory Cart.create(Map<String, dynamic> object) => Cart(
        id: object['id'],
        title: object['title'],
        price: object['price'],
        description: object['description'],
        category: object['category'],
        image: object['image'],
      );

  Future<List<Cart>> getCarts() async {
    final data = await dio.get("products");
    return data.data;
  }
}

class CartProvider extends ChangeNotifier {
  final List<Cart> _carts = [];

  List<Cart> get carts => _carts;

  void addItem(Cart item) {
    if (carts.indexWhere((element) => element.id == item.id) >= 0) {
      carts
          .firstWhere(
            (element) => element.id == item.id,
          )
          .qty += 1;
    } else {
      carts.add(item);
    }
    notifyListeners();
  }

  void removeItem(int id) {
    int element = carts.indexWhere((element) => element.id == id);

    if (element == -1) return;

    if (carts[element].qty == 1) {
      carts.removeWhere((element) => element.id == id);
    } else {
      carts[element].qty--;
    }

    notifyListeners();
  }
}
