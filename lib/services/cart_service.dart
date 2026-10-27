import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;
  final String image;
  int qty;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.qty = 1,
  });
}

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.price * item.qty);

  void addItem({
    required String name,
    required double price,
    required String image,
  }) {
    final index = _items.indexWhere((e) => e.name == name);

    if (index >= 0) {
      _items[index].qty++;
    } else {
      _items.add(CartItem(name: name, price: price, image: image));
    }

    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
