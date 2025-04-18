import 'dart:convert';
import 'package:app_makanan/widgets/admin/admin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahVoucherPage extends StatefulWidget {
  const TambahVoucherPage({super.key});

  @override
  State<TambahVoucherPage> createState() => _TambahVoucherPageState();
}

class _TambahVoucherPageState extends State<TambahVoucherPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _mulaiController = TextEditingController();
  final TextEditingController _akhirController = TextEditingController();
  final TextEditingController _minimalController = TextEditingController();
  final TextEditingController _potonganController = TextEditingController();

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  Future<void> _simpanVoucher() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      List<String> vouchers = prefs.getStringList('vouchers') ?? [];

      final voucher = {
        'nama': _namaController.text,
        'kode': _kodeController.text,
        'mulai_berlaku': _mulaiController.text,
        'akhir_berlaku': _akhirController.text,
        'minimal_pembelian': int.tryParse(_minimalController.text) ?? 0,
        'potongan': int.tryParse(_potonganController.text) ?? 0,
      };

      vouchers.add(jsonEncode(voucher));
      await prefs.setStringList('vouchers', vouchers);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voucher berhasil disimpan!')),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pushNamed(context, '/admin/voucher');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Tambah Voucher'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Voucher
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Voucher',
                    hintText: 'Masukkan nama voucher',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama voucher wajib diisi' : null,
                ),
                const SizedBox(height: 10),

                // Kode Voucher
                TextFormField(
                  controller: _kodeController,
                  decoration: const InputDecoration(
                    labelText: 'Kode Voucher',
                    hintText: 'Masukkan kode voucher',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Kode voucher wajib diisi' : null,
                ),
                const SizedBox(height: 10),

                // Tanggal Mulai & Akhir
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _mulaiController,
                        readOnly: true,
                        onTap: () => _selectDate(_mulaiController),
                        decoration: const InputDecoration(
                          labelText: 'Mulai Berlaku',
                          hintText: 'Mulai berlaku',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Pilih tanggal mulai' : null,
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
                          hintText: 'Akhir berlaku',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Pilih tanggal akhir' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Minimal Pembelian
                TextFormField(
                  controller: _minimalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Minimal Pembelian',
                    prefixText: 'Rp ',
                    hintText: 'Masukkan minimal pembelian',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 10),

                // Potongan
                TextFormField(
                  controller: _potonganController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Potongan',
                    prefixText: 'Rp ',
                    hintText: 'Masukkan maksimal potongan',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),

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
                    child: const Text('Simpan Voucher'),
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
