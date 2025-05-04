import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class RekapOrderAdmin extends StatefulWidget {
  const RekapOrderAdmin({super.key});

  @override
  State<RekapOrderAdmin> createState() => _RekapOrderAdminState();
}

class _RekapOrderAdminState extends State<RekapOrderAdmin> {
  late Future<List<Map<String, dynamic>>> _rekapList;
  String _bulan = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _rekapList = Apiservices().getRekapPemesananStan(_bulan);
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
                      "Rekap Data Pesanan",
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _rekapList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final list = snapshot.data!;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada data pemesanan di bulan ini."),
                    );
                  }

                  

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffE8DCCC),
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Text(
                          "Jumlah order bulan ini: ${list.length}",
                          style: const TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffD74339)
                          ),
                        ),
                      ),
                      
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final order = list[i];
                            return Card(
                              color: Color(0xffD74339),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: ListTile(
                                title: Text(
                                    "Transaksi #${order['id']} - ${order['nama_siswa']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Outfit", 
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20
                                      ),
                                    ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4,),
                                    Text(
                                      "Tanggal: ${order['tanggal']}", 
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Outfit",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          ),
                                      ),
                                    
                                    Text(
                                      "Status: ${order['status']}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Outfit",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                      ),
                                    
                        
                                  ],
                                ),
                                
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
}
