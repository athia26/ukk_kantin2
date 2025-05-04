import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/screens/components/helloAdmin.dart';
import 'package:kantin2_ukk/screens/components/orderBox.dart';
import 'package:kantin2_ukk/screens/components/pemasukanAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/editStan.dart';
import 'package:kantin2_ukk/screens/pages/admin/historyAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/page/siswaAdminPage.dart';
import 'package:kantin2_ukk/screens/pages/admin/rekapOrderAdmin.dart';
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
  int _countOrderSelesai = 0;


  @override
  void initState(){
    super.initState();
    loadAdminData();
    fetchPemasukan();
    _fetchOrderBelum();
    _fetchOrderSelesai();
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
    print("order belum: $orderList");
    setState(() {
      _countOrderBelum = orderList.length;
    });
  }

  Future<void> _fetchOrderSelesai() async{
    final orderList = await Apiservices().getOrderAdminSelesai();
    setState(() {
      _countOrderSelesai = orderList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = "Halo, ${kantinName.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ')}";

    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                
                child: Row(
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                    ),

                    const Spacer(),
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SiswaAdminPage()));
                      }, 
                      icon: Icon(
                        Icons.person_add_alt_1_rounded, 
                        color: Color(0xffD74339),
                      )
                    )
                  ],
                ),

                
              ),
              const SizedBox(height: 16),
              OrderBox(running: _countOrderBelum, request: _countOrderSelesai),
              const SizedBox(height: 16),
              Pemasukan(penghasilan: _pemasukan),
              const SizedBox(height: 34,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text("Histori Transaksi", 
                      style:  const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color:Color(0xffD74339),
                            ),
                          ),
                  InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RekapOrderAdmin()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:  Color(0xffD74339),
                      
                    ),
                    child: const Row(
                      children: [
                        const Text(
                          "Lihat Rekap ",
                          style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                            ),
                        ),

                        Icon(Icons.arrow_forward_ios_rounded, 
                        color: Colors.white,
                        size: 10,)
                      ],
                    ),
                  ),
                )
                ],
              ),
              const SizedBox(height: 12,),
              HistoryAdmin()

            ],
          ),
        ),
      ),
    );
  }
}