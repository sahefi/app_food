import 'dart:convert';
import 'package:app_makanan/widgets/app_bar.dart';
import 'package:app_makanan/widgets/checkout_payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simulasikan list voucher di file ini (atau import jika di file terpisah)
final List<Map<String, dynamic>> voucherList = [
  {
    'nama': 'Voucher Merah',
    'potongan': 25000,
    'kode': 'VMERAH2025',
    'mulai_berlaku': '01/05/2025',
    'akhir_berlaku': '31/05/2025',
    'minimal_pembelian': 100000,
  },
  {
    'nama': 'Voucher Biru',
    'potongan': 50000,
    'kode': 'VBI2025',
    'mulai_berlaku': '01/06/2025',
    'akhir_berlaku': '30/06/2025',
    'minimal_pembelian': 150000,
  },
  {
    'nama': 'Voucher Hijau',
    'potongan': 100000,
    'kode': 'VHIDUP2025',
    'mulai_berlaku': '01/07/2025',
    'akhir_berlaku': '31/07/2025',
    'minimal_pembelian': 200000,
  },
  {
    'nama': 'Voucher Emas',
    'potongan': 75000,
    'kode': 'VEMAS2025',
    'mulai_berlaku': '01/08/2025',
    'akhir_berlaku': '31/08/2025',
    'minimal_pembelian': 300000,
  },
];

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, List<Map<String, dynamic>>> groupedItems = {};
  int totalHarga = 0;
  int totalSelected = 0;
  bool selectAll = false;
  Map<String, dynamic>? selectedVoucher;
  int totalSebelumDiskon = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartStrings = prefs.getStringList('cart') ?? [];

    List<Map<String, dynamic>> allItems =
        cartStrings
            .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
            .toList();

    for (var item in allItems) {
      item['checked'] = item['checked'] ?? false;
    }

    Map<String, Map<String, Map<String, dynamic>>> mergedMap = {};
    for (var item in allItems) {
      String toko = item['toko'];
      String nama = item['nama'];

      if (!mergedMap.containsKey(toko)) {
        mergedMap[toko] = {};
      }

      if (mergedMap[toko]!.containsKey(nama)) {
        mergedMap[toko]![nama]!['jumlah'] += item['jumlah'];
      } else {
        mergedMap[toko]![nama] = Map<String, dynamic>.from(item);
      }
    }

    Map<String, List<Map<String, dynamic>>> grouped = {};
    mergedMap.forEach((toko, itemsMap) {
      grouped[toko] = itemsMap.values.toList();
    });

    setState(() {
      groupedItems = grouped;
      _updateTotals();
    });
  }

  void _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> allItems = [];

    groupedItems.forEach((_, items) {
      allItems.addAll(items);
    });

    List<String> cartStrings = allItems.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList('cart', cartStrings);
  }

  void _updateTotals() {
    int total = 0;
    int count = 0;

    for (var tokoItems in groupedItems.values) {
      for (var item in tokoItems) {
        if (item['checked']) {
          total += (item['harga'] as int) * (item['jumlah'] as int);
          count++;
        }
      }
    }

    int totalSetelahDiskon = total;
    if (selectedVoucher != null &&
        total >= selectedVoucher!['minimal_pembelian']) {
      totalSetelahDiskon -= selectedVoucher!['potongan'] as int;
      if (totalSetelahDiskon < 0) totalSetelahDiskon = 0;
    }

    setState(() {
      totalSebelumDiskon = total;
      totalHarga = totalSetelahDiskon;
      totalSelected = count;
    });
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      for (var tokoItems in groupedItems.values) {
        for (var item in tokoItems) {
          item['checked'] = selectAll;
        }
      }
      _updateTotals();
      _saveCartItems();
    });
  }

  void _toggleItemCheck(String toko, int index) {
    setState(() {
      groupedItems[toko]![index]['checked'] =
          !(groupedItems[toko]![index]['checked'] ?? false);
      _updateTotals();
      _saveCartItems();
    });
  }

  void _changeQty(String toko, int index, int delta) {
    setState(() {
      final item = groupedItems[toko]![index];
      int currentQty = item['jumlah'];
      int newQty = currentQty + delta;
      if (newQty >= 1) {
        item['jumlah'] = newQty;
        item['subtotal'] = newQty * item['harga'];
        _updateTotals();
        _saveCartItems();
      }
    });
  }

  void _removeItem(String toko, int index) async {
    setState(() {
      groupedItems[toko]!.removeAt(index);
      if (groupedItems[toko]!.isEmpty) {
        groupedItems.remove(toko);
      }
      _updateTotals();
      _saveCartItems();
    });
  }

  void _showVoucherModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Pakai Voucher Sekarang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedVoucher = null;
                  });
                  _updateTotals();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Hapus Voucher",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: voucherList.length,
                  itemBuilder: (context, index) {
                    final voucher = voucherList[index];
                    final isEligible =
                        totalHarga + // tambahkan kembali diskon sebelumnya kalau ada
                            (selectedVoucher != null
                                ? selectedVoucher!['potongan']
                                : 0) >=
                        voucher['minimal_pembelian'];

                    return ListTile(
                      title: Text(voucher['nama']),
                      subtitle: Text(
                        'Min. pembelian: Rp ${voucher['minimal_pembelian']} - Potongan: Rp ${voucher['potongan']}',
                      ),
                      trailing:
                          isEligible
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                              : const Icon(Icons.cancel, color: Colors.grey),
                      tileColor:
                          selectedVoucher == voucher
                              ? Colors.blue.shade100
                              : null, // Menambahkan background biru muda
                      onTap:
                          isEligible
                              ? () {
                                setState(() {
                                  selectedVoucher = voucher;
                                });
                                _updateTotals();
                                Navigator.pop(context);
                              }
                              : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Keranjang'),
            leading: const BackButton(),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                groupedItems.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/empty_cart.png', // ganti path sesuai gambar kamu
                            width: 180,
                            height: 180,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Oops! Keranjang Belanjamu Kosong',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              'Ketika menemukan produk favorit. Anda bisa menambahkannya disini.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0070A7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/user/home');
                            },
                            child: const Text(
                              'Mulai Belanja',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView(
                      children:
                          groupedItems.entries.map((entry) {
                            String toko = entry.key;
                            List<Map<String, dynamic>> items = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Color(
                                            0xFF0070A7,
                                          ),
                                        ),
                                        child: Checkbox(
                                          value: items.every(
                                            (e) => e['checked'],
                                          ),
                                          activeColor: Color(0xFF0070A7),
                                          onChanged: (val) {
                                            setState(() {
                                              for (var item in items) {
                                                item['checked'] = val ?? false;
                                              }
                                              _updateTotals();
                                              _saveCartItems();
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        toko,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...items.asMap().entries.map((entryItem) {
                                  int index = entryItem.key;
                                  var item = entryItem.value;

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    leading: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor: Color(
                                              0xFF0070A7,
                                            ),
                                          ),
                                          child: Checkbox(
                                            value: item['checked'],
                                            activeColor: Color(0xFF0070A7),
                                            onChanged:
                                                (_) => _toggleItemCheck(
                                                  toko,
                                                  index,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Image.asset(
                                          item['foto'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                    title: Text(item['nama']),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Rp ${item['harga']}'),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed:
                                                  () => _changeQty(
                                                    toko,
                                                    index,
                                                    -1,
                                                  ),
                                            ),
                                            Text(item['jumlah'].toString()),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed:
                                                  () => _changeQty(
                                                    toko,
                                                    index,
                                                    1,
                                                  ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed:
                                                  () =>
                                                      _removeItem(toko, index),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            );
                          }).toList(),
                    ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (totalSelected > 0 && selectedVoucher != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total Sebelum Diskon: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(totalSebelumDiskon)}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'Voucher (${selectedVoucher!['nama']}): -${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(selectedVoucher!['potongan'])}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),

                if (totalSelected > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0070A7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.card_giftcard),
                      label: Text(
                        selectedVoucher != null
                            ? 'Voucher: ${selectedVoucher!['nama']}'
                            : 'Pilih Voucher',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _showVoucherModal,
                    ),
                  ),

                Row(
                  children: [
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(unselectedWidgetColor: Color(0xFF0070A7)),
                      child: Checkbox(
                        value: selectAll,
                        activeColor: Color(0xFF0070A7),
                        onChanged: _toggleSelectAll,
                      ),
                    ),
                    const Text('Pilih Semua'),
                    const Spacer(),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(totalHarga),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0070A7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed:
                          totalSelected > 0
                              ? () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                List<String> cartStrings =
                                    prefs.getStringList('cart') ?? [];
                                List<Map<String, dynamic>> allItems =
                                    cartStrings
                                        .map(
                                          (e) => Map<String, dynamic>.from(
                                            jsonDecode(e),
                                          ),
                                        )
                                        .toList();

                                // Filter item yang tidak dicentang (biarkan tetap di cart)
                                List<Map<String, dynamic>> itemsToKeep = [];
                                for (var item in allItems) {
                                  String nama = item['nama'];
                                  String toko = item['toko'];
                                  bool isChecked = false;

                                  if (groupedItems.containsKey(toko)) {
                                    final matchedItem = groupedItems[toko]!
                                        .firstWhere(
                                          (e) => e['nama'] == nama,
                                          orElse: () => {},
                                        );
                                    isChecked =
                                        matchedItem.isNotEmpty
                                            ? matchedItem['checked'] ?? false
                                            : false;
                                  }

                                  if (!isChecked) {
                                    itemsToKeep.add(item);
                                  }
                                }

                                // Simpan cart yang sudah difilter
                                List<String> newCartStrings =
                                    itemsToKeep
                                        .map((e) => jsonEncode(e))
                                        .toList();
                                await prefs.setStringList(
                                  'cart',
                                  newCartStrings,
                                );

                                // SIMPAN nilai total sebelum setState
                                final int finalTotal = totalHarga;

                                // Kosongkan pilihan & refresh state
                                setState(() {
                                  groupedItems.removeWhere(
                                    (_, items) => items.any(
                                      (item) => item['checked'] == true,
                                    ),
                                  );
                                  selectedVoucher = null;
                                  selectAll = false;
                                  _updateTotals();
                                });

                                // Pindah ke halaman CheckoutPayment setelah setState
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CheckoutPayment(
                                          subtotal: finalTotal,
                                        ),
                                  ),
                                );
                              }
                              : null,
                      child: Text(
                        'Checkout ($totalSelected)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
