import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/screens/pages/siswa/detailMenuSiswa.dart';
//import 'package:kantin2_ukk/screens/pages/siswa/menuStanSiswa.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class CardStan extends StatefulWidget {
  final int idStan;
  final String? category;
  final String searchQuery;
  const CardStan({super.key, this.category, this.searchQuery = "", required this.idStan});

  @override
  State<CardStan> createState() => _CardStanState();
}

class _CardStanState extends State<CardStan> {
  List<Map<String,dynamic>> items = [];
  bool isLoading = true;
  final String baseUrlRil = 'https://ukk-p2.smktelkom-mlg.sch.id/';
  
  @override
  void initState(){
    super.initState();
    fetchMenus();
  }


Future<void> fetchMenus() async {
  final apiService = Apiservices();
  List<dynamic> makanan = await apiService.getMenuMakanan();
  List<dynamic> minuman = await apiService.getMenuMinuman();

  // Gabungkan
  List<Map<String, dynamic>> allMenus = [...makanan, ...minuman]
      .cast<Map<String, dynamic>>();

  // Filter maker_id == 55 (hardcoded)
  List<Map<String, dynamic>> response = allMenus
    .where((menu) => menu["id_stan"] == widget.idStan) 
    .toList();


  if (mounted) {
    setState(() {
      items = response;
      isLoading = false;
    });
  }
}




  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }
  
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = items.where((item){
      final nama = item["nama_makanan"].toLowerCase();
      final isCategoryMatch = widget.category == null || item["jenis"] == widget.category;
      final isSearchMatch = nama.contains(widget.searchQuery);
      return isCategoryMatch && isSearchMatch;
    }).toList();
    
    return isLoading 
      ? Center(child: CircularProgressIndicator())
      : GridView.builder(
        
        itemCount: filteredItems.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          //childAspectRatio: 0.75
        ), 
        itemBuilder: (context, index){
          var item = filteredItems[index];

          return InkWell(
            key: ValueKey(index),
            onTap: () {
              showModalBottomSheet(
                context: context, 
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                builder: (context) => MenuDetailSiswa(dataMenu: item));
              //Navigator.push(context, MaterialPageRoute(builder: (context) => ))
            },

            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: item["foto"] == null || item["foto"].isEmpty
                            ? Image.asset("lib/assets/placehorder.jpg",
                              fit: BoxFit.cover,)
                            : Image.network(
                              "$baseUrlRil${item["foto"]}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                  Image.asset("lib/assets/placehorder.jpg",
                                    fit: BoxFit.cover,
                              ),
                            ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        item["nama_makanan"],
                        style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffD74339),
                          ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        formatCurrency(item["harga"]),
                        style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffD74339),
                        ),
                      
                      ),
                    )
                  ],
                ),
              ),
            )
          );
        });
  }
}