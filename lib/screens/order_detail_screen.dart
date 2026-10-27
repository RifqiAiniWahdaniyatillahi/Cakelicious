import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../services/pdf_service.dart';

const primaryColor = Color(0xFFE91E63);

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== TANGGAL & METODE =====
            Text(
              'Tanggal: ${order.createdAt.toLocal().toString().split('.')[0]}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Metode Pembayaran: ${order.paymentMethod}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const Divider(height: 32),

            /// ===== ITEMS =====
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${item.name} x${item.qty}')),
                    Text('Rp ${(item.price * item.qty).toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),

            const Divider(height: 32),

            /// ===== SUMMARY =====
            _summaryRow('Subtotal', order.subtotal),
            _summaryRow('Pajak (10%)', order.tax),
            _summaryRow('Diskon', -order.discount),
            const Divider(),
            _summaryRow(
              'Total',
              order.total,
              isBold: true,
              color: primaryColor,
            ),

            const Spacer(),

            /// ===== EXPORT PDF =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  try {
                    await PdfService.printReceiptFromOrder(order: order);
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
    );
  }

  Widget _summaryRow(
    String label,
    double value, {
    bool isBold = false,
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
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
