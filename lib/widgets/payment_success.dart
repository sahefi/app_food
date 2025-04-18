import 'package:flutter/material.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/payment_success.png', // Ganti dengan path gambar kamu
              height: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              'Pembayaran Berhasil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0070A7),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Terimakasih telah bertransaksi dengan menggunakan FOOD',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman pesanan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0070A7),
                ),
                child: const Text(
                  'Lihat Pesanan Saya',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                 onPressed: () {
                  // Navigate to the home page (user/home)
                  Navigator.pushNamed(context, '/user/home');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0070A7)),
                  foregroundColor: const Color(0xFF0070A7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_back, color: Color(0xFF0070A7)),
                    SizedBox(width: 8), // Spacing between the icon and text
                    Text('Kembali ke Beranda'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
