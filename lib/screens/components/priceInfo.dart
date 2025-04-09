import 'package:flutter/material.dart';

class Priceinfo extends StatelessWidget {
  final String price;

  const Priceinfo({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: 
        MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total',
            style:  TextStyle(
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xffD74339),
            ),
          ),
          Text(
            price,
            style:  const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xffD74339),
            ),
          )
        ],
      ),
    );
  }
}