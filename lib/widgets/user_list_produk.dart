import 'package:flutter/material.dart';
import 'package:app_makanan/widgets/app_bar.dart';
import 'package:intl/intl.dart';
import '../data/data_produk.dart';

class ListProduk extends StatefulWidget {
  const ListProduk({Key? key}) : super(key: key);

  @override
  State<ListProduk> createState() => _ListProdukState();
}

class _ListProdukState extends State<ListProduk> {
  String _searchTerm = '';
  String? _selectedKategori;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('kategori')) {
      _selectedKategori = args['kategori'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList =
        topSellerList.where((item) {
          final matchSearch = (item['nama']?.toString() ?? '')
              .toLowerCase()
              .contains(_searchTerm.toLowerCase());
          final matchKategori =
              _selectedKategori == null ||
              item['kategori'] == _selectedKategori;
          return matchSearch && matchKategori;
        }).toList();

    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        linkBackButton: '/user/home',
        showSearch: true,
        searchEnabled: true,
        onSearchChanged: (value) {
          setState(() {
            _searchTerm = value;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            filteredList.isEmpty
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Image.asset(
              'assets/empty.png',
              height: 160,
              fit: BoxFit.contain, // Bikin gambar lebih jelas
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellerCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/user/detail/produk', arguments: item);
      },
      borderRadius: BorderRadius.circular(
        12,
      ), // Efek ripple tetap sesuai bentuk
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            // Card Content
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
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item['foto'] ?? '',
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Product Name
                    Text(
                      item['nama'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Price
                    Text(
                      'Rp ${NumberFormat('#,###', 'id_ID').format(item['harga'] ?? 0)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      item['deskripsi'] ?? 'No description available',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Rating positioned at the top-right corner
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
