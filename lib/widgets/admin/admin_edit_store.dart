import 'package:app_makanan/widgets/admin/admin_app_bar.dart';
import 'package:flutter/material.dart';

class EditStorePage extends StatefulWidget {
  const EditStorePage({super.key});

  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  // Controllers to hold the initial values and manage text input
  final TextEditingController _storeNameController = TextEditingController(text: 'Warung Mak Ti');
  final TextEditingController _storeAddressController = TextEditingController(text: 'Jalan raya baru');
  final TextEditingController _storePhoneController = TextEditingController(text: '08123456789');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'Edit Toko Saya'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50, // Adjusts the size of the avatar
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/avatar.jpg', // Path to your image
                      width: 100, // Image width fits the CircleAvatar size
                      height: 100, // Image height fits the CircleAvatar size
                      fit: BoxFit.cover, // Ensures the image fills the circle with no padding
                    ),
                  ),
                ),
                Container(
                  width: 24, // Smaller container size
                  height: 24, // Smaller container size
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 14), // Smaller icon size
                    padding: EdgeInsets.all(4), // Adjust padding to make the button smaller
                    onPressed: () {
                      // logic ganti foto toko
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _storeNameController,
              label: 'Nama toko',
              hint: 'Nama toko',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _storeAddressController,
              label: 'Alamat toko',
              hint: 'Alamat toko',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _storePhoneController,
              label: 'No. Telepon toko',
              hint: 'No. telepon toko',
              keyboardType: TextInputType.phone, // Ensures only numbers are allowed
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // simpan logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0070A7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text, // Default keyboard is text
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
