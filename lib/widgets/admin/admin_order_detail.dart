import 'package:app_makanan/widgets/invoice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOrderDetail extends StatelessWidget {
  final Map<String, dynamic> pesanan;

  const AdminOrderDetail({super.key, required this.pesanan});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currency = NumberFormat('#,##0', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "No. Pesanan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    pesanan['no_pesanan'] ?? 'BNT/23/11/2024',
                    style: const TextStyle(
                      color: Color(0xFF0070A7),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daftar Pesanan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          pesanan['foto'],
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [                            
                            Text(pesanan['nama']),
                            Text(
                              '${pesanan['jumlah']} x Rp ${currency.format(pesanan['harga'])}',
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rp ${currency.format(pesanan['harga'])}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        pesanan['status'] == "Selesai"
                            ? Icons.check_circle
                            : pesanan['status'] == "Dikirim"
                            ? Icons.local_shipping
                            : Icons.cancel,
                        color:
                            pesanan['status'] == "Selesai"
                                ? Colors.green
                                : pesanan['status'] == "Dikirim"
                                ? Colors.orange
                                : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pesanan['status'],
                        style: TextStyle(
                          color:
                              pesanan['status'] == "Selesai"
                                  ? Colors.green
                                  : pesanan['status'] == "Dikirim"
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      const Spacer(),
                      if (pesanan['status'] == "Selesai")
                        TextButton(
                          onPressed: () {
                            // Show the invoice modal with pesanan data
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return InvoiceModal(
                                  pesanan: pesanan,
                                ); // Pass pesanan data
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Set the background color to primary blue
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.download,
                                color: Color(
                                  0xFF0070A7,
                                ), // Set the icon color to primary blue
                              ),
                              SizedBox(
                                width: 6,
                              ), // Add space between icon and text
                             Text(
                                "Unduh Invoice",
                                style: const TextStyle(
                                  color: Color(
                                    0xFF0070A7,
                                  ), // Set the text color to the primary blue
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total harga"),
                      Text(
                        'Rp ${currency.format(pesanan['harga'] * pesanan['jumlah'])}',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Promo Digunakan"),
                      Text(
                        '- Rp ${currency.format(pesanan['potongan'])}',
                        style: const TextStyle(
                          color: Colors.red,
                        ), // Add styling if needed
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Belanja",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${currency.format(pesanan['harga'] * pesanan['jumlah'] - pesanan['potongan'])}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ), // Spacer biar gak ketutup bottomNavigationBar
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pesanan['status'] == 'Dikirim')
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Konfirmasi pesanan diterima
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0070A7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Konfirmasi Pengiriman",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),            
          ],
        ),
      ),
    );
  }
}
