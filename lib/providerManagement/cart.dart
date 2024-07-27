import 'package:flutter/foundation.dart';

class Cart {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  int qty = 1;

  Cart({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Cart.create(Map<String, dynamic> object) => Cart(
        id: object['id'],
        title: object['title'],
        price: (object['price'] as num).toDouble(),
        description: object['description'],
        category: object['category'],
        image: object['image'],
      );
}

class CartProvider extends ChangeNotifier {
  final List<Cart> _carts = [];

  List<Cart> get carts => _carts;

  void addItem(Cart item) {
    int index = _carts.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      _carts[index].qty += 1;
    } else {
      _carts.add(item);
    }
    notifyListeners();
  }

  void removeItem(int id) {
    int index = _carts.indexWhere((element) => element.id == id);
    if (index == -1) return;

    if (_carts[index].qty == 1) {
      _carts.removeAt(index);
    } else {
      _carts[index].qty--;
    }
    notifyListeners();
  }
}
