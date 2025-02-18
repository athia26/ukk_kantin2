import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Navbar({super.key, 
    required this.currentIndex,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda', 
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_rounded),
          label: 'Riwayat'),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        )
      ]
    );
  }
}