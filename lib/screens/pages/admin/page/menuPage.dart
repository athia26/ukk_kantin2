import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kantin2_ukk/screens/pages/admin/addMenu.dart';
import 'package:kantin2_ukk/screens/pages/admin/menuListAdmin.dart';

class MenuPageAdmin extends StatefulWidget {
  const MenuPageAdmin({super.key});

  @override
  State<MenuPageAdmin> createState() => _MenuPageAdminState();
}

class _MenuPageAdminState extends State<MenuPageAdmin> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded)
                        ),
    
                        const Text(
                          "Daftar Makanan",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    
                    IconButton(
                      onPressed: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => const AddMenu()
                            )
                          );
                      }, 
                      icon: SvgPicture.asset(
                        'lib/assets/addplus.svg', 
                        color: Colors.black,
                        width: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    
            const TabBar(
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.red,
              tabs: [
                Tab(text: "Semua"),
                Tab(text: "Makanan"),
                Tab(text: "Minuman"),
              ],
            ),
    
            const Expanded(
              child: TabBarView(
                children: [
                  MenuListAdmin(),
                  MenuListAdmin(category: "makanan"),
                  MenuListAdmin(category: "minuman"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 