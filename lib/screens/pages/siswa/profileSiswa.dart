import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kantin2_ukk/screens/pages/loginPage.dart';
import 'package:kantin2_ukk/screens/pages/siswa/editProfileSiswa.dart';
import 'package:kantin2_ukk/screens/pages/siswa/historyListTran.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class Profilesiswa extends StatefulWidget {
  const Profilesiswa({super.key});

  @override
  State<Profilesiswa> createState() => _ProfilesiswaState();
}

class _ProfilesiswaState extends State<Profilesiswa> {
  String? namaSiswa;
  String? username;
  String? fotoSiswa;
  bool isLoading = true;
  Map<String,dynamic>? siswaData;

  @override
  void initState(){
    super.initState();
    fetchProfile();

  }

  Future<void> fetchProfile() async{
    final apiService = Apiservices();
    final profileData = await apiService.getProfile();

    if (profileData.isNotEmpty){
      setState(() {
        namaSiswa = profileData[0]['nama_siswa'];
        username = profileData[0]['username'];
        fotoSiswa = profileData[0]['foto'];
        siswaData = profileData[0];
        isLoading = false;
      });
    }
  }

  Future<void> pickAndUpdatePhoto() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File fotoBaru = File(pickedFile.path);

    // Anggap kamu udah punya data ini dari getProfile()
    final profile = await Apiservices().getProfile();
    final data = profile[0]; // Karena getProfile() mengembalikan List

    bool result = await Apiservices().updateSiswa(
      id: data['id'],
      namaSiswa: data['nama_siswa'],
      email: data['email'] ?? '', // Tambahkan null check
      username: data['username'],
      alamat: data['alamat'],
      noTelp: data['telp'],
      foto: fotoBaru,
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto berhasil diperbarui!')),
      );
      // Refresh profil kalau perlu
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui foto.')),
      );
    }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
      
        ? Center(child: CircularProgressIndicator(),)
        : Padding(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: fotoSiswa != null
                        ? NetworkImage(fotoSiswa!)
                        : AssetImage('lib/assets/profilekosong.jpg') as ImageProvider
                    ),
                    
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],                       
                        ),
                        child: IconButton(
                          onPressed: pickAndUpdatePhoto, 
                          icon: Icon(Icons.drive_file_rename_outline_outlined,),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  namaSiswa ?? "-",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "@${username ?? '-'}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 40),
                Divider(thickness: 2, indent: 30, endIndent: 30,),
                SizedBox(height: 40),

                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    
                     InkWell(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => EditProfile(
                              siswaData: siswaData!)));
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.mode_edit_outline_outlined, size: 30,),
                                SizedBox(width: 30,),
                            Text("Edit Profil", 
                              style: TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => HistoryListTran()
                              )
                            );
                      },

                      child: const Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer_outlined, size: 30,),
                                const SizedBox(width: 30,),
                            const Text("Riwayat Pemesanan", 
                              style: TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ),

              
                    const SizedBox(height: 30,),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },


                      child: const Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.logout_outlined, size: 30,),
                                const SizedBox(width: 30,),
                            const Text("Keluar", 
                              style: TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ),





                    


                  ],
                )


              ],
            ),
            
      ),
     
    );
  }
}