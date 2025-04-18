import 'dart:convert';
import 'package:app_makanan/widgets/admin/admin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProdukPage extends StatefulWidget {
  @override
  _EditProdukPageState createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String _kategori = 'Makanan';
  final List<String> _kategoriList = ['Makanan', 'Minuman', 'Snack', 'Kue'];
  File? _imageFile;

  Map<String, dynamic>? _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the product passed as an argument from the list page
    _product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (_product != null) {
      _namaController.text = _product!['nama'];
      _hargaController.text = _product!['harga'].toString();
      _stokController.text = _product!['stok'].toString();
      _deskripsiController.text = _product!['deskripsi'];
      _kategori = _product!['kategori'];
      _imageFile = File(_product!['foto']);
    }
  }

  Future<void> _simpanProduk() async {
  if (_product == null) return; // Ensure we have the product data

  final updatedProduct = {
    'foto': _imageFile?.path ?? _product!['foto'],
    'rating': _product!['rating'],
    'nama': _namaController.text,
    'harga':
        int.tryParse(_hargaController.text.replaceAll(RegExp(r'\D'), '')) ?? 0,
    'stok': int.tryParse(_stokController.text) ?? 0,
    'deskripsi': _deskripsiController.text,
    'kategori': _kategori,
    'toko': _product!['toko'],
  };

  final prefs = await SharedPreferences.getInstance();
  List<String> produkList = prefs.getStringList('produk') ?? [];

  // Find and update the product in the list
  for (int i = 0; i < produkList.length; i++) {
    final decodedProduk = jsonDecode(produkList[i]) as Map<String, dynamic>;
    if (decodedProduk['nama'] == _product!['nama']) {
      produkList[i] = jsonEncode(updatedProduct);
      break;
    }
  }

  // Save updated list back to SharedPreferences
  await prefs.setStringList('produk', produkList);

  // Pastikan widget masih mounted sebelum akses context
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Produk berhasil diperbarui!')),
  );

  // Tunggu 500ms agar SnackBar sempat muncul
  await Future.delayed(const Duration(milliseconds: 500));

  if (!mounted) return;

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
      appBar: const AdminAppBar(title: 'Edit Produk '),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Produk',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 8),

            // Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  _imageFile == null
                      ? const Center(
                        child: Icon(Icons.image, size: 40, color: Colors.grey),
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
                  'Ganti Foto',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Text Fields for Product Info with Validation
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
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
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _stokController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stok'),
            ),
            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
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
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
