import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditVoucherPage extends StatefulWidget {
  @override
  _EditVoucherPageState createState() => _EditVoucherPageState();
}

class _EditVoucherPageState extends State<EditVoucherPage> {
  final _namaController = TextEditingController();
  final _kodeController = TextEditingController();
  final _mulaiController = TextEditingController();
  final _akhirController = TextEditingController();
  final _minimalController = TextEditingController();
  final _potonganController = TextEditingController();

  Map<String, dynamic>? _voucher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments != null && arguments is Map<String, dynamic>) {
      final voucher = arguments['voucher'] as Map<String, dynamic>?;
      if (voucher != null) {
        _voucher = voucher;
        _namaController.text = voucher['nama'] ?? '';
        _kodeController.text = voucher['kode'] ?? '';
        _mulaiController.text = voucher['mulai_berlaku'] ?? '';
        _akhirController.text = voucher['akhir_berlaku'] ?? '';
        _minimalController.text =
            (voucher['minimal_pembelian'] ?? 0).toString();
        _potonganController.text = (voucher['potongan'] ?? 0).toString();
      }
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  Future<void> _simpanVoucher() async {
    if (_voucher == null) return;

    final updatedVoucher = {
      'nama': _namaController.text,
      'kode': _kodeController.text,
      'mulai_berlaku': _mulaiController.text,
      'akhir_berlaku': _akhirController.text,
      'minimal_pembelian': int.tryParse(_minimalController.text) ?? 0,
      'potongan': int.tryParse(_potonganController.text) ?? 0,
    };

    final prefs = await SharedPreferences.getInstance();
    List<String> voucherList = prefs.getStringList('vouchers') ?? [];

    for (int i = 0; i < voucherList.length; i++) {
      final decodedVoucher = jsonDecode(voucherList[i]) as Map<String, dynamic>;
      if (decodedVoucher['kode'] == _voucher!['kode']) {
        voucherList[i] = jsonEncode(updatedVoucher);
        break;
      }
    }

    await prefs.setStringList('vouchers', voucherList);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voucher berhasil diperbarui!')),
    );

    Navigator.pushNamed(context, '/admin/voucher');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Voucher')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Voucher',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 8),

            // Text Fields for Voucher Info with Validation
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Voucher'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _kodeController,
              decoration: const InputDecoration(labelText: 'Kode Voucher'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _mulaiController,
                    readOnly: true,
                    onTap: () => _selectDate(_mulaiController),
                    decoration: const InputDecoration(
                      labelText: 'Mulai Berlaku',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _akhirController,
                    readOnly: true,
                    onTap: () => _selectDate(_akhirController),
                    decoration: const InputDecoration(
                      labelText: 'Akhir Berlaku',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _minimalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Minimal Pembelian'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _potonganController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Potongan'),
            ),
            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _simpanVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0070A7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
