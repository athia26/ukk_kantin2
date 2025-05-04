import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class OrderCard extends StatefulWidget {
  final String id;
  final String total;
  final String tanggal;
  final String waktu;
  final String status;
  final VoidCallback onUpdateStatus;


  const OrderCard({super.key, 
  required this.id, 
  required this.total, 
  required this.tanggal, 
  required this.waktu,
  required this.status, 
  required this.onUpdateStatus});
  
  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String? selectedStatus;

  final List<String> statusList = ["Belum Dikonfirm", "Dimasak", "Diantar", "Sampai"];

  @override
  void initState(){
    super.initState();
    selectedStatus = widget.status;
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }
  
  Future <void> _updateStatus(String newStatus) async{
    try {
      await Apiservices().updateOrderStatus(widget.id, newStatus.toLowerCase());
      setState(() {
        selectedStatus = newStatus;
      });

      widget.onUpdateStatus();
    } catch(e){
      print("Error updating status: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration:  BoxDecoration(
        color: Color(0xffD74339),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID Pesanan: ${widget.id}",
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white
                ),
              ),

              const SizedBox(height: 4),
              Text("${formatCurrency(int.tryParse(widget.total)?? 0)}",
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white
                ),
              ),

              const SizedBox(height: 4),
              Text("${widget.tanggal}   ${widget.waktu}",
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                color: Colors.white
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xffe8dccc),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: selectedStatus,
                  items: statusList.map((String status){
                    return DropdownMenuItem(
                      value: status,
                      child: Text(
                        status,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    if(newValue != null){
                      _updateStatus(newValue);
                    }
                  },
                  underline: SizedBox(),
                  dropdownColor: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}