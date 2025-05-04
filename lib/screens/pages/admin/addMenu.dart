import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kantin2_ukk/screens/components/buttonSimpan.dart';
import 'package:kantin2_ukk/screens/components/checkboxItem.dart';
//import 'package:kantin2_ukk/screens/components/helloAdmin.dart';
import 'package:kantin2_ukk/screens/components/itemForm.dart';
import 'package:kantin2_ukk/screens/components/uploadFoto.dart';
import 'package:kantin2_ukk/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  bool isButtonEnabled = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  File? selectedImage;

  
  void checkFormCompletion(){
    setState(() {
      isButtonEnabled = nameController.text.isNotEmpty && priceController.text.isNotEmpty && descController.text.isNotEmpty && selectedType != null;
    });
  }


  @override
  void initState(){
    super.initState();
    nameController.addListener(checkFormCompletion);
    priceController.addListener(checkFormCompletion);
    descController.addListener(checkFormCompletion);
  }


  @override
  void dispose(){
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  void onImageSelected (File image){
    setState(() {
      selectedImage = image;
      checkFormCompletion();
    });
  }

  Future<void> submitForm() async{
    if (!_formKey.currentState!.validate()){
      print("Form tidak valid");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final makerIDString = prefs.getString('maker_id');
    final makerID = makerIDString != null ? int.tryParse(makerIDString) : null;

    if (makerID == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.grey,
        content: Text('Maker ID tidak ditemukan atau tidak valid!')
      )
    );
    return;
  }

    bool success = await Apiservices().tambahMenu(
      namaMakanan: nameController.text, 
      jenis: selectedType!, 
      harga: priceController.text, 
      deskripsi: descController.text,
      foto: selectedImage,
      makerID: makerID,
      );

      if(success){
        print("Menu berhasil ditambahkan!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              'Menu berhasil ditambahkan!')
              )
              
        );
        Navigator.pop(context);
        setState(() {});
      } else{
        print("Gagal menambahkan menu!");
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              'Gagal menambahkan menu!')
              )
              
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Container(
            padding: const EdgeInsets.only(top: 30, right: 30, left: 30, bottom: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                    IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      },
                        icon: Icon(Icons.arrow_back_ios_new_rounded)
                      ),
              
                          const Text(
                            "Tambah Menu Baru",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                 
                  const SizedBox(height: 16), 
                  ItemForm(
                    labelText: "Nama Item",
                    hintText: "Masukkan Nama Item",
                    inputType: TextInputType.text,
                    controller: nameController,
                  ),
                  const SizedBox(height: 16),
                  ItemForm(
                    labelText: "Harga dan Tipe",
                    hintText: "Rp,-",
                    inputType: TextInputType.number,
                    controller: priceController,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      Center(
                        child: Row(
                          children: [
                            CheckboxItem(
                              label: "Makanan",
                              isSelected: selectedType == 'makanan',
                              onChanged: (value) {
                                setState(() {
                                  selectedType = "makanan";
                                  checkFormCompletion();
                                });
                              },
                            ),
                        
                            CheckboxItem(
                              label: "Minuman",
                              isSelected: selectedType == 'minuman',
                              onChanged: (value) {
                                setState(() {
                                  selectedType = "minuman";
                                  checkFormCompletion();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const Text(
                        "Upload Foto",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      UploadFoto(
                        onImagePick: (File? image) {
                          if (image != null) {
                            setState(() {
                              selectedImage = image;
                              checkFormCompletion();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      ItemForm(
                        labelText: "Deskripsi",
                        hintText: "Deskripsi",
                        inputType: TextInputType.text,
                        controller: descController,
                      ),
                      const SizedBox(height: 32),
                      ButtonSimpan(
                        hintText: "Simpan",
                        isEnabled: isButtonEnabled,
                        onPressed: submitForm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}