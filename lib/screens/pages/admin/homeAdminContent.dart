import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/screens/components/helloAdmin.dart';
import 'package:kantin2_ukk/screens/components/orderBox.dart';
import 'package:kantin2_ukk/screens/components/pemasukanAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/editStan.dart';
import 'package:kantin2_ukk/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdminContent extends StatefulWidget {
  const HomeAdminContent({super.key});

  @override
  State<HomeAdminContent> createState() => _HomeAdminContentState();
}

class _HomeAdminContentState extends State<HomeAdminContent> {
  String kantinName = 'Loading...';
  int _pemasukan = 0;
  List<Map<String,dynamic>> _stanList = [];
  int _countOrderBelum = 0;
  final int _countOrderSelesai = 0;


  @override
  void initState(){

  }

  Future <void> loadAdminData() async{
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? "Kantin";
    final apiService = Apiservices();

    final List<Map<String,dynamic>> stanList = List<Map<String,dynamic>>.from(await apiService.getStan());

    setState(() {
      _stanList = stanList;
      kantinName = stanList.isNotEmpty
        ? stanList [0]["nama_pemilik"] ?? username
        : username;
    });
  }

  String getCurrentMonth(){
    final now = DateTime.now();
    return DateFormat('yyyy-MM').format(now);
  }

  Future <void> fetchPemasukan () async {
    final apiService = Apiservices();
    String bulanIni = getCurrentMonth();
    final PemasukanList = await apiService.getPemasukan(bulanIni);

    if (PemasukanList.isNotEmpty){
      int totalPemasukan = 0;

      for (var item in PemasukanList){
        if (item is Map<String,dynamic> && item.containsKey("total_pemasukan")){
          totalPemasukan += int.tryParse(item["total_pemasukan"].toString()) ?? 0;
        }
      }

      setState(() {
        _pemasukan = totalPemasukan;
      });
    }
  }

  Future<void> logout()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted){
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  void _editStan() async {
    if (_stanList.isNotEmpty){
      final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Editstan(stanData: _stanList[0])));
    }
  }


  Future <void> _fetchOrderBelum() async{
    final orderList = await Apiservices().getOrderAdminBelum();
    setState(() {
      _countOrderBelum = 0;
    });
  }

  Future<void> _fetchOrderSelesai() async{
    final orderList = await Apiservices().getOrderAdminSelesai();
    setState(() {
      _countOrderSelesai;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = "Hello, ${kantinName[0].toUpperCase()}${kantinName.substring(1)}";
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelloAdmin(
                kantin: displayName, 
                icon: Icons.person, 
                iconColor: const Color(0xffD74339),
                onEdit: _editStan,
              ),
              const SizedBox(height: 16),
              OrderBox(running: _countOrderBelum, request: _countOrderSelesai),
              const SizedBox(height: 16),
              Pemasukan(penghasilan: _pemasukan),
              const SizedBox(height: 34,),
              const Text("Histori Transaksi"),
              const SizedBox(height: 12,)
              

            ],
          ),
        ),
      ),
    );
  }
}