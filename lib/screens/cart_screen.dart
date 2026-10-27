import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import 'order_receipt_screen.dart';

const primaryColor = Color(0xFFE91E63);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _discountCtrl = TextEditingController();

  double discount = 0;
  String paymentMethod = 'Cash';

  void applyDiscount(double subtotal) {
    final code = _discountCtrl.text.trim().toUpperCase();

    setState(() {
      if (code == 'CAKE10') {
        discount = subtotal * 0.1;
      } else if (code == 'CAKE20') {
        discount = subtotal * 0.2;
      } else {
        discount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartService>();
    final subtotal = cart.totalPrice;
    final tax = subtotal * 0.1;
    final total = subtotal + tax - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: primaryColor,
      ),
      body:
          cart.items.isEmpty
              ? const Center(child: Text('Keranjang kosong'))
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// ITEM LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                              'Rp ${item.price.toStringAsFixed(0)} x ${item.qty}',
                            ),
                            trailing: Text(
                              'Rp ${(item.price * item.qty).toStringAsFixed(0)}',
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(height: 32),

                    /// summary
                    _row('Subtotal', subtotal),
                    _row('Pajak (10%)', tax),
                    _row('Diskon', -discount),
                    const Divider(),
                    _row('Total', total, bold: true),

                    const SizedBox(height: 16),

                    /// metodepembayaran
                    DropdownButtonFormField<String>(
                      value: paymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'Metode Pembayaran',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                        DropdownMenuItem(
                          value: 'Transfer',
                          child: Text('Transfer'),
                        ),
                        DropdownMenuItem(
                          value: 'E-Wallet',
                          child: Text('E-Wallet'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    /// discount input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _discountCtrl,
                            decoration: InputDecoration(
                              hintText: 'Kode diskon (CAKE10 / CAKE20)',
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => applyDiscount(subtotal),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// CHECKOUT
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => OrderReceiptScreen(
                                    cart: cart,
                                    discount: discount,
                                    paymentMethod: paymentMethod,
                                  ),
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            'Rp ${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
