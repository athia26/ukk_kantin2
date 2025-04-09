import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class DiscountInfo extends StatefulWidget {
  const DiscountInfo({super.key});

  @override
  State<DiscountInfo> createState() => _DiscountInfoState();
}

class _DiscountInfoState extends State<DiscountInfo> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Transform.rotate(
            angle: 90 * math.pi /180,
            child: 
              SvgPicture.asset('lib/assets/pricetag.svg')
            
          ),
          const SizedBox(width: 8),
          const Text(
            'Use Discount',
            style:  TextStyle(
              fontFamily: 'Outfit',
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color(0xffD74339),
            ),
          ),
          Expanded(child: Container()),
          IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios))
          
          
          
        ],
      ),
    );
  }
}