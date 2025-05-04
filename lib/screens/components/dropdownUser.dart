import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DropdownUser extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final Function(String?) onChanged;

  const DropdownUser({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.value,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(185, 185, 185, 1)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),

      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: value,
            isExpanded: true,
            hint: Text(
              hint, 
              style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 14,
              ),
            ),
            items: items.map((String item){
              return DropdownMenuItem(
                value: item,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "lib/assets/pricetag.svg",
                        height: 20,
                        color: Color.fromRGBO(240, 94, 94, 1),
                        
                        ),
                        SizedBox(width: 10),
                        Text(
                          item,
                          style: TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),

                        )
                    ],
                  ),
                )
              );
            }).toList(),
            onChanged: onChanged),
        ),
      ),
    );
  }
}