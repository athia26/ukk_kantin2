import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kantin2_ukk/screens/components/helloAdmin.dart';
import 'package:kantin2_ukk/screens/pages/admin/addDiskon.dart';

class DiskonAdminPage extends StatefulWidget {
  const DiskonAdminPage({super.key});

  @override
  State<DiskonAdminPage> createState() => _DiskonAdminPageState();
}

class _DiskonAdminPageState extends State<DiskonAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Container(
          padding: const EdgeInsets.all(16), // Optional: biar gak mentok ke pinggir
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Text(
                    "Daftar Diskon",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddDiskon(),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'lib/assets/addplus.svg',
                  color: Colors.black,
                  width: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
