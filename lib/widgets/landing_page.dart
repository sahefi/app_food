import 'package:app_makanan/widgets/app_bar.dart';
import 'package:app_makanan/widgets/slider_banner_page.dart';
import 'package:app_makanan/widgets/slider_page.dart';
import 'package:flutter/material.dart';
import 'package:app_makanan/data/data_produk.dart';
import 'package:intl/intl.dart'; // Import data

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: false, showLogout: true,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider
            Container(height: 200, child: SliderPage()),

            // Section Kategori
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryBox(Icons.fastfood, 'Makanan', context),
                  _buildCategoryBox(Icons.local_drink, 'Minuman', context),
                  _buildCategoryBox(Icons.cake, 'Kue', context),
                  _buildCategoryBox(Icons.icecream, 'Es Krim', context),
                  _buildCategoryBox(Icons.local_pizza, 'Pizza', context),
                  _buildCategoryBox(Icons.rice_bowl, 'Nasi', context),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section Top Seller
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Seller',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/user/produk');
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200, // Adjust height for better layout
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topSellerList.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final item = topSellerList[index];
                  return _buildTopSellerCard(item, context);
                },
              ),
            ),

            // Spacer
            const SizedBox(height: 24),

            // Optional Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Promo Voucher',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Slider Banner
            Container(height: 200, child: SliderBanner()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBox(IconData icon, String label, context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/user/produk',
          arguments: {'kategori': label}, // Kirim kategori
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue[700]),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellerCard(Map<String, dynamic> item, context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/user/detail/produk',
          arguments: item,
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Stack(
          children: [
            // Card utama
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Increased padding for more height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    // Image with border radius
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Border radius for image
                      child: Image.asset(
                        item['foto'] ?? '',
                        height: 80, // Increase height for the image
                        width: double.infinity, // Make image take the full width of the card
                        fit: BoxFit.cover, // Ensure the image fits nicely
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Product Name
                    Text(
                      item['nama'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Price aligned to the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(item['harga'] ?? 0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      item['deskripsi'] ?? '',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Rating in the top-right corner
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      "${item['rating'] ?? 0}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
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
