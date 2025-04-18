import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceModal extends StatelessWidget {
  final Map<String, dynamic> pesanan; // Receive pesanan data

  const InvoiceModal({super.key, required this.pesanan});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currency = NumberFormat('#,##0', 'id_ID'); // To format the currency

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF0070A7), // Primary blue background
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Invoice',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No. Pesanan: ${pesanan['no_pesanan']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Toko: ${pesanan['toko']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Deskripsi: ${pesanan['deskripsi']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Jumlah: ${pesanan['jumlah']} x Rp ${currency.format(pesanan['harga'])}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Harga: Rp ${currency.format(pesanan['harga'] * pesanan['jumlah'])}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Potongan: - Rp ${currency.format(pesanan['potongan'])}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red, // Set text color to red
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Total Pembayaran: Rp ${currency.format((pesanan['harga'] * pesanan['jumlah']) - pesanan['potongan'])}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF0070A7), // Use primary blue for total payment
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the modal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0070A7), // Primary blue button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
