import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/widget/bottomNavbar.dart';
import 'package:kantin2_ukk/screens/widget/card_stan.dart';

class HomePageSiswa extends StatefulWidget {
  const HomePageSiswa({super.key});

  @override
  State<HomePageSiswa> createState() => _HomePageSiswaState();
}

class _HomePageSiswaState extends State<HomePageSiswa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            const Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text("Hello User!", 
              style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 35,
                              fontWeight: FontWeight.w700
                            ),),
            ),
            SizedBox(height: 20,),
            
            //search bar
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Mau makan apa hari ini?",
                    hintStyle: TextStyle(
                      color: Color(0xffD74339),
                                  fontFamily: 'Outfit',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    print("searching for $query");
                  },
                ),
              ),
            ),
      
            SizedBox(height: 20,),
            const Padding(
              padding:  EdgeInsets.only(left: 15.0),
              child:  Text("Pilih stan",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                ),
              ),
            ),
            
            SizedBox(
              height: MediaQuery.of(context).size.height *0.7,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CardStan(),
              ))
      
          ],
        ),

        
      ),

      bottomNavigationBar: const BottomNavbar(),
    );
  }
}