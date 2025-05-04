import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/provider/cartProvider.dart';
import 'package:kantin2_ukk/screens/components/buttonUser.dart';
import 'package:kantin2_ukk/screens/components/dropdownUser.dart';
import 'package:kantin2_ukk/screens/pages/siswa/historyListTran.dart';
import 'package:kantin2_ukk/services/apiServices.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";
  int quantity = 0;
  String? selectedDiskon;

  List<String> diskonList = [];

class _CartPageState extends State<CartPage> {
  
  @override
  void initState(){
    super.initState();
    fetchDiskon();
  }

  Future <void> fetchDiskon() async{
    final apiService = Apiservices();
    List<dynamic> fetchedDiskonlist = await apiService.getDiskon();

    List<String> diskonNamaList = fetchedDiskonlist
      .map((item)=> item['nama_diskon'].toString())
      .toList();

      setState(() {
        diskonList = diskonNamaList;
      });
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

 Future<void> pesananDone() async {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final apiService = Apiservices();

  if (cartProvider.items.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Keranjang masih kosong.")),
    );
    return;
  }

  final int idStan = cartProvider.items.first.idStan;

  final List<Pesanan> pesananList = cartProvider.items
      .map((item) => Pesanan(idMenu: item.idMenu, qty: item.quantity))
      .toList();

  bool success = await apiService.pesanMakanan(idStan, pesananList);

  if (success) {
    cartProvider.clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Pesanan berhasil dibuat!")),
    );
    // Setelah pesanan berhasil, arahkan ke halaman History List Transaction
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HistoryListTran()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Gagal membuat pesanan.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _){
                  if (cartProvider.items.isEmpty){


                    return Center(child: Text("Keranjang kosong"),);
                  }

                
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       const Text(
                          "Keranjang Kamu",
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartProvider.items.length,
                          itemBuilder: (context, index){
                            final item = cartProvider.items[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: item.foto.isEmpty
                                        ?Image.asset("lib/assets/placehorder.jpg")
                                        :Image.network("$baseUrlRil${item.foto}",
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, error, stackTrace) =>
                                                        Image.asset(
                                                            "assets/placeholder.png",
                                                            width: 90,
                                                            height: 90,
                                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.namaMakanan,
                                                  style: const TextStyle( 
                                                    fontFamily: "Outfit",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),

                                                Text(
                                                  formatCurrency(item.harga),
                                                  style: const TextStyle( 
                                                    fontFamily: "Outfit",
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                 //harga disini 
                                                ),
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            
                                            SizedBox(width: 6),
                                            InkWell(
                                                  onTap: () {
                                                    int qty = item.quantity;
                                                    if (qty > 1) {
                                                      cartProvider.decreaseQty(
                                                          index, qty - 1);
                                                    }
                                                  },
                                                child: Icon(Icons.remove)
                                              ),

                                              SizedBox(width: 10),
                                              Text(
                                                item.quantity.toString(),
                                                style: const TextStyle( 
                                                  fontFamily: "Outfit",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              SizedBox(width: 6),
                                              InkWell(
                                                  onTap: () {
                                                    int qty = item.quantity;
                                                    cartProvider.increaseQty(
                                                        index, qty + 1);
                                                  },
                                                  child: Icon(Icons.add)),
                        
                                            
                                          ],
                                        )
                                      ],
                                    )
                                  )
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  );
                },
              )
            ),

            const Text(
              "Diskon",
              style: TextStyle(
                fontFamily: "Outfit",
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 16),
            DropdownUser(
              hint: "Tidak ada diskon", 
              items: diskonList,  
              onChanged: (value){
                setState(() {
                  selectedDiskon = value;
                });
              }, 
              value: selectedDiskon
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  formatCurrency(cartProvider.total),
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            ButtonUser(text: "Selesaikan Pesanan", onPressed: pesananDone),
            
          ],
        ),
      ),
    );
  }
}