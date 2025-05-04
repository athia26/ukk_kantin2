import 'package:flutter/material.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class AddDataStan extends StatefulWidget {
  final String namaLengkap;
  final String email;
  final String username; 
  final String password; 
  const AddDataStan({super.key, 
  required this.namaLengkap, 
  required this.email,
  required this.username,
  required this.password});

  @override
  State<AddDataStan> createState() => _AddDataStanState();
}

class _AddDataStanState extends State<AddDataStan> {
  final TextEditingController _namaStanController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  bool isLoading = false;

  bool get isFormValid {
    return _namaStanController.text.isNotEmpty &&
    _namaPemilikController.text.isNotEmpty &&
    _noTelpController.text.isNotEmpty;
    
  } 

  Future<void> registerAdminStan() async{
    setState(() {
      isLoading = true;
    });

    
    String namaStan = _namaStanController.text.trim();
    String namaPemilik = _namaPemilikController.text.trim();
    String noTelp = _noTelpController.text.trim();

    print("===Register Stan===");
    print("nama lengkap: ${widget.namaLengkap}");
    print("email: ${widget.email}");
    print("username: ${widget.username}");
    print("password: ${widget.password}");
    print("nama stan: $namaStan");
    print("nama pemilik: $namaPemilik");
    print("no telepon: $noTelp");


    try{
      var response = await Apiservices().registerStan(
        namaLengkap: widget.namaLengkap,
        email: widget.email,
        username: widget.username,
        password: widget.password,
        namaStan: namaStan, 
        namaPemilik: namaPemilik, 
        telp: noTelp);

        print("response dari api: $response");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil, silakan login!')),
        );

        Navigator.pushReplacementNamed(context, '/login');
    } catch(e){
      print("exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat registrasi"))
      );
    }

    setState(() {
      isLoading = false;
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 45, left: 20),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:  EdgeInsets.only(top: 50.0),
                    child:  Text(
                      "Tambah Data Stan", 
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                    ),
                  ),
        
                  const SizedBox(height: 5),
                  const Text(
                    "Selesaikan pendaftaran stan",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w500    
                    ),
                  ),
        
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      //input email
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _namaStanController,
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
        
                      //input password
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: TextFormField(
                          
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _namaPemilikController,
                          decoration:  const InputDecoration(
                      
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

                      //input notelp
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: TextFormField(
                          
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _noTelpController,
                          decoration:  const InputDecoration(
                      
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
                        : Padding(
                        padding: const EdgeInsets.only(top: 250, right: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor:  const Color(0xffD74339),
                              foregroundColor: Colors.white
                            ),
                            onPressed: (){
                              registerAdminStan();
                            },
                              
                            child: const Text(
                              "Daftar Stan",
                              style:  TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500    
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}