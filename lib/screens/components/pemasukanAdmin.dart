import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/screens/pages/admin/rekapPemasukanAdmin.dart';

class Pemasukan extends StatefulWidget {
  final int penghasilan;

  const Pemasukan({super.key, required this.penghasilan});

  @override
  State<Pemasukan> createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  bool _isHidden = false; 

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: "Rp",
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
              color: const Color(0xffA73931),
              width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "Pemasukan Bulan Ini",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffD74339),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  }, 
                  icon: Icon(
                    _isHidden ? Icons.visibility : Icons.visibility_off, 
                    size: 18,
                    color: const Color(0xffD74339),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isHidden ? "Rp.******" : formatCurrency.format(widget.penghasilan),
                  style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffD74339),
                    ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RekapPemasukanStan()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:  Color(0xffD74339),
                      
                    ),
                    child: const Row(
                      children: [
                        const Text(
                          "Lihat Rekap ",
                          style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                            ),
                        ),

                        Icon(Icons.arrow_forward_ios_rounded, 
                        color: Colors.white,
                        size: 10,)
                      ],
                    ),


                  ),
                )
              ],
            )
          ],
        ),
        
      ),
    );
  }
}