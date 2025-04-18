import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String linkBackButton;
  final bool showSearch;
  final bool searchEnabled;
  final ValueChanged<String>? onSearchChanged;
  final String title;
  final bool showLogo;
  final bool showCart;
  final bool showLogout;  // Add this parameter to control logout visibility

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.linkBackButton = '',
    this.showSearch = false,
    this.searchEnabled = true,
    this.onSearchChanged,
    this.title = '',
    this.showLogo = true,
    this.showCart = true,
    this.showLogout = false,  // Default to true
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}

class _CustomAppBarState extends State<CustomAppBar> {
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  // Method to load the cart item count from SharedPreferences
  _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];

    Map<String, int> productCounts =
        {}; // Menyimpan jumlah produk berdasarkan nama

    for (String productJson in cart) {
      Map<String, dynamic> product = json.decode(
        productJson,
      ); // Mendekode JSON string ke Map
      String productName = product['nama']; // Ambil nama produk

      // Tambahkan produk ke map dan hitung jumlahnya
      if (productCounts.containsKey(productName)) {
        productCounts[productName] = productCounts[productName]! + 1;
      } else {
        productCounts[productName] = 1;
      }
    }

    setState(() {
      // Menghitung total item berdasarkan jumlah produk yang berbeda
      cartItemCount =
          productCounts.length; // Menyimpan jumlah produk unik di cart
      print('Produk unik di cart: $productCounts');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 2),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                // Back button
                Visibility(
                  visible: widget.showBackButton,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.grey[700],
                    onPressed: () {
                      // Navigasi ke halaman menggunakan linkBackButton
                      Navigator.pushNamed(context, widget.linkBackButton);
                    },
                  ),
                ),

                // Logo
                Visibility(
                  visible: widget.showLogo,
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                    height: 32,
                  ),
                ),
                if (widget.showLogo) const SizedBox(width: 8),

                // Search bar or Title
                if (widget.showSearch)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        enabled: widget.searchEnabled,
                        decoration: InputDecoration(
                          hintText: 'Cari produk...',
                          prefixIcon: const Icon(Icons.search),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: widget.onSearchChanged,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                // Cart Icon with badge
                Visibility(
                  visible: widget.showCart,
                  child: Row(
                    children: [
                      // Icon Pesanan
                      IconButton(
                        icon: const Icon(
                          Icons.receipt_long_outlined,
                        ), // atau ikon lain sesuai kebutuhan
                        color: Colors.grey[700],
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/user/order',
                          ); // Ganti dengan route pesanan kamu
                        },
                      ),
                      // Icon Keranjang
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined),
                            color: Colors.grey[700],
                            onPressed: () {
                              Navigator.pushNamed(context, '/user/cart');
                            },
                          ),
                          if (cartItemCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    cartItemCount > 99
                                        ? '99+'
                                        : '$cartItemCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Logout Icon
                Visibility(
                  visible: widget.showLogout,
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.red[700],
                    onPressed: () async {
                      // Tampilkan dialog konfirmasi logout
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi Logout'),
                          content: const Text(
                            'Apakah Anda yakin ingin logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      // Jika pengguna mengonfirmasi logout
                      if (shouldLogout == true) {
                        // Hapus data pengguna dari SharedPreferences jika diperlukan
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();

                        // Navigasi ke halaman utama dan hapus semua rute sebelumnya
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
