import 'package:flutter/material.dart';

class HelloAdmin extends StatelessWidget {
  final String kantin;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onEdit;

  const HelloAdmin({
    super.key, 
    required this.kantin,
    required this.icon,
    required this.iconColor,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            kantin,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 30,
              fontWeight: FontWeight.w700),
          ),

          const Spacer(),
          IconButton(
            onPressed: (){
              if (onEdit != null){
                onEdit!();
              }
            }, icon: Icon(icon, color: iconColor,))
        ],
      ),
    );
  }
}