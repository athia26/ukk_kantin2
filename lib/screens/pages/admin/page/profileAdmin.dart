import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/admin/editStan.dart';
import 'package:kantin2_ukk/screens/pages/admin/recapPage.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  String? namaStan;
  String? namaPemilik;
  Map<String, dynamic>? stanData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileAdmin();
  }

  Future<void> fetchProfileAdmin() async {
    final apiService = Apiservices();
    final profileData = await apiService.getStan();

    if (profileData.isNotEmpty) {
      setState(() {
        stanData = profileData[0];
        namaStan = profileData[0]['nama_stan'];
        namaPemilik = profileData[0]['nama_pemilik'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20,),
                  Text(
                    namaStan ?? '-',
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    namaPemilik ?? '-',
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Divider(thickness: 2, endIndent: 10, indent: 10,),
                  const SizedBox(height: 40),
                  
                  ListTile(
                    leading: const Icon(Icons.mode_edit_outline_outlined),
                    title: const Text("Edit Stan", 
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      
                     
                    final Map<String, dynamic> stanData = {
                      'nama_stan': namaStan,
                      'nama_pemilik': namaPemilik,
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Editstan(stanData: stanData)),
                    );


                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.note_outlined),
                    title: const Text("Rekap Bulanan",
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecapPage()
                      ));
                    },
                  ),


                  
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text("Keluar",
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
