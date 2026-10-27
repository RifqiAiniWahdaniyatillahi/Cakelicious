import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
import 'order_detail_screen.dart';

const primaryColor = Color(0xFFE91E63);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final orders = Provider.of<OrderService>(context, listen: false);

    if (!_fetching) {
      _fetching = true;
      await orders.fetchOrders(auth.user!.uid);
      _fetching = false;
    }
  }

  String shortId(String id) {
    if (id.isEmpty) return '-';
    return id.length >= 8 ? id.substring(0, 8) : id;
  }

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    final orders = ordersService.orders;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
        ],
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/home');
          if (i == 1) Navigator.pushReplacementNamed(context, '/menu');
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://drive.google.com/uc?export=view&id=1x3nrb1wTyYPa9xNGu2bnBHlVB-l9AF68',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Riwayat Pesanan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // LIST ORDER
            Expanded(
              child:
                  orders.isEmpty
                      ? const Center(child: Text('Belum ada pesanan'))
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text('Order ${shortId(order.id)}'),
                              subtitle: Text(
                                'Tanggal: ${order.createdAt.toLocal().toString().split('.')[0]}',
                              ),
                              trailing: Text(
                                'Rp ${order.total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => OrderDetailScreen(order: order),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
