import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:app_makanan/widgets/admin/admin_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // For input formatting

class TambahProdukPage extends StatefulWidget {
  @override
  _TambahProdukPageState createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String _kategori = 'Makanan';
  final List<String> _kategoriList = ['Makanan', 'Minuman', 'Snack', 'Kue'];
  File? _imageFile;

  final _formKey = GlobalKey<FormState>();

  // Formatters for price and stock
  final _hargaFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    String text = newValue.text;
    if (text.isEmpty) return newValue.copyWith(text: '0');
    return newValue.copyWith(text: text.replaceAll(RegExp(r'\D'), ''));
  });

  final _stokFormatter = FilteringTextInputFormatter.digitsOnly;

  Future<void> _simpanProduk() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua informasi produk!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    List<String> produkList = prefs.getStringList('produk') ?? [];

    final newProduk = {
      'foto': _imageFile!.path,
      'rating': 4.8,
      'nama': _namaController.text,
      'harga':
          int.tryParse(_hargaController.text.replaceAll(RegExp(r'\D'), '')) ??
          0,
      'stok': int.tryParse(_stokController.text) ?? 0,
      'deskripsi': _deskripsiController.text,
      'kategori': _kategori,
      'toko': 'Kak rose',
    };

    produkList.add(jsonEncode(newProduk));
    await prefs.setStringList('produk', produkList);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Produk berhasil disimpan!')));

    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushNamed(context, '/admin/produk');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Tambah Produk'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Produk',
                style: TextStyle(color: Colors.blue),
              ),
              const SizedBox(height: 8),

              // Gambar Produk
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _imageFile == null
                        ? const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _pickImage,
                  child: const Text(
                    'Tambah Foto',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Text Fields for Product Info with Validation
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items:
                    _kategoriList.map((kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori,
                        child: Text(kategori),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _kategori = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  prefixText: 'Rp ', // Adds 'Rp' as a prefix
                ),
                inputFormatters: [_hargaFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value.replaceAll(RegExp(r'\D'), '')) ==
                      null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stok'),
                inputFormatters: [_stokFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bagian Informasi Lainnya (warna latar belakang biru)
              SizedBox(
                width: double.infinity, // Make the button full width
                child: ElevatedButton(
                  onPressed: _simpanProduk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0070A7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Simpan Produk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
