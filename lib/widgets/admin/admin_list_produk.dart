import 'dart:convert';
import 'package:app_makanan/widgets/admin/admin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AdminListProduk extends StatefulWidget {
  const AdminListProduk({Key? key}) : super(key: key);

  @override
  State<AdminListProduk> createState() => _AdminListProdukState();
}

class _AdminListProdukState extends State<AdminListProduk> {
  String _searchTerm = '';
  String? _selectedKategori;
  List<Map<String, dynamic>> mergedList = [];

  @override
  void initState() {
    super.initState();
    _loadProdukFromPrefs();
  }

  Future<void> _loadProdukFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final produkList = prefs.getStringList('produk') ?? [];

    List<Map<String, dynamic>> decodedList = produkList.map((item) {
      return Map<String, dynamic>.from(jsonDecode(item));
    }).toList();

    // Assign ke mergedList
    setState(() {
      mergedList = decodedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('kategori')) {
      _selectedKategori = args['kategori'];
    }

    final filteredList = mergedList.where((item) {
      final matchSearch = (item['nama']?.toString() ?? '')
          .toLowerCase()
          .contains(_searchTerm.toLowerCase());
      final matchKategori =
          _selectedKategori == null || item['kategori'] == _selectedKategori;
      return matchSearch && matchKategori;
    }).toList();

    return Scaffold(
      appBar: const AdminAppBar(title: 'Produk Saya'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/admin/produk/create');
        },
        backgroundColor: const Color(0xFF0070A7),
        child: const Icon(Icons.add, color: Colors.white),
        shape: const CircleBorder(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      itemCount: filteredList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return _buildTopSellerCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            'Produk tidak ditemukan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellerCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/admin/produk/edit', arguments: item);
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(item['foto']),
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['nama'] ?? 'No Name',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Rp ${NumberFormat('#,###', 'id_ID').format(item['harga'] ?? 0)}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['deskripsi'] ?? '',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
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
