import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kantin2_ukk/screens/pages/siswa/historySiswa.dart';
import 'package:kantin2_ukk/screens/pages/siswa/homeSiswa.dart';
import 'package:kantin2_ukk/screens/pages/siswa/profileSiswa.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Historysiswa()));
            },
            child: SvgPicture.asset(
              'lib/assets/history.svg', 
              color: Colors.white, 
              width: 30,)
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