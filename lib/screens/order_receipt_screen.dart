import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
import '../services/pdf_service.dart';

const primaryColor = Color(0xFFE91E63);

class OrderReceiptScreen extends StatelessWidget {
  final CartService cart;
  final double discount;
  final String paymentMethod;

  const OrderReceiptScreen({
    super.key,
    required this.cart,
    required this.discount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.totalPrice;
    final tax = subtotal * 0.1;
    final total = subtotal + tax - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk Pesanan'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // LOGO
                Image.network(
                  'https://drive.google.com/uc?export=view&id=1x3nrb1wTyYPa9xNGu2bnBHlVB-l9AF68',
                  height: 60,
                ),
                const SizedBox(height: 16),

                // ITEMS
                ...cart.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('${item.name} x${item.qty}')),
                        Text(
                          'Rp ${(item.price * item.qty).toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 32),

                // SUMMARY
                _rowText('Subtotal', subtotal),
                _rowText('Pajak (10%)', tax),
                _rowText('Diskon', -discount),

                // METODE PEMBAYARAN
                _rowString('Metode Pembayaran', paymentMethod),

                const Divider(),
                _rowText('Total Bayar', total, bold: true, color: primaryColor),

                const Spacer(),

                // BUTTON SELESAI & LIHAT RIWAYAT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final orders = context.read<OrderService>();
                        final auth = context.read<AuthService>();

                        await orders.createOrder(
                          userId: auth.user!.uid,
                          email: auth.user!.email ?? '',
                          items:
                              cart.items
                                  .map(
                                    (e) => OrderItem(
                                      name: e.name,
                                      price: e.price,
                                      qty: e.qty,
                                    ),
                                  )
                                  .toList(),
                          subtotal: subtotal,
                          tax: tax,
                          discount: discount,
                          total: total,
                          paymentMethod: paymentMethod,
                        );

                        cart.clear();

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/orders',
                          (route) => false,
                        );

                        await orders.fetchOrders(auth.user!.uid);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Terjadi kesalahan saat membuat order: $e',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Selesai & Lihat Riwayat'),
                  ),
                ),

                const SizedBox(height: 12),

                // BUTTON CETAK / EXPORT PDF
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      try {
                        await PdfService.printReceiptFromCart(
                          cart: cart,
                          discount: discount,
                          paymentMethod: paymentMethod,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal cetak PDF: ${e.toString()}'),
                          ),
                        );
                      }
                    },
                    child: const Text('Cetak / Export PDF'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// untuk angka
  Widget _rowText(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
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
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// UNTUK STRING (payment method)
  Widget _rowString(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
