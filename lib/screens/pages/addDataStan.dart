import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/admin/homeAdmin.dart';
import 'package:kantin2_ukk/screens/pages/signupPage.dart';

class AddDataStan extends StatefulWidget {
  const AddDataStan({super.key});

  @override
  State<AddDataStan> createState() => _AddDataStanState();
}

class _AddDataStanState extends State<AddDataStan> {
  final TextEditingController _namaStanController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  bool get isFormValid {
    return _namaStanController.text.isNotEmpty &&
    _namaPemilikController.text.isNotEmpty &&
    _noTelpController.text.isNotEmpty;
    
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      
                             focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffD74339),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey
                              )),
                            labelText: "Nama Pemilik",
                            floatingLabelStyle: const TextStyle(
                              color: Color(0xffD74339),
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,  
                            ),
                            labelStyle: const TextStyle(
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
                      
                             focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffD74339),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey
                              )),
                            labelText: "No Telepon",
                            floatingLabelStyle: const TextStyle(
                              color: Color(0xffD74339),
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,  
                            ),
                            labelStyle: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,  
                            ),
                            
                            
                          ),
                        ),
                      ),
        
                      
        
                      Padding(
                        padding: const EdgeInsets.only(top: 250, right: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor: isFormValid ? const Color(0xffD74339) :  Color(0xffEBA19C) ,
                              foregroundColor: Colors.white
                            ),
                            onPressed: isFormValid ? (){
                              //isi if pilih siswa masuk halaman siswa, else masuk admin stan 
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) =>HomePageAdmin()));
                            }
                              : null, //ketika tidak full diisi elevated button akan tdk bisa ditekan 
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