import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';

const primaryColor = Color(0xFFE91E63);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch total sales saat masuk home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthService>(context, listen: false);
      final orders = Provider.of<OrderService>(context, listen: false);

      if (auth.user != null) {
        orders.fetchOrders(auth.user!.uid);
        orders.fetchTotalSales(auth.user!.uid);
      }
    });
  }

  /// ================= DATA PRODUK (12 ITEM) =================
  static final List<Map<String, dynamic>> products = [
    {
      'name': 'Triple Chocolate',
      'price': 50000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1N8yTcMMUfB3twiAl34Dmqjkd35sth0tf',
    },
    {
      'name': 'Mango Passion',
      'price': 50000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1VZeWX0mSf7g3OcCTjgzmN8_uv0-7BQP2',
    },
    {
      'name': 'Caramel Cake',
      'price': 45000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1PXgm1yvi93GwL-LGO3qOSWHHrETPZkra',
    },
    {
      'name': 'Strawberry Shortcake',
      'price': 43000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1m_4ME544hcGJc9jT3OAiN5mHKIZufIrN',
    },
    {
      'name': 'Cheese Cake',
      'price': 48000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1zeSs0OInlQ_p_rg5VT85rAJ6wF2m_O6e',
    },
    {
      'name': 'Red Velvet',
      'price': 47000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=17kQaMnjW5u678WO5Z-34UfTCWqFToKqD',
    },
    {
      'name': 'Vanilla Cake',
      'price': 40000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=14gB2nd4aJ5JceFos6VpKE1PZCCqrf0gE',
    },
    {
      'name': 'Choco Lava',
      'price': 52000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1afbbsncXj7IWR6M1NFQ3RMNqYb-ZVvjx',
    },
    {
      'name': 'Blueberry Cake',
      'price': 48000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1WfbXkm5YXRS5iNUrB2r1Dd5eq-bUG_QQ',
    },
    {
      'name': 'Strawberry Oreo',
      'price': 46000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=14tMOPhTeQubo3a-lA-W3IzT87DQun9kj',
    },
    {
      'name': 'Coffee Cake',
      'price': 46000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1YT9NnfvGQ59-ugfaKcDJ6adLKlDFk94O',
    },
    {
      'name': 'Matcha Cake',
      'price': 49000.0,
      'image':
          'https://drive.google.com/uc?export=view&id=1E02SshWjzV3du12X7rHnfSaHyV2awbnN',
    },
  ];

  /// ================= DATA BANNER =================
  static final List<String> banners = [
    'https://drive.google.com/uc?export=view&id=1KCBxPv7IHMdcztD5ndLtu4nm8G4hCrM8',
    'https://drive.google.com/uc?export=view&id=1LZhx4jJ279vXVe1b_4M5Yn21P2Q71dxh',
    'https://drive.google.com/uc?export=view&id=1sQjEVyhE8AMHacX-0FXZ-oY8dnNJQvU-',
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final cart = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // HOME
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/menu');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/orders');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(
                        'https://drive.google.com/uc?export=view&id=1x3nrb1wTyYPa9xNGu2bnBHlVB-l9AF68',
                        width: 36,
                        height: 36,
                        errorBuilder:
                            (_, __, ___) =>
                                const Icon(Icons.cake, color: primaryColor),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Cakelicious',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed:
                                () => Navigator.pushNamed(context, '/cart'),
                          ),
                          if (cart.items.isNotEmpty)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: primaryColor,
                                child: Text(
                                  '${cart.items.length}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          auth.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ================= DASHBOARD =================
              Consumer<OrderService>(
                builder: (context, orderService, _) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Orders',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total Sales : Rp ${orderService.totalSales.toStringAsFixed(0)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.dashboard,
                            color: primaryColor,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// ================= BANNER =================
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: banners.length,
                  itemBuilder:
                      (context, index) => Container(
                        width: 300,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(banners[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                ),
              ),

              const SizedBox(height: 24),

              /// ================= BEST SELLERS =================
              _sectionHeader(context, 'Best Sellers'),
              const SizedBox(height: 12),
              _productList(context, cart, products.sublist(0, 6)),

              const SizedBox(height: 24),

              /// ================= NEW ARRIVALS =================
              _sectionHeader(context, 'New Arrivals'),
              const SizedBox(height: 12),
              _productList(context, cart, products.sublist(6, 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/menu'),
          child: const Text(
            'See All',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _productList(BuildContext context, CartService cart, List items) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return Container(
            width: 170,
            margin: const EdgeInsets.only(right: 12),
            child: _productCard(product, cart),
          );
        },
      ),
    );
  }

  Widget _productCard(Map product, CartService cart) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              product['image'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${product['price'].toStringAsFixed(0)}',
                  style: const TextStyle(color: primaryColor),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      cart.addItem(
                        name: product['name'],
                        price: product['price'],
                        image: product['image'],
                      );
                    },
                    child: const Text(
                      'Add Cart',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
