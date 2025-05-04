import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kantin2_ukk/provider/cartProvider.dart';
import 'package:kantin2_ukk/screens/pages/siswa/cartPage.dart';
import 'package:kantin2_ukk/screens/pages/siswa/historyListTran.dart';
//import 'package:kantin2_ukk/screens/pages/siswa/historySiswa.dart';
import 'package:kantin2_ukk/screens/pages/siswa/homeSiswa.dart';
import 'package:kantin2_ukk/screens/pages/siswa/profileSiswa.dart';
import 'package:provider/provider.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color:  Color(0xffA73931),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ) 
      ),
      
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageSiswa()));
            },
            child: SvgPicture.asset(
              'lib/assets/home.svg', 
              color: Colors.white, 
              width: 30,)
          ),
          
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryListTran()));
            },
            child: SvgPicture.asset(
              'lib/assets/history.svg', 
              color: Colors.white, 
              width: 30,)
          ),

          Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
          int cartCount = cartProvider.totalItems; // getter ini harus ada di CartProvider kamu

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 30, color: Colors.white),
          if (cartCount > 0)
            Positioned(
              right: -5,
              top: -7,
              
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$cartCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  },
),

          
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Profilesiswa()));
            },
            child: SvgPicture.asset(
              'lib/assets/user.svg', 
              color: Colors.white,
              width: 30,)
          ),
        ],
      ),
    );
  }
}