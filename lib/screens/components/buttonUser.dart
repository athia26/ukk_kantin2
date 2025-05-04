import 'package:flutter/material.dart';

class ButtonUser extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ButtonUser({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(240, 94, 94, 1),
          disabledBackgroundColor: const Color.fromARGB(255, 217, 217, 217),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Outfit",
            fontSize: 16,
          )
        ),
      ),
    );
  }
}