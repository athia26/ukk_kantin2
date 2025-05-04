import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/components/orderCard.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class StatusAdmin extends StatefulWidget {
  const StatusAdmin({super.key});

  @override
  State<StatusAdmin> createState() => _StatusAdminState();
}

class _StatusAdminState extends State<StatusAdmin> with SingleTickerProviderStateMixin{
  late Future<List<Map<String,dynamic>>> _orderList;
  late TabController _tabController;
  final List<String> statusList = [
    "Belum Dikonfirm", 
    "Dimasak", 
    "Diantar", 
    "Sampai",
  ];

  @override
  void initState(){
    super.initState();
      _tabController = TabController(length: statusList.length, vsync: this);
      _tabController.addListener((){
        _fetchOrder();
      });
      _fetchOrder();

  }

  void _fetchOrder() {
    String selectedStatus = statusList[_tabController.index].toLowerCase();
    setState(() {
      _orderList = Apiservices().getOrderAdmin(selectedStatus);
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 60),
            child: Row(
                    children: [
                      IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded)
                      ),
      
                      const Text(
                        "Daftar Status Pesanan",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
          ),

          TabBar(
            controller: _tabController,
            
            tabs: statusList.map((status) => Tab(text: status,)).toList()
          ),
          Expanded(
            child: FutureBuilder<List<Map<String,dynamic>>>(
              future: _orderList, 
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError){
                  return Center(
                    child: Text("Terjadi kesalahan: ${snapshot.error}"),
                  );
                } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return const Center(
                    child: Text(
                      "Tidak ada pesanan",
                    ),
                  );
                }
                
                final orders = snapshot.data!;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index){
                    final order = orders[index];
                    final detailList = (order["detail_trans"] ?? []) as List<dynamic>;
                    final totalHarga = detailList.fold<int>(
                      0,
                      (sum, item) => sum + (int.tryParse(item['harga_beli'].toString()) ?? 0),
                    );


                      return OrderCard(
                        id: order["id"].toString(), 
                        total: totalHarga.toString(),
                        tanggal: order["tanggal"], 
                        waktu: order["created_at"].toString().substring(11,16), 
                        status: statusList[_tabController.index], 
                        onUpdateStatus: _fetchOrder
                      );
                  }
                );


              }
            )
          )

        ],
      ),
    );
  }
}