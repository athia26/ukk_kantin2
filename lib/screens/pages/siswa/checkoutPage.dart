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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: const  Icon(Icons.arrow_back_ios, color: Colors.black,)
            ),
            title: const Text(
              "Checkout",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xffD74339),
              ),
            ),
            centerTitle: true,
        ),

        body: Padding(
          padding: EdgeInsets.all(16),
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
                                padding: EdgeInsets.all(6),
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

                              SizedBox(width: 12),
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

                          Divider(),
                        ],
                      ),
                    );
                  }
                ),
              ),
              Divider(),
              DiscountInfo(),
              SizedBox(height: 13),
              Priceinfo(price: 'Rp.$totalPrice'),
              SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }
}