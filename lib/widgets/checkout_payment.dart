import 'package:app_makanan/widgets/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutPayment extends StatefulWidget {  
  final int subtotal;

  const CheckoutPayment({
    super.key,    
    required this.subtotal,
  });

  @override
  State<CheckoutPayment> createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  String selectedPayment = 'e-wallet';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'label': 'E - Wallet',
        'value': 'e-wallet',
        'icon': Icons.account_balance_wallet,
      },
      {
        'label': 'Transfer Bank',
        'value': 'bank-transfer',
        'icon': Icons.account_balance,
      },
      {'label': 'QRIS', 'value': 'qris', 'icon': Icons.qr_code},
      {
        'label': 'Kartu Kredit',
        'value': 'credit-card',
        'icon': Icons.credit_card,
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          kToolbarHeight,
        ), // Specify the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the AppBar
            boxShadow: const [
              BoxShadow(
                color: Colors.black12, // Shadow color
                offset: Offset(0, 3), // Shadow offset
                blurRadius: 6, // Shadow blur radius
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Cart'),
            leading: const BackButton(),
            backgroundColor: Colors.white, // AppBar background color
            elevation: 0, // Remove the default shadow of AppBar
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // List metode pembayaran
            ...options.map((option) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RadioListTile<String>(
                  value: option['value']!,
                  groupValue: selectedPayment,
                  activeColor: const Color(0xFF0070A7),
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                  title: Text(option['label']!),
                  secondary: Icon(option['icon'] as IconData),
                ),
              );
            }),

            const Divider(height: 32),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Belanja', style: TextStyle(fontSize: 16)),
                Text(
                  'Rp ${NumberFormat('#,###', 'id_ID').format(widget.subtotal)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentSuccess()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0070A7),
                ),
                child: const Text(
                  'Bayar',
                  style: TextStyle(color: Colors.white),
                ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
