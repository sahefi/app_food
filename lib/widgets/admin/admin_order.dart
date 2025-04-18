import 'package:app_makanan/data/data_pesanan.dart';
import 'package:app_makanan/widgets/admin/admin_order_detail.dart';
import 'package:app_makanan/widgets/order-detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AdminOrderPage extends StatefulWidget {
  const AdminOrderPage({super.key});

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> getAvailableMonths() {
    final months =
        pesananList
            .map((p) {
              // Parse tanggal dengan format yyyy/MM/dd
              DateTime date = DateFormat(
                'yyyy/MM/dd',
              ).parse(p['tanggal_order']);
              // Format tanggal menjadi 'MMMM yyyy' dengan locale Indonesia
              return DateFormat('MMMM yyyy', 'id_ID').format(date);
            })
            .toSet() // Hanya mengambil tanggal unik
            .toList();

    // Mengurutkan bulan dari yang terbaru
    months.sort((a, b) => b.compareTo(a));

    return months;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('Dikirim'),
          _buildOrderList('Selesai'),
          _buildOrderList('Dibatalkan'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/empty.png', height: 100, width: 100),
          const SizedBox(height: 20),
          Text(
            'Belum ada pesanan $status',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    final availableMonths = getAvailableMonths();

    final filteredOrders =
        pesananList.where((pesanan) {
          final matchesStatus = pesanan['status'] == status;

          // Memastikan format tanggal sesuai dengan 'yyyy/MM/dd'
          final date = DateFormat('yyyy/MM/dd').parse(pesanan['tanggal_order']);

          final matchesMonth =
              selectedMonth == null ||
              DateFormat('MMMM yyyy', 'id_ID').format(date) == selectedMonth;

          return matchesStatus && matchesMonth;
        }).toList();

    return Column(
      children: [
        if (availableMonths.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: GestureDetector(
              onTap: _selectMonth,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedMonth ?? 'Pilih Bulan',
                        style: const TextStyle(fontSize: 16),
                        overflow:
                            TextOverflow
                                .ellipsis, // Menghindari teks yang terlalu panjang
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ), // Memberi jarak antara teks dan ikon
                    const Icon(Icons.calendar_today),
                    if (selectedMonth != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMonth = null; // Clear the selected month
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ), // Padding kiri
                          child: const Icon(
                            Icons.clear,
                            color: Colors.red, // Warna merah
                            size: 20, // Ukuran kecil
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 12),

        if (filteredOrders.isEmpty)
          Expanded(child: _buildEmptyState(status))
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final pesanan = filteredOrders[index];
                return _buildOrderCard(pesanan);
              },
            ),
          ),
      ],
    );
  }

  void _selectMonth() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        selectedMonth = DateFormat('MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  Widget _buildOrderCard(Map<String, dynamic> pesanan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(pesanan['foto'], fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pesanan['nama'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pesanan['jumlah']} x Rp ${NumberFormat('#,##0', 'id_ID').format(pesanan['harga'])}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                'Rp ${NumberFormat('#,##0', 'id_ID').format(pesanan['harga'])}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pesanan'),
              Text(
                'Rp ${NumberFormat('#,##0', 'id_ID').format(pesanan['harga'])}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                pesanan['status'] == 'Selesai'
                    ? Icons.check_circle
                    : pesanan['status'] == 'Dikirim'
                    ? Icons.local_shipping
                    : Icons.cancel,
                color:
                    pesanan['status'] == 'Selesai'
                        ? Colors.green
                        : pesanan['status'] == 'Dikirim'
                        ? Colors.orange
                        : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                pesanan['status'],
                style: TextStyle(
                  color:
                      pesanan['status'] == 'Selesai'
                          ? Colors.green
                          : pesanan['status'] == 'Dikirim'
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminOrderDetail(pesanan: pesanan),
                    ),
                  );
                },
                child: const Text('Detail Pesanan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[700],
                  side: BorderSide(color: Colors.blue[700]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
