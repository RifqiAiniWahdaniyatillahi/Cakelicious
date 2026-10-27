import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

const primaryColor = Color(0xFFE91E63);

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> categories = [
    'All',
    'Chocolate',
    'Fruit',
    'Classic',
    'Velvet',
    'Cheese',
  ];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Triple Chocolate',
      'price': 50000.0,
      'category': 'Chocolate',
      'image':
          'https://drive.google.com/uc?export=view&id=1N8yTcMMUfB3twiAl34Dmqjkd35sth0tf',
    },
    {
      'name': 'Mango Passion',
      'price': 50000.0,
      'category': 'Fruit',
      'image':
          'https://drive.google.com/uc?export=view&id=1VZeWX0mSf7g3OcCTjgzmN8_uv0-7BQP2',
    },
    {
      'name': 'Caramel Cake',
      'price': 45000.0,
      'category': 'Classic',
      'image':
          'https://drive.google.com/uc?export=view&id=1PXgm1yvi93GwL-LGO3qOSWHHrETPZkra',
    },
    {
      'name': 'Strawberry Shortcake',
      'price': 43000.0,
      'category': 'Fruit',
      'image':
          'https://drive.google.com/uc?export=view&id=1m_4ME544hcGJc9jT3OAiN5mHKIZufIrN',
    },
    {
      'name': 'Cheese Cake',
      'price': 48000.0,
      'category': 'Cheese',
      'image':
          'https://drive.google.com/uc?export=view&id=1zeSs0OInlQ_p_rg5VT85rAJ6wF2m_O6e',
    },
    {
      'name': 'Red Velvet',
      'price': 47000.0,
      'category': 'Velvet',
      'image':
          'https://drive.google.com/uc?export=view&id=17kQaMnjW5u678WO5Z-34UfTCWqFToKqD',
    },
    {
      'name': 'Vanilla Cake',
      'price': 40000.0,
      'category': 'Classic',
      'image':
          'https://drive.google.com/uc?export=view&id=14gB2nd4aJ5JceFos6VpKE1PZCCqrf0gE',
    },
    {
      'name': 'Choco Lava',
      'price': 52000.0,
      'category': 'Chocolate',
      'image':
          'https://drive.google.com/uc?export=view&id=1afbbsncXj7IWR6M1NFQ3RMNqYb-ZVvjx',
    },
    {
      'name': 'Blueberry Cake',
      'price': 48000.0,
      'category': 'Fruit',
      'image':
          'https://drive.google.com/uc?export=view&id=1WfbXkm5YXRS5iNUrB2r1Dd5eq-bUG_QQ',
    },
    {
      'name': 'Strawberry Oreo',
      'price': 46000.0,
      'category': 'Chocolate',
      'image':
          'https://drive.google.com/uc?export=view&id=14tMOPhTeQubo3a-lA-W3IzT87DQun9kj',
    },
    {
      'name': 'Coffee Cake',
      'price': 46000.0,
      'category': 'Classic',
      'image':
          'https://drive.google.com/uc?export=view&id=1YT9NnfvGQ59-ugfaKcDJ6adLKlDFk94O',
    },
    {
      'name': 'Matcha Cake',
      'price': 49000.0,
      'category': 'Classic',
      'image':
          'https://drive.google.com/uc?export=view&id=1E02SshWjzV3du12X7rHnfSaHyV2awbnN',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);

    final filteredProducts =
        products.where((product) {
          final matchCategory =
              selectedCategory == 'All' ||
              product['category'] == selectedCategory;

          final matchSearch = product['name'].toLowerCase().contains(
            searchQuery.toLowerCase(),
          );

          return matchCategory && matchSearch;
        }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // MENU
        selectedItemColor: primaryColor,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// LOGO + TITLE
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://drive.google.com/uc?export=view&id=1x3nrb1wTyYPa9xNGu2bnBHlVB-l9AF68',
                          height: 36,
                          width: 36,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
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

                  /// LOGOUT + CART
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout, color: primaryColor),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              Navigator.pushNamed(context, '/cart');
                            },
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
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// SEARCH
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search cakes...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// CATEGORY
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isActive = cat == selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? primaryColor : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// GRID PRODUCT
              Expanded(
                child: GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                      foregroundColor: Colors.white,
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
                                      'Add to Cart',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
