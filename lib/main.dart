import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kantin2_ukk/screens/pages/admin/page/homeAdmin.dart';
import 'package:kantin2_ukk/screens/pages/siswa/homeSiswa.dart';
import 'package:kantin2_ukk/screens/pages/loginPage.dart';
import 'package:kantin2_ukk/provider/cartProvider.dart'; // import ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/homeSiswa': (context) => const HomePageSiswa(),
          '/homeAdmin': (context) => const HomePageAdmin(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
