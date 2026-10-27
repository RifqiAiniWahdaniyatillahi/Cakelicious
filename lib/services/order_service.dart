import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// ================= ORDER ITEM =================
class OrderItem {
  final String name;
  final double price;
  final int qty;

  OrderItem({required this.name, required this.price, required this.qty});

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'qty': qty};
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      qty: map['qty'] as int? ?? 0,
    );
  }
}

/// ================= ORDER MODEL =================
class OrderModel {
  final String id;
  final String userId;
  final String email;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.email,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return OrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      email: data['email'] as String? ?? '',
      items:
          (data['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0,
      tax: (data['tax'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      paymentMethod: data['paymentMethod'] as String? ?? 'Cash',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// ================= ORDER SERVICE =================
class OrderService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<OrderModel> _orders = [];
  double _totalSales = 0;

  List<OrderModel> get orders => _orders;
  double get totalSales => _totalSales;

  /// ================= CREATE ORDER =================
  Future<void> createOrder({
    required String userId,
    required String email,
    required List<OrderItem> items,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    required String paymentMethod,
  }) async {
    try {
      final docRef = await _firestore.collection('orders').add({
        'userId': userId,
        'email': email,
        'items': items.map((e) => e.toMap()).toList(),
        'subtotal': subtotal,
        'discount': discount,
        'tax': tax,
        'total': total,
        'paymentMethod': paymentMethod,
        'createdAt': Timestamp.now(),
      });

      final newOrder = OrderModel(
        id: docRef.id,
        userId: userId,
        email: email,
        items: items,
        subtotal: subtotal,
        discount: discount,
        tax: tax,
        total: total,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      );

      _orders.insert(0, newOrder);
      notifyListeners();

      await fetchTotalSales(userId);
    } catch (e) {
      debugPrint('Create Order Failed: $e');
      rethrow;
    }
  }

  /// ================= FETCH ORDERS =================
  Future<void> fetchOrders(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      _orders =
          snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();

      notifyListeners();
      await fetchTotalSales(userId);
    } catch (e) {
      debugPrint('Fetch Orders Failed: $e');
    }
  }

  /// ================= FETCH TOTAL SALES =================
  Future<void> fetchTotalSales(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .get();

      _totalSales = snapshot.docs.fold<double>(0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final total = (data['total'] as num?)?.toDouble() ?? 0;
        return sum + total;
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Fetch Total Sales Failed: $e');
    }
  }

  /// ================= CLEAR =================
  void clearOrders() {
    _orders = [];
    _totalSales = 0;
    notifyListeners();
  }
}
