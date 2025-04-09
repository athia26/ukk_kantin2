import 'package:flutter/material.dart';

class OrderBox extends StatelessWidget {
  final int running;
  final int request;

  const OrderBox({super.key, required this.running, required this.request});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 170,
          height: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xffA73931),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$running",
                style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffD74339),
                ),
              ),
              const Text(
                "Order Baru",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffD74339),
                ),
              ),
            ],
          ),
        ),

        Expanded(child: Container()),
        Container(
          width: 170,
          height: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xffA73931),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$request",
                style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffD74339),
                ),
              ),
              const Text(
                "Order Selesai",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffD74339),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}