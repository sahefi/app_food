
import 'package:app_makanan/widgets/admin/admin_create_produk.dart';
import 'package:app_makanan/widgets/admin/admin_create_voucher.dart';
import 'package:app_makanan/widgets/admin/admin_edit_produk.dart';
import 'package:app_makanan/widgets/admin/admin_edit_store.dart';
import 'package:app_makanan/widgets/admin/admin_edit_voucher.dart';
import 'package:app_makanan/widgets/admin/admin_home.dart';
import 'package:app_makanan/widgets/admin/admin_list_produk.dart';
import 'package:app_makanan/widgets/admin/admin_list_voucher.dart';
import 'package:app_makanan/widgets/admin/admin_order.dart';
import 'package:app_makanan/widgets/admin/admin_order_detail.dart';
import 'package:app_makanan/widgets/cart_page.dart';
import 'package:app_makanan/widgets/detail_produk_page.dart';
import 'package:app_makanan/widgets/landing_page.dart';
import 'package:app_makanan/widgets/login_page.dart';
import 'package:app_makanan/widgets/order_page.dart';
import 'package:app_makanan/widgets/register_page.dart';
import 'package:app_makanan/widgets/register_toko_page.dart';
import 'package:app_makanan/widgets/user_list_produk.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter binding sudah siap
  await initializeDateFormatting('id_ID', null); // Inisialisasi locale Indonesia

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/regsiter/toko': (context) => RegisterToko(),
        // user
        '/user/home': (context) => LandingPage(),
        '/user/produk': (context) => ListProduk(),
        '/user/detail/produk': (context) => DetailProduk(),
        '/user/cart': (context) => CartPage(),
        '/user/order': (context) => OrderPage(),
        //admin
        '/admin/home': (context) => AdminHome(),
        '/admin/produk': (context) => AdminListProduk(),
        '/admin/produk/create': (context) => TambahProdukPage(),
        '/admin/produk/edit': (context) => EditProdukPage(),
        '/admin/voucher': (context) => AdminListVoucher(),
        '/admin/voucher/create': (context) => TambahVoucherPage(),
        '/admin/voucher/edit': (context) => EditVoucherPage(),
        '/admin/edit/store': (context) => EditStorePage(),
        '/admin/order': (context) => AdminOrderPage(),        
      },
    );
  }
}
