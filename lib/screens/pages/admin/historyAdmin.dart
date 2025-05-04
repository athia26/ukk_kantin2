import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class HistoryAdmin extends StatefulWidget {
  const HistoryAdmin({super.key});

  @override
  State<HistoryAdmin> createState() => _HistoryAdminState();
}

class _HistoryAdminState extends State<HistoryAdmin> {
  List<Map<String,dynamic>> _historyList = [];

  @override
  void initState(){
    super.initState();
      _fetchHistoryTransaksi();
  }

  Future<void> _fetchHistoryTransaksi() async{
    final orderList = await Apiservices().getOrderAdminSelesai();
    setState(() {
      _historyList = orderList
        .where((order) => order["status"].toLowerCase() == "sampai")
        .toList();
    });
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }



  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: _historyList.isEmpty
        ? const Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Center(
            child: Text(
              "Belum ada transaksi selesai",
            ),
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          itemCount: _historyList.length,
          itemBuilder: (context, index){
            final order = _historyList[index];
            final detail = order["detail_trans"].isNotEmpty
              ? order["detail_trans"][0]
              : null;

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                 padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xffD74339),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Pesanan: ${order["id"]}",
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                        ),
                      ),

                      SizedBox(height: 4),
                      Text(
                        "Total: ${formatCurrency(int.tryParse(detail["harga_beli"]?.toString()?? "0") ?? 0)}",
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${order["tanggal"]}   ${order["created_at"].toString().substring(11,16)}",
                        style:  TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8)
                        ),
                      )
                    ],
                  ),
              );
          })
    );
  }
}