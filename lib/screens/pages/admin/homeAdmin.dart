import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/admin/homeAdminContent.dart';
import 'package:kantin2_ukk/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  String? userRole;
  String? userName;
  String? makerId;
  

  @override
  void initState(){
    super.initState();
    checkAuthentication();
  }

  Future <void> checkAuthentication() async{
    final prefs = await SharedPreferences.getInstance();
    final apiService = Apiservices();
    final stanList = await apiService.getStan();
    

    if (stanList.isEmpty){
      print("stanList kosong, redirect ke login.");
      
      if (mounted){
        Navigator.pushReplacementNamed(context, "/login");
      }
      return;
    }

    if (mounted){
      setState(() {
        userRole = "Admin";
        userName = stanList [0]["nama_stan"] ?? "Kantin";
        makerId = prefs.getString("makerID");

        prefs.setString("username", userName!);
        prefs.setInt("id_user", stanList[0]["id"]);

        print("Data berhasil disimpan: $userName, ${stanList[0]["id"]}");


        print(stanList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          children: const [
            HomeAdminContent()
          ],
        ),
      ),);   
  }
}