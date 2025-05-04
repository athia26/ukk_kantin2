import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/models/cartModel.dart';
import 'package:kantin2_ukk/provider/cartProvider.dart';
import 'package:kantin2_ukk/services/apiServices.dart';
import 'package:provider/provider.dart';

class MenuDetailSiswa extends StatefulWidget {
  final Map<String, dynamic> dataMenu;
  const MenuDetailSiswa({super.key, required this.dataMenu});

  @override
  State<MenuDetailSiswa> createState() => _MenuDetailSiswaState();
}

class _MenuDetailSiswaState extends State<MenuDetailSiswa> {
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";

  int quantity = 0;

  String formatCurrency (int amount){
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  void _testOrder() async{
    final orderService = Apiservices();
    final result = await orderService.pesan();
    print("Hasil API: $result");
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20, bottom: 30),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: widget.dataMenu["foto"] == null ||
                  widget.dataMenu["foto"].isEmpty
                      ? Image.asset("lib/assets/placehorder.jpg", fit: BoxFit.cover) 
                      : Image.network(
                        "$baseUrlRil${widget.dataMenu["foto"]}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                                Image.asset("assets/placeholder.png",
                                    fit: BoxFit.cover),
                          
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.dataMenu["nama_makanan"] ?? "-",
                    style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffD74339),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    formatCurrency(widget.dataMenu["harga"]),
                    style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD74339),
                            ),
                  )
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dataMenu["deskripsi"] ?? "-",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffD74339),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffe8dccc),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: (){
                              if(quantity > 0){
                                setState(() {
                                  quantity--;
                                });
                              }
                            }, 
                            icon: const Icon(
                              Icons.remove,
                              color: Color(0xffD74339),
                            )
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffD74339),
                            ),
                          ),
                          IconButton(onPressed: (){
                            setState(() {
                              quantity++;
                            });
                            }, icon: const Icon(
                              Icons.add,
                              color: Color(0xffD74339),)
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xffD74339)
                      ),
                      onPressed: quantity > 0
                        ? (){
                          final cartItem = CartItem.fromJson(widget.dataMenu);

                          Provider.of<CartProvider>(context, listen: false)
                            .addToCart(cartItem, quantity);

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${cartItem.namaMakanan} ditambahkan ke keranjang"))
                          );
                        } 
                        :null,
                      child: const Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text(
                          "Tambah ke Keranjang",
                          style:  TextStyle(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500    
                          ),
                        ),
                      )
                    ),
                  ))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}