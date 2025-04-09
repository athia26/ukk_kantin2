import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/screens/pages/siswa/checkoutPage.dart';
import 'package:kantin2_ukk/screens/components/itemCard.dart';


class MenuStanSiswa extends StatefulWidget {
  final Map<String, dynamic> stans;

  const MenuStanSiswa({super.key, required this.stans});

  @override
  State<MenuStanSiswa> createState() => _MenuStanSiswaState();
}

class _MenuStanSiswaState extends State<MenuStanSiswa> {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  Map<String, int> itemCounts = {}; // Menyimpan jumlah pesanan tiap item

  @override
  void initState() {
    super.initState();
    for (var item in widget.stans['makanan']) {
      itemCounts[item['name']] = 0;
    }
    for (var item in widget.stans['minuman']) {
      itemCounts[item['name']] = 0;
    }
  }

  List<Map<String, dynamic>> get selectedItems {
    return itemCounts.entries.where((entry) => entry.value > 0).map((entry) {
      var item = widget.stans['makanan'].firstWhere(
        (element) => element['name'] == entry.key,
        orElse: () => <String, Object>{},
      );

      if (item.isEmpty) {
        item = widget.stans['minuman'].firstWhere(
          (element) => element['name'] == entry.key,
          orElse: () => <String, Object>{},
        );
      }

      return {
        'name': entry.key,
        'count': entry.value,
        'price': item.isEmpty ? 0 : item['harga'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.modulate),
                    child: ClipRRect(
                      child: Image.asset(
                        widget.stans['image']!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 8),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 130,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: const Offset(0, 4),
                            blurRadius: 9,
                          )
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.stans['nama']}',
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffD74339),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.star_rate_rounded, color: Color(0xffFFD700)),
                                Text(
                                  '${widget.stans['rate']}',
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17,
                                    color: Color(0xffD74339),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 75,),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildCategorySection('Makanan', widget.stans['makanan']),
                      _buildCategorySection("Minuman", widget.stans['minuman']),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        
        
      ),
      bottomNavigationBar: itemCounts.values.any((count) => count > 0 ) 
      ? BottomAppBar(
        child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      final order = {
                        'items' :  selectedItems,
                        'totalCount': itemCounts.values
                          .reduce((a,b) => a + b),
                      };

                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(order: order) 
                        )
                      );
                    }, 

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD74339),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    child: const Text(
                      "Beli",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white
                      ),
                    )
                  ),
                ),
              ),

      ) : null,
    );
  }

  Widget _buildCategorySection(String title, List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
      
          ...items.map((item) {
            return Itemcard(
              image: item.containsKey('imageItem') ? item['imageItem'] : 'lib/assets/placeholder.jpg',
              name: item['name'],
              desc: item['desc'],
              count: itemCounts[item['name']]!,
              harga: item['harga'],
              onIncrement: () {
                setState(() {
                  itemCounts[item['name']] = itemCounts[item['name']]! + 1;
                  print("jumlah ${item['name']}: ${itemCounts[item['name']]}");
                });
              },
              onDecrement: () {
                setState(() {
                  if (itemCounts[item['name']]! > 0) {
                    itemCounts[item['name']] = itemCounts[item['name']]! - 1;
                  }
                });
              },
            );
          }),
        ],
      ),
    );
  }
}
