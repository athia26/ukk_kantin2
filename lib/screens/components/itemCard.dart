import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Itemcard extends StatelessWidget {
  final String image;
  final String name;
  final int harga;
  final String desc; 
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const Itemcard({super.key,
    required this.image,
    required this.name,
    required this.desc,
    required this.count,
    required this.onIncrement,
    required this.harga,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffE8DCCC),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                ), 
      
                SizedBox(width: 20),
                
                Expanded(
                  child: 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name, 
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffD74339),
                        ),
                      ),
                      
                      Text(
                        desc,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD74339),
                        ),
                      ),

                      SizedBox(height: 7),
                      count == 0 
                      ? Row(
                        children: [
                          Text(
                            "Rp. $harga",
                            style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD74339),
                            ),
                          ),
                          Expanded(child: Container()),
                          InkWell(
                            onTap: onIncrement,
                            child: Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xffFFF3F0),
                                border: Border.all(
                                  color: Color(0xffD74339),
                                ),
                                borderRadius: BorderRadius.circular(360),
                              ),
                              child: SvgPicture.asset('lib/assets/plus.svg',
                              height: 15,)
                            ),
                          )
                        ],
                      )
                      : Row(
                        children: [
                          Text(
                            "Rp. $harga",
                            style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD74339),
                            ),
                          ),

                          Expanded(
                            child: Container()),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xffFFF3F0),
                                border: Border.all(
                                  color: Color(0xffD74339)
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(

                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: onDecrement, 
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Color(0xffD74339),
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      '$count',
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xffD74339),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: onIncrement, 
                                    icon: const Icon(
                                      Icons.add,
                                      color: Color(0xffD74339),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                         ],
                      )
                      
      
                      
                    ],
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}