import 'package:flutter/material.dart';

class SliderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        _buildPage(
          imageUrl: 'assets/voucher1.jpg', // Ganti dengan asset gambar Anda
        ),
        _buildPage(
          imageUrl: 'assets/voucher2.jpg', // Ganti dengan URL gambar Anda
        ),
        _buildPage(
          imageUrl: 'assets/voucher3.jpg', // Ganti dengan URL gambar Anda
        ),
      ],
    );
  }

  Widget _buildPage({
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(        
        children: [
          // Menggunakan Image.network untuk memuat gambar dari URL
          Image.asset(
            imageUrl,
            height: 200,
            width: double.infinity, // Gambar mengisi lebar penuh
            fit: BoxFit.contain,  // Menjaga rasio gambar dan memastikan gambar tidak terpotong
          ),
        ],
      ),
    );
  }
}
