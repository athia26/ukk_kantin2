import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class RekapPemasukanStan extends StatefulWidget {
  const RekapPemasukanStan({super.key});

  @override
  State<RekapPemasukanStan> createState() => _RekapPemasukanStanState();
}

class _RekapPemasukanStanState extends State<RekapPemasukanStan> {
  late Future<Map<String, dynamic>> _rekapPemasukan;
  String _bulan = DateFormat('yyyy-MM').format(DateTime.now());
  Map<DateTime, int> pemasukanPerTanggal = {}; // Untuk menyimpan pemasukan per tanggal
  List<Map<String, dynamic>> transaksiList = []; // List untuk menyimpan transaksi

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _rekapPemasukan = Apiservices().getRekapPemasukanStan(_bulan);
    });
  }

  void _pickBulan() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(240, 94, 94, 1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _bulan = DateFormat('yyyy-MM').format(picked);
        _loadData();
      });
    }
  }

  // Fungsi untuk mengecek apakah dua tanggal sama (tanpa memperhitungkan waktu)
  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Rekap Pemasukan",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _pickBulan,
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _rekapPemasukan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final data = snapshot.data!;
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada data pemasukan di bulan ini."),
                    );
                  }

                  // Proses data transaksi untuk dipisah per tanggal
                  pemasukanPerTanggal.clear();
                  transaksiList = List<Map<String, dynamic>>.from(data['data_transaksi']);
                  for (var transaksi in transaksiList) {
            DateTime orderDate = DateTime.parse(transaksi['tanggal']);
            final detail = transaksi["detailTrans"] as List;

            for (var item in detail) {
              final hargaBeliRaw = item["harga_beli"];
              final hargaBeli = hargaBeliRaw is int
                  ? hargaBeliRaw
                  : int.tryParse(hargaBeliRaw.toString()) ?? 0; // Default to 0 if null

              if (pemasukanPerTanggal.containsKey(orderDate)) {
                pemasukanPerTanggal[orderDate] = pemasukanPerTanggal[orderDate]! + hargaBeli;
              } else {
                pemasukanPerTanggal[orderDate] = hargaBeli;
              }
            }
          }

                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffE8DCCC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Total Pemasukan bulan ini: Rp ${NumberFormat('#,###').format(data['total_pemasukan'])}",
                          style: const TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffD74339),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pemasukanPerTanggal.length,
                          itemBuilder: (_, index) {
                            final entry = pemasukanPerTanggal.entries.toList()[index];
                            final date = entry.key;
                            final totalPemasukan = entry.value;

                            return Card(
                              color: Color(0xffD74339),
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                              child: ListTile(
                                title: Text(
                                  DateFormat('d MMMM yyyy').format(date),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  'Pemasukan: Rp ${NumberFormat('#,###').format(totalPemasukan)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () {
                                  // Tanggal dipilih, tampilkan detail transaksi
                                   _showOrderDetailsForDate(context, date);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan detail transaksi pada tanggal tertentu
void _showOrderDetailsForDate(BuildContext context, DateTime date) {
  final selectedOrders = _getOrdersForDate(date);

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order pada tanggal ${DateFormat('d MMMM yyyy').format(date)}',
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedOrders.length,
                itemBuilder: (context, index) {
                  final order = selectedOrders[index];
                  var hargaBeli = order['harga_beli'];

                  // Periksa apakah harga_beli null
                  if (hargaBeli == null) {
                    hargaBeli = 0;  // Jika null, set hargaBeli ke 0
                  } else if (hargaBeli is String) {
                    hargaBeli = double.tryParse(hargaBeli) ?? 0;  // Jika string, coba konversi jadi angka
                  } else if (hargaBeli is int) {
                    hargaBeli = hargaBeli.toDouble();  // Jika int, konversi ke double
                  }

                  // Format harga_beli
                  final hargaFormatted = hargaBeli > 0
                      ? NumberFormat('#,###').format(hargaBeli)
                      : 'Rp 0';

                  return ListTile(
                    title: Text('Order ID: ${order['id']}'),
                    subtitle: Text(
                      'Pemasukan: $hargaBeli',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}



  // Fungsi untuk mendapatkan order berdasarkan tanggal
  List<Map<String, dynamic>> _getOrdersForDate(DateTime date) {
    List<Map<String, dynamic>> ordersForDate = [];

    for (var transaksi in transaksiList) {
      DateTime orderDate = DateTime.parse(transaksi['tanggal']);
      if (isSameDay(orderDate, date)) {
        ordersForDate.add(transaksi);
      }
    }

    return ordersForDate;
  }
}
