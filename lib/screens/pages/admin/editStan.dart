import 'package:flutter/material.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class Editstan extends StatefulWidget {
  final Map<String, dynamic>  stanData;

  const Editstan({super.key, required this.stanData});

  @override
  State<Editstan> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Editstan> {
  late TextEditingController namaLengkapController;
  late TextEditingController namaStanController;
  late TextEditingController usernameController;
  late TextEditingController noTelpController;
  bool isLoading = false;

  @override

  void initState() {
    super.initState();
    namaLengkapController = 
      TextEditingController(text: widget.stanData['nama_pemilik']);
    namaStanController = 
      TextEditingController(text: widget.stanData['nama_stan']);
    usernameController = 
      TextEditingController(text: widget.stanData['username']);
      noTelpController = 
      TextEditingController(text: widget.stanData['telp']);
  }

  Future <void> updateStan() async{
    setState(() => isLoading = true);
    print("===Mengupdate data stan===");
    print("Nama Pemilik: ${namaLengkapController.text}");
    print("Nama Stan: ${namaStanController.text}");
    print("Username: ${usernameController.text}");
    print("No Telp: ${noTelpController.text}");

    try {
      await Apiservices().updateStan(
        id: widget.stanData['id'], 
        namaStan: namaStanController.text.trim(), 
        namaPemilik: namaLengkapController.text.trim(), 
        telp: noTelpController.text.trim(), 
        username: usernameController.text.trim()
        );

        print("Stan berhasil diperbarui");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stan berhasil diperbarui'))
        );

        Navigator.pop(context,true);
    } catch (e) {
      print("error saat memperbarui stan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ada kesalahaan saat memperbarui data stan'))
        );
    }

    setState(() => isLoading = false,);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Edit Stan"),
                Padding(
                          padding: const EdgeInsets.only(right: 20, top: 10),
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            controller: namaLengkapController,
                            decoration: const InputDecoration(
                        
                               focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffD74339),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                )),
                              labelText: "Nama Pemilik",
                              floatingLabelStyle: TextStyle(
                                color: Color(0xffD74339),
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                            ),
                          ),
                        ),

                      Padding(
                          padding: const EdgeInsets.only(right: 20, top: 10),
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            controller: namaStanController,
                            decoration: const InputDecoration(
                        
                               focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffD74339),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                )),
                              labelText: "Nama Stan",
                              floatingLabelStyle: TextStyle(
                                color: Color(0xffD74339),
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                            ),
                          ),
                        ),
                      
                      Padding(
                          padding: const EdgeInsets.only(right: 20, top: 10),
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            controller: usernameController,
                            decoration: const InputDecoration(
                        
                               focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffD74339),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                )),
                              labelText: "Username",
                              floatingLabelStyle: TextStyle(
                                color: Color(0xffD74339),
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                            ),
                          ),
                        ),
                      
                      Padding(
                          padding: const EdgeInsets.only(right: 20, top: 10),
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            controller: noTelpController,
                            decoration: const InputDecoration(
                        
                               focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffD74339),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                )),
                              labelText: "No Telepon",
                              floatingLabelStyle: TextStyle(
                                color: Color(0xffD74339),
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,  
                              ),
                            ),
                          ),
                        ),

                        isLoading 
                        ? const Center(child: CircularProgressIndicator(),)
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor:  const Color(0xffD74339),
                              foregroundColor: Colors.white
                            ),
                          onPressed: updateStan, 
                          child: const Text(
                              "Perbarui ",
                              style:  TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500    
                              ),
                            ),  
                          )

              ],
            ),
          ),
        )),
    );
  }
}