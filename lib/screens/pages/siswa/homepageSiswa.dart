import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/siswa/historySiswa.dart';
import 'package:kantin2_ukk/screens/pages/siswa/homeSiswa.dart';
import 'package:kantin2_ukk/screens/pages/siswa/profileSiswa.dart';
import 'package:kantin2_ukk/screens/widget/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    HomePageSiswa(),
    Historysiswa(),
    Profilesiswa(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _pages [currentIndex]),
          
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          print('Tab index: $index');
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda'
          ),

          BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_rounded),
          label: 'Riwayat'),

          BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        )
        ],
      )
    );
  }
}