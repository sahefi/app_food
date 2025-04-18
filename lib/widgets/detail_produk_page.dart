import 'dart:convert';

import 'package:app_makanan/widgets/app_bar.dart';
import 'package:app_makanan/widgets/checkout_payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProduk extends StatefulWidget {
  const DetailProduk({super.key});

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  int jumlah = 1;

  @override
  Widget build(BuildContext context) {
    final item =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int harga = item['harga'] ?? 0;
    final int stok = item['stok'] ?? 0;
    final int subtotal = harga * jumlah;

    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        linkBackButton: '/user/produk',
      ),
      body: Column(
        children: [
          Image.asset(
            item['foto'] ?? '',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(harga)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['nama'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text('${item['rating'] ?? 0}'),
                      const SizedBox(width: 4),
                      const Text('30+ Terjual'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jumlah',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed:
                                jumlah > 1
                                    ? () => setState(() => jumlah--)
                                    : null,
                          ),
                          Text('$jumlah'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed:
                                jumlah < stok
                                    ? () => setState(() => jumlah++)
                                    : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(subtotal ?? 0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Get the current preferences
                      final prefs = await SharedPreferences.getInstance();

                      // Hitung subtotal
                      final int subtotal = item['harga'] * jumlah;

                      // Prepare the item data with jumlah and subtotal
                      final Map<String, dynamic> cartItem = {
                        'foto': item['foto'],
                        'rating': item['rating'],
                        'nama': item['nama'],
                        'harga': item['harga'],
                        'deskripsi': item['deskripsi'],
                        'stok': item['stok'],
                        'toko': item['toko'],
                        'kategori': item['kategori'],
                        'jumlah': jumlah, // Quantity
                        'subtotal': subtotal, // Subtotal
                      };

                      // Convert the cart item map to a JSON string
                      final String itemJson = jsonEncode(cartItem);

                      // Save the item to localStorage (key: 'cart')
                      List<String> cartItems =
                          prefs.getStringList('cart') ?? [];
                      cartItems.add(itemJson);

                      // Save the updated cart list to localStorage
                      await prefs.setStringList('cart', cartItems);

                      // Arahkan ke halaman cart
                      Navigator.pushNamed(context, '/user/cart');
                    },

                    icon: const Icon(Icons.add),
                    label: const Text('Keranjang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0070A7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CheckoutPayment(                       
                                subtotal: subtotal,
                              ),
                        ),
                      );
                    },
                    child: const Text('Beli Sekarang'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[700],
                      side: BorderSide(color: Colors.blue[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariation(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.blue[100],
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[800] : Colors.black87,
      ),
    );
  }
}
