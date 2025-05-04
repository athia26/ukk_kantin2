
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailTranPage extends StatefulWidget {
  final Map<String, dynamic> dataTransaksi;

  const DetailTranPage({super.key, required this.dataTransaksi});

  @override
  State<DetailTranPage> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTranPage> {
  final NumberFormat numberFormat = NumberFormat("#,###", "id_ID");

  num jumlah = 0;
  num totalHarga = 0;
  num totalHargaAkhir = 0;
  List<String> itemName = [];

  @override
  void initState() {
    super.initState();
    _initializeTransactionDetails();
  }

  Future<void> _initializeTransactionDetails() async {
    _calculateTotalItemAndPrice();
    setState(() {});
  }

  void _calculateTotalItemAndPrice() {
    jumlah = 0;
    totalHarga = 0;

    for (var item in widget.dataTransaksi["detail_trans"]) {
      jumlah += item["qty"];
      totalHarga += (item['harga_beli'] ?? 0);
    }
    totalHargaAkhir = totalHarga;
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(widget.dataTransaksi["tanggal"]);
    String formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    return Scaffold(                                                                            
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:const  Icon(
                          Icons.arrow_back_ios,
                          color: Color.fromRGBO(240, 94, 94, 1),
                        )),
                    const Text("Detail Order",
                        style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 24,
                          fontWeight: FontWeight.w700
                        )
                            ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ],
                )),
            Text(
              "$formattedDate",
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),  
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(26),
                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),
                          _buildItemList(),
                          const SizedBox(height: 10),
                          const Divider(
                            height: 0,
                            color: Color.fromRGBO(214, 214, 214, 1),
                          ),
                          const SizedBox(height: 18),
                          _buildPaymentDetails(),
                          const SizedBox(height: 18),
                          _buildDiskon(),
                          const SizedBox(height: 18),
                          _buildStatus(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.dataTransaksi["detail_trans"].length, (i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: Color.fromRGBO(240, 94, 94, 1))),
                  child: Text(
                      "${widget.dataTransaksi["detail_trans"][i]["qty"]}x",
                      style: const TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w700,
                      ),
                      ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text("${widget.dataTransaksi["detail_trans"][i]["nama_menu"]}",
                     style: const TextStyle(
                      fontSize: 16,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w700,
                      ),),
                Spacer(),
                Text(
                    "Rp.${numberFormat.format(widget.dataTransaksi["detail_trans"][i]["harga_beli"])}",
                     style:const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Subtotal", style: TextStyle(fontFamily: "Outfit")),
            Text("Rp.${numberFormat.format(totalHarga)}",
                style:   const TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w600,
                      ),),
          ],
        ),
        const SizedBox(height: 18),
        const Divider(
          height: 0,
          color: Color.fromRGBO(214, 214, 214, 1),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w700,
                )
                
                ),
            Text('Rp.${numberFormat.format(totalHargaAkhir)}',
                softWrap: true,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 14,
                  fontWeight: FontWeight.w600
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiskon() {
    return const Row(
      children: [
        Icon(
          Icons.discount,
          color: Color.fromRGBO(240, 94, 94, 1),
        ),
        SizedBox(width: 5),
        Text('Diskon Hari guru', // placeholder
            softWrap: true,
            style: TextStyle(
              fontFamily: "Outfit",
              fontSize: 14, 
              fontWeight: FontWeight.w700
            )
            
            
          ),
      ],
    );
  }

  Widget _buildStatus() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(48, 12, 48, 12),
      decoration: BoxDecoration(
          color: Color.fromRGBO(254, 239, 239, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromRGBO(240, 94, 94, 1))),
      child: Center(
        child: Text(widget.dataTransaksi["status"].toString().capitalize(),
            style: const TextStyle(
              fontFamily: "Outfit",
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(240, 94, 94, 1)
            )
            
          
                
              ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
