//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/addDataStan.dart';
import 'package:kantin2_ukk/screens/pages/loginPage.dart';
import 'package:kantin2_ukk/screens/pages/siswa/homeSiswa.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isInvisible = true;
  List<String> items = ['Siswa', 'Admin stan']; //daftar dropdown 
  String? selectedRole; //nilai yang dipilih dari dropdown

  bool get isFormValid {
    return _namaController.text.isNotEmpty &&
    _emailController.text.isNotEmpty &&
    _usernameController.text.isNotEmpty &&
    _passwordController.text.isNotEmpty &&
    selectedRole != null;
  } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 45, left: 20 ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: const Text(
                      "Buat Akunmu", 
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 5),
                  const Text(
                    "Yuk, buat akun baru!",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w500    
                    ),
                  ),
        
        
                  const SizedBox(height: 40),
                  //input text field
                  Column(
                    children: [
        
                      //input nama
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextFormField(
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _namaController,
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
                            labelText: "Nama Lengkap",
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
                          controller: _emailController,
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
                            labelText: "Email ",
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

                      //input username
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _usernameController,
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
        
                      //input password
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: TextFormField(
                          obscureText: _isInvisible,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _passwordController,
                          decoration:  InputDecoration(
                      
                             focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffD74339),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey
                              )),
                            labelText: "Password",
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
                            
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  _isInvisible =! _isInvisible;
                                });
                              },
                              icon: Icon( 
                                _isInvisible ? Icons.visibility : Icons.visibility_off,
                                size: 17, 
                                color:  Colors.grey 
                              ),
                            ),
                          ),
                        ),
                      ),
        
                      //dropdown
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:  EdgeInsets.only(left: 5.0, bottom: 3),
                              child:  Text(
                                "Pilih role akunmu",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                  ),
                                ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10, left: 7),
                                child: DropdownButton<String>(
                                  underline: const SizedBox(),
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                  ),
                                  value: selectedRole,
                                  hint: const Text("Pilih", style: TextStyle(
                                    fontSize: 14,
                                  ),),
                                  isExpanded: true,
                                  items: items.map((String item){
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item, 
                                      
                                        style: const TextStyle(
                                          color: Colors.black
                                        ),)
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRole = newValue;
                                      }
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 140, right: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sudah punya akun?",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Outfit',
                                fontSize: 12, 
                                fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 5),
                              
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                },
                                child: const Text("Masuk di sini",
                                style: TextStyle(
                                  color: Color(0xffD74339),
                                  fontFamily: 'Outfit',
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 90, right: 20,bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor: isFormValid ? const Color(0xffD74339) : Color(0xffEBA19C) ,
                              foregroundColor: Colors.white
                            ),
                            onPressed: isFormValid ? (){
                              if (selectedRole == "Siswa"){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => HomePageSiswa()));
                              }
                              else{
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => AddDataStan()));
                              }
                              //isi if pilih siswa masuk halaman siswa, else masuk admin stan 
        
                            }
                              : null, //ketika tidak full diisi elevated button akan tdk bisa ditekan 
                            child: Text(
                              selectedRole == "Siswa" ? "Daftar" : "Selanjutnya",
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500    
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}