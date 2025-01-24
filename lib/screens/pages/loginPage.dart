import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kantin2_ukk/screens/pages/signupPage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isInvisible = true; 

  bool get isFormValid {
    return 
    _emailController.text.isNotEmpty &&
    _passwordController.text.isNotEmpty;
  } 


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 45, left: 20),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: const Text(
                      "Sign In", 
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                    ),
                  ),
        
                  const SizedBox(height: 5),
                  const Text(
                    "Login to Your Account",
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
                            labelText: "Email Kamu",
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
                            labelText: "Password kamu",
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
                        padding: const EdgeInsets.only(top: 300, right: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?",
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
                                child: const Text("Sign Up here",
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
                        padding: const EdgeInsets.only(top: 90, right: 20),
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
        
                            }
                              : null, //ketika tidak full diisi elevated button akan tdk bisa ditekan 
                            child: const Text(
                              "Sign Up",
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