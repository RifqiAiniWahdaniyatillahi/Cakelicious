import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'order_service.dart';
import 'cart_service.dart';

class PdfService {
  /// ==================== GENERATE PDF DARI CART ====================
  static Future<Uint8List> generateReceiptFromCart({
    required CartService cart,
    required double discount,
    required String paymentMethod,
  }) async {
    final pdf = pw.Document();
    final subtotal = cart.totalPrice;
    final tax = subtotal * 0.1;
    final total = subtotal + tax - discount;

    pdf.addPage(
      pw.Page(
        build: (context) {
          return _buildContent(
            items:
                cart.items.map((e) => PdfItem(e.name, e.price, e.qty)).toList(),
            subtotal: subtotal,
            tax: tax,
            discount: discount,
            total: total,
            paymentMethod: paymentMethod,
          );
        },
      ),
    );

    return pdf.save();
  }

  /// ==================== GENERATE PDF DARI ORDER (RIWAYAT) ====================
  static Future<Uint8List> generateReceiptFromOrder({
    required OrderModel order,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return _buildContent(
            items:
                order.items
                    .map((e) => PdfItem(e.name, e.price, e.qty))
                    .toList(),
            subtotal: order.subtotal,
            tax: order.tax,
            discount: order.discount,
            total: order.total,
            paymentMethod: order.paymentMethod,
          );
        },
      ),
    );

    return pdf.save();
  }

  /// ==================== PRINT PDF DARI CART ====================
  static Future<void> printReceiptFromCart({
    required CartService cart,
    required double discount,
    required String paymentMethod,
  }) async {
    final pdfData = await generateReceiptFromCart(
      cart: cart,
      discount: discount,
      paymentMethod: paymentMethod,
    );
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }

  /// ==================== PRINT PDF DARI ORDER ====================
  static Future<void> printReceiptFromOrder({required OrderModel order}) async {
    final pdfData = await generateReceiptFromOrder(order: order);
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }

  /// ==================== INTERNAL CONTENT ====================
  static pw.Widget _buildContent({
    required List<PdfItem> items,
    required double subtotal,
    required double tax,
    required double discount,
    required double total,
    required String paymentMethod,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        /// TITLE
        pw.Center(
          child: pw.Text(
            'STRUK PESANAN',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),

        pw.SizedBox(height: 16),

        /// PAYMENT METHOD
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [pw.Text('Metode Pembayaran'), pw.Text(paymentMethod)],
        ),

        pw.Divider(),

        /// ITEMS
        ...items.map(
          (item) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('${item.name} x${item.qty}'),
              pw.Text('Rp ${(item.price * item.qty).toStringAsFixed(0)}'),
            ],
          ),
        ),

        pw.Divider(),

        /// SUMMARY
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Subtotal'),
            pw.Text('Rp ${subtotal.toStringAsFixed(0)}'),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Pajak (10%)'),
            pw.Text('Rp ${tax.toStringAsFixed(0)}'),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Diskon'),
            pw.Text('- Rp ${discount.toStringAsFixed(0)}'),
          ],
        ),

        pw.Divider(),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Total Bayar',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Rp ${total.toStringAsFixed(0)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

/// ==================== HELPER ====================
class PdfItem {
  final String name;
  final double price;
  final int qty;

  PdfItem(this.name, this.price, this.qty);
}
