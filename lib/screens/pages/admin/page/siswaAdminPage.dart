import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kantin2_ukk/screens/pages/admin/editSiswa.dart';
import 'package:kantin2_ukk/screens/pages/admin/tambahSiswa.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class SiswaAdminPage extends StatefulWidget {
  const SiswaAdminPage({super.key});

  @override
  State<SiswaAdminPage> createState() => _SiswaAdminPageState();
}

class _SiswaAdminPageState extends State<SiswaAdminPage> {
  late Future<List<Map<String,dynamic>>> _siswaList;
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";

  @override
  void initState(){
    super.initState();

    _fetchSiswa();
  }

  void _fetchSiswa(){
    setState(() {
      _siswaList = Apiservices().getSiswa();
    });
  }

  Future<void> _deleteSiswa (String siswaId) async{
    final apiService = Apiservices();
    bool success = await apiService.hapusSiswa(siswaId: siswaId);

    if (success){
      setState(() {
        _siswaList = Apiservices().getSiswa();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Color.fromRGBO(36, 150, 137, 1),
            content: Text(
              "Siswa berhasil dihapus",
          )
        )
      );
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              "Gagal menghapus siswa ",
          )
        )
      );
    }
  }

  void _editSiswa(Map<String,dynamic> siswa) async {
    final result = await Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => EditSiswa(siswaData: siswa,)
      )
    );

    if (result == true){
      _fetchSiswa();
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _fetchSiswa();
        return true;
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50, left: 10, right: 10),
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
                    "Daftar Siswa",
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
                      builder: (context) => const TambahSiswa(),
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
            Expanded(
              child: FutureBuilder<List<Map<String,dynamic>>>(
                future: _siswaList, 
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if(snapshot.hasError){
                    return Center(
                      child: Text(
                        "Terjadi kesalahan: ${snapshot.error}",

                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty){
                    return const Center(
                      child: Text(
                        "Tidak ada data siswa"
                      ),
                    );
                  }
                  List<Map<String,dynamic>> siswaList = snapshot.data!;

                  return ListView.builder(
                    itemCount: siswaList.length,
                    itemBuilder: (context, index){
                      var siswa = siswaList[index];
                      return Slidable(
                        key: ValueKey(siswa['id']),
                        endActionPane: ActionPane(
                          motion: DrawerMotion(), 
                          children: [
                            SlidableAction(
                              onPressed: (_)=> _editSiswa(siswa),
                              backgroundColor: Color.fromRGBO(147, 147, 147, 1),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: "Edit",

                            ),
                            SlidableAction(
                              onPressed: (_){ showDialog(
                                context: context, 
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    "Hapus Siswa",
                                  ),
                                  content: const Text(
                                    "Apakah anda yakin ingin menghapus siswa ini?"
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: ()=> Navigator.pop(context), 
                                      child: const Text(
                                        "Batal",
                                        style: TextStyle(
                                          fontFamily: "Outfit",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: (){
                                        _deleteSiswa(siswa["id"].toString());
                                        Navigator.pop(context);
                                      }, 
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(
                                          fontFamily: "Outfit",
                                          color: Color.fromRGBO(240, 94, 94, 1)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              
                                );
                              },
                              backgroundColor: Color.fromRGBO(240, 94, 94, 1),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Hapus',
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 102,
                                  height: 102,
                                  child: siswa["foto"] == null || siswa ["foto"].isEmpty
                                    ? Image.asset("lib/assets/placehorder.jpg",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover)
                                    : Image.network(
                                      "$baseUrlRil${siswa["foto"]}",
                                        fit: BoxFit.cover,
                                        width: 102,
                                        height: 102,
                                        errorBuilder: (context, error, stackTrace) => 
                                          Image.asset("lib/assets/placehorder.jpg",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover
                                          ),

                                    ),
                                ),
                              ),

                              SizedBox(width: 8),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nama Lengkap: ${siswa["nama_siswa"]}",
                                    style: const TextStyle(
                                      fontFamily: "Outfit",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  
                                  SizedBox(width: 8),
                                  Text(
                                    "Username: ${siswa["username"]}",
                                    style: const TextStyle(
                                      fontFamily: "Outfit",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),

                                  SizedBox(width: 8),
                                  Text(
                                    "Alamat: ${siswa["alamat"]}",
                                    style: const TextStyle(
                                      fontFamily: "Outfit",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),


                                ],
                              )
                            ],
                          ),
                        )
                      );
                    }
                  );
                }
              )
            )
          ],
        ),
      ),
    );
  }
}