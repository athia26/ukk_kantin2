import 'package:flutter/material.dart';

class ItemForm extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType inputType;
  final TextEditingController? controller;

  const ItemForm({super.key, required this.labelText, required this.hintText, this.inputType = TextInputType.text, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xfffff5f3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextFormField(
              cursorColor: Colors.black,
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,  
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Outfit',
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}