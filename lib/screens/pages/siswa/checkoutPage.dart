import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/components/discountInfo.dart';
import 'package:kantin2_ukk/screens/components/priceInfo.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const CheckoutPage({super.key, required this.order});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {

    final items = widget.order['items'] as List<Map<String,dynamic>>;

    double totalPrice = items.fold(0, (sum, item){
      return sum + (item['count'] * item ['price']);
    });
    return Scaffold(

      backgroundColor: Colors.white,
      
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index){
                  final item = items [index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${item['count']}x',
                                style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD74339),
                                ),
                              ),
                            ),
    
                            const SizedBox(width: 12),
                            Expanded(child: Text(
                              item['name'],
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffD74339),
                                ),
                              ),
                            ),
    
                            Text(
                              'Rp ${item['price']}',
                              style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD74339),
                              ),
                            ),
                          ],
                        ),
    
                        const Divider(),
                      ],
                    ),
                  );
                }
              ),
            ),
            const Divider(),
            const DiscountInfo(),
            const SizedBox(height: 13),
            Priceinfo(price: 'Rp.$totalPrice'),
            const SizedBox(height: 24),
    
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, '/home');
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD74339),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xffD74339),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    child: const Text(
                      "Selesaikan Pesanan",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    )
                  ),
                ),
                const SizedBox(height: 13),
    
                
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/home');
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD74339),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xffD74339),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      child: const Text(
                        "Print Pesanan",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      )
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}