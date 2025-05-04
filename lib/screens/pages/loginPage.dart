import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/pages/signupPage.dart';
import 'package:kantin2_ukk/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool _isInvisible = true; 
  String? selectedRole;
  List<String> items = ['Siswa', 'Admin stan']; //daftar dropdown 

  bool get isFormValid {
    return 
    _usernameController.text.isNotEmpty &&
    _passwordController.text.isNotEmpty &&
    selectedRole != null;
  } 


  @override 
  void initState(){
    super.initState();
    selectedRole = items.first;
    print ("initstate - selected role : $selectedRole");
  }

  Future <void> login() async{
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    print("Selected role: $selectedRole");
  
  try{
    var response;
    
    print("Selected role: $selectedRole");
    print("mulai login...");
    print("sebelum panggil API");

      if (selectedRole?.toLowerCase() == 'siswa'){
        print("panggil api: loginSiswa");
        response = await Apiservices().loginSiswa(username: username, password: password);

      }else{
        print("panggil api: loginstand");
        response = await Apiservices().loginStand(username: username, password: password);
      }
      
      print("setelah panggil api");
      print("Full Login response ($selectedRole): $response");

      if (response != null && response is Map<String, dynamic> && response.containsKey('statusCode')) {
      print("Response status: ${response['statusCode']}");
    }
    
    //pengecekan pakai debug untuk cek aja 
      print("DEBUG: Apakah response null? ${response == null}");
      print("DEBUG: Apakah response Map? ${response is Map<String, dynamic>}");
      

      if (response is Map<String, dynamic>) { // Pastikan ini map dulu biar nggak error
        print("DEBUG: Apakah response punya 'access_token'? ${response.containsKey('access_token')}");
        print("DEBUG: Apakah response punya 'user'? ${response.containsKey('user')}");
      }
    //pengecekan pakai debug untuk cek aja 

      if (response != null && response is Map<String,dynamic> &&response.containsKey('token')){
        String token = response['token'] ?? '';
        String? role = response ['role'] ?? '';
        String? idStan = response ['maker_id']?.toString() ?? '';

        print("Login sukses! Token: $token, Role: $role, ID Stan: $idStan");

        await saveLoginData(token, role, idStan);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login sukses")));
      } else {
        print("login gagal! ");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Gagal')));
      }
    } catch(e){
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("tejadi kesalahan")));
    }
    

    setState(() {
      isLoading = false;
    });

    
  }

  Future <void> saveLoginData(
      String token, String? role, String? makerId) async{
        if (role == null){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: Role is null!")),
          );
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', role);

        if (role == 'admin_stan'){
          if (makerId != null && makerId.isNotEmpty){
            await prefs.setString('maker_id', makerId);
            print("maker_id berhasil disimpan: $makerId");

          } else if(role == 'admin_stan'){
          print('warning: makerId NULL atau kosong!');
          
        } 
        }
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login berhasil sebagai $role")),
        );

        if (role == 'siswa'){
          Navigator.pushReplacementNamed(context, '/homeSiswa');
        } else if(role == 'admin_stan'){
          Navigator.pushReplacementNamed(context, '/homeAdmin');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Role tidak valid'))
          );
        }
      }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                      "Login Dulu", 
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                    ),
                  ),
        
                  const SizedBox(height: 5),
                  const Text(
                    "Ayo lanjut ke akunmu!",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w500    
                    ),
                  ),
        
                  const SizedBox(height: 40),
                  Column(
                    children: [
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
                        padding: const EdgeInsets.only(right: 20, top: 20),
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
                        padding: const EdgeInsets.only(top: 150, right: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Tidak punya akun?",
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                                },
                                child: const Text("Daftar disini",
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
                        padding: const EdgeInsets.only(top: 150, right: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor: isFormValid ? const Color(0xffD74339) :  const Color(0xffEBA19C) ,
                              foregroundColor: Colors.white
                            ),
                            onPressed: isFormValid ? ()  {
                             

                                login();

                               
                            }
                              : null, //ketika tidak full diisi elevated button akan tdk bisa ditekan 
                            child: isLoading 
                            ? const CircularProgressIndicator() 
                            : const Text(
                              "Masuk",
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