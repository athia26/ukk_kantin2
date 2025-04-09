import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/admin/homeAdmin.dart';
import 'package:kantin2_ukk/screens/pages/siswa/homeSiswa.dart';
import 'package:kantin2_ukk/screens/pages/loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: '/login',
      routes: {
        
        '/login': (context) => const LoginPage(),
        '/homeSiswa': (context) => const HomePageSiswa(),
        '/homeAdmin': (context) => const HomePageAdmin(),
      },
      debugShowCheckedModeBanner: false,
      
    );
  }
}
