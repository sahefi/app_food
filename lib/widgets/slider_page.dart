import 'package:flutter/material.dart';

class SliderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        _buildPage(
          imageUrl: 'assets/banner1.png', // Ganti dengan asset gambar Anda
        ),
        _buildPage(
          imageUrl: 'assets/banner2.png', // Ganti dengan URL gambar Anda
        ),
        _buildPage(
          imageUrl: 'assets/banner3.png', // Ganti dengan URL gambar Anda
        ),
      ],
    );
  }

  Widget _buildPage({
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Hapus padding vertikal
      child: Column(
        children: [
          // Menggunakan Image.network untuk memuat gambar dari URL
          Image.asset(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
