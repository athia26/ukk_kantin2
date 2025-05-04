import 'package:flutter/material.dart';

class CheckboxItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool?) onChanged;

  const CheckboxItem({super.key, required this.label, required this.isSelected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.black,
          activeColor: Color(0xFFFFF5F3),
          value: isSelected, 
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
          ),
        )
      ],
    );
  }
}