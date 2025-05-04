import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kantin2_ukk/screens/pages/admin/historyAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/page/diskonPage.dart';
import 'package:kantin2_ukk/screens/pages/admin/page/homeAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/page/menuPage.dart';
import 'package:kantin2_ukk/screens/pages/admin/page/profileAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/page/statusAdmin.dart';

class NavbarAdmin extends StatelessWidget {
  const NavbarAdmin({super.key});

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
          //home
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageAdmin()));
            },
            child: SvgPicture.asset(
              'lib/assets/home.svg', 
              color: Colors.white, 
              width: 30,)
          ),
          
          //status 
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const StatusAdmin()));
            },
            child: Icon(Icons.timer_outlined, size: 30, color: Colors.white,),
          ),

          //list menu
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPageAdmin()));
            },
            child: SvgPicture.asset(
              'lib/assets/menu.svg', 
              color: Colors.white,
              width: 35,)
          ),

          //discount
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DiskonAdminPage()));
            },
            child: SvgPicture.asset(
              'lib/assets/discount.svg', 
              color: Colors.white,
              width: 30,)
          ),

          //profile
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileAdmin()));
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
