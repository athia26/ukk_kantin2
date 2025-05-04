import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/screens/pages/siswa/detailHistoryTrans.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class HistoryListTran extends StatefulWidget {
  const HistoryListTran({super.key});

  @override
  State<HistoryListTran> createState() => _HistoryListTranState();
}

class _HistoryListTranState extends State<HistoryListTran> {
  late Future<List<Map<String, dynamic>>> _orderList;
  String _selectedStatus = "Belum dikonfirm";
  final List<String> _statusOptions = [
    "Belum dikonfirm",
    "Dimasak",
    "Diantar",
    "Sampai",
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  void _fetchOrder() {
    setState(() {
      _orderList = Apiservices().getOrderSiswa(_selectedStatus.toLowerCase())
          .then(_enrichOrders);
    });
  }

  Future<List<Map<String, dynamic>>> _enrichOrders(
      List<Map<String, dynamic>> orders) async {
    for (var order in orders) {
      if (order['detail_trans'] is List) {
        for (var item in order['detail_trans']) {
          item['nama_menu'] =
              await Apiservices().getFoodName(item['id_menu']) ?? '–';
        }
      }
    }
    return orders;
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _statusOptions.map((s) {
          return ListTile(
            title: Text(s, style: TextStyle(fontFamily: "Outfit", fontSize: 16),),
            onTap: () {
              Navigator.pop(context);
              _selectedStatus = s;
              _fetchOrder();
            },
          );
        }).toList(),
      ),
    );
  }

  void onDateFilterSelected(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(240, 94, 94, 1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color.fromRGBO(240, 94, 94, 1),
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    final year = picked.year, month = picked.month;
    setState(() {
      _orderList = Apiservices()
          .getOrderSiswa(_selectedStatus.toLowerCase())
          .then((orders) async {
        final enriched = await _enrichOrders(orders);
        return enriched.where((order) {
          final d = DateTime.parse(order['tanggal']);
          return d.year == year && d.month == month;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "History Pemesanan",
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () => _showFilterDialog(context),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color.fromRGBO(240, 94, 94, 1),
                              ),
                              child:const  Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () => onDateFilterSelected(context),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromRGBO(240, 94, 94, 1),
                            ),
                            child: const  Icon(
                                Icons.watch_later_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _orderList,
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    if (snap.hasError)
                      return Center(
                        child: Text("Error: ${snap.error}"),
                      );

                    final list = snap.data!;
                    if (list.isEmpty)
                      return Center(
                        child: Text("Tidak ada transaksi"),
                      );

                    return ListView.builder(
                      shrinkWrap: true, // This ensures the ListView only takes as much space as needed.
                      physics: NeverScrollableScrollPhysics(), // This prevents scrolling inside the ListView.
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final order = list[i];
                        num total = 0;

                        if (order['detail_trans'] is List)
                          for (var item in order['detail_trans'])
                          total += (item['harga_beli'] ?? 0);


                        final statusColor = order['status'] == "Dimasak"
                            ? Color.fromRGBO(240, 94, 94, 1)
                            : Colors.green;

                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetailTranPage(dataTransaksi: order,)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 243, 240, 1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color.fromRGBO(240, 94, 94, 1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Transaksi #${order['id']}",
                                        style: const TextStyle(
                                          fontFamily: "Outfit",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 15,
                                      color: Color.fromRGBO(240, 94, 94, 1),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Total: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(total)}",
                                  style: const TextStyle(
                                    fontFamily: "Outfit",
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      order['tanggal'],
                                      style: const TextStyle(
                                        fontFamily: "Outfit",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: statusColor),
                                      ),
                                      child: Text(
                                        order['status'],
                                        style: TextStyle(
                                          fontFamily: "Outfit",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: statusColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
