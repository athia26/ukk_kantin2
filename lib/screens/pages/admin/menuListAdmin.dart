import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class MenuListAdmin extends StatefulWidget {
  final String? category;
  const MenuListAdmin({super.key, this.category});

  @override
  State<MenuListAdmin> createState() => _MenuListAdminState();
}

class _MenuListAdminState extends State<MenuListAdmin> {
  List<Map<String,dynamic>> items = [];
  bool isLoading = true;
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";
  int? idStan;

  @override
  void initState(){
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async{
    final apiService = Apiservices();
    List<dynamic> response = await apiService.showMenu();

    print("Fetched Menu: ${jsonEncode(response)}");

    List<Map<String,dynamic>> filteredResponse = response.map((data) => data as Map<String,dynamic>).toList();
    if (mounted){
      setState(() {
        items = filteredResponse;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteMenu(String menuId) async{
    print("Akan menghapus menu dengan ID: $menuId");
    final apiService = Apiservices();
    bool success = await apiService.hapusMenu(menuID: menuId);

    if (success){
      setState(() {
        items.removeWhere((data) => data["id"].toString() == menuId);
      });
      ScaffoldMessenger.of( context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
          "Berhasil menghapus menu"
        )),
      );
    } else{
      ScaffoldMessenger.of( context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
          "Gagal menghapus menu"
        ))
      );    
    }
  }

  String formatCurrency(int amount){
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> filteredItems = widget.category == null
      ? items 
      : items.where((data) => data["jenis"] == widget.category).toList();
    return isLoading
    ? const Center(
      child: CircularProgressIndicator(
        color: Color(0xffD74339),
      ),
    )
    : filteredItems.isEmpty
    ? const Center(
      child: Text(
        "Tidak ada menu yang ditambahkan",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ) : ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index){
            var item = filteredItems[index];
            return Slidable(
              key: ValueKey(item["id"]),
              endActionPane: ActionPane(
                motion: const DrawerMotion(), 
                children: [
                  SlidableAction(onPressed: (context){

                  },
                  backgroundColor: const Color.fromRGBO(147, 147, 147, 1),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                  
                  ),

                  SlidableAction(
                    onPressed: (context){
                      showDialog(
                        context: context, 
                        builder: (context) =>  AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "Hapus Menu",
                          ),
                          content: const Text(
                            "Anda yakin ingin menghapus menu ini?"
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), 
                              child: const Text(
                                "Batal",
                              ),
                            ),
                            TextButton(
                              onPressed: (){
                                print("deleting menu ID: ${item["id"]}");
                                _deleteMenu(item["id"].toString());
                                Navigator.pop(context);
                              }, 
                              child: const Text(
                                "Hapus",
                                
                              ),
                            )
                          ],
                        ) 
                      );
                    },
                    backgroundColor: const Color.fromRGBO(240, 94, 94, 1),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 102,
                        height: 102,
                        child: 
                        item["foto"] == null || item ["foto"].isEmpty
                        ? Image.asset("lib/assets/placehorder.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover)
                            : Image.network(
                              "$baseUrlRil${item["foto"]}",
                              fit: BoxFit.cover,
                              width: 102,
                              height: 102,
                              errorBuilder: (context, error, stackTrace) => 
                                  Image.asset("lib/assets/placehorder.jpg",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover
                          ),
                        ),
                      ), 
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item["nama_makanan"],
                            style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffD74339),
                              ),
                          ),
                          Row(
                            children: [
                              Text(
                                "#${item["jenis"]}",
                                 style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffD74339),
                              ),
                              ),
                              const Spacer(),
                              Text(
                                formatCurrency(item["harga"]),
                                 style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
  }
}