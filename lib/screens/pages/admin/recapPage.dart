import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/admin/rekapOrderAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/rekapPemasukanAdmin.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
                  backgroundColor:  const Color(0xffD74339),
                  foregroundColor: Colors.white
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RekapOrderAdmin()));
                }, 
                  child: const Text(
                    "Rekap Order",
                      style:  TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500            
                      ),
                    ),  
                  ),

              ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
                  backgroundColor:  const Color(0xffD74339),
                  foregroundColor: Colors.white
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RekapPemasukanStan()));
                }, 
                  child: const Text(
                    "Rekap Pemasukan",
                      style:  TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500            
                      ),
                    ),  
                  ),


          ],
        ),
      ),
    );
  }
}