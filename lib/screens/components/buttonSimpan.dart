import 'package:flutter/material.dart';

class ButtonSimpan extends StatelessWidget {
  final String hintText;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const ButtonSimpan({super.key, required this.hintText, required this.isEnabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isEnabled ? Color(0xffD74339) : Colors.grey,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isEnabled ? onPressed : null, 
          child: Text(
            hintText,  
            style: const TextStyle(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500    
                  ),
          )
        ),
      ),
    );
  }
}