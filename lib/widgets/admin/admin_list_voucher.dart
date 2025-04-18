import 'dart:convert';
import 'package:app_makanan/widgets/admin/admin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AdminListVoucher extends StatefulWidget {
  const AdminListVoucher({Key? key}) : super(key: key);

  @override
  State<AdminListVoucher> createState() => _AdminListVoucherState();
}

class _AdminListVoucherState extends State<AdminListVoucher> {
  String _searchTerm = '';
  List<Map<String, dynamic>> voucherList = [];

  @override
  void initState() {
    super.initState();
    _loadVouchers();
  }

  Future<void> _loadVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList('vouchers') ?? [];

    setState(() {
      voucherList =
          storedList
              .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
              .toList();
    });
  }

  Future<void> _deleteVoucher(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList('vouchers') ?? [];

    // Remove voucher from list
    storedList.removeAt(index);

    // Save updated list back to SharedPreferences
    await prefs.setStringList('vouchers', storedList);

    // Reload the voucher list after deletion
    _loadVouchers();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList =
        voucherList.where((voucher) {
          final name = voucher['nama']?.toString().toLowerCase() ?? '';
          return name.contains(_searchTerm.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: const AdminAppBar(title: 'Pengaturan Voucher'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/admin/voucher/create');
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
                hintText: 'Cari nama voucher',
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
              child:
                  filteredList.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final voucher = filteredList[index];
                          return _buildVoucherCard(voucher, index);
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/empty_voucher.png', width: 150),
          const SizedBox(height: 16),
          const Text(
            'Voucher kosong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(Map<String, dynamic> voucher, int index) {
    return GestureDetector(
      onTap: () {
        print('Navigating with voucher: $voucher'); // Debugging
        Navigator.pushNamed(
          context,
          '/admin/voucher/edit',
          arguments: {'voucher': voucher},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFE9F6FB), Color(0xFFB5E3F3)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher['nama'] ?? 'Nama Voucher',
                    style: const TextStyle(
                      color: Color(0xFF0070A7),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Potongan Rp ${NumberFormat('#,###', 'id_ID').format(voucher['potongan'] ?? 0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Kode: ${voucher['kode'] ?? '-'}'),
                  const SizedBox(height: 4),
                  Text(
                    'Min. Pembelian: Rp ${NumberFormat('#,###', 'id_ID').format(voucher['minimal_pembelian'] ?? 0)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masa Berlaku ${voucher['mulai_berlaku'] ?? '-'} - ${voucher['akhir_berlaku'] ?? '-'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Image.asset(
              'assets/icon_diskon.png',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus voucher ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteVoucher(index); // Delete voucher
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
