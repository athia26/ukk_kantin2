import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/siswa/homeSiswa.dart';
import 'package:kantin2_ukk/screens/pages/loginPage.dart';
import 'package:kantin2_ukk/screens/pages/signupPage.dart';
import 'package:kantin2_ukk/screens/components/cardStan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePageSiswa(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomePageSiswa(),
    );
  }
}
