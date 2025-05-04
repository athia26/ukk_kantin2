import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class EditSiswa extends StatefulWidget {
  final Map<String, dynamic> siswaData;
  const EditSiswa({super.key, required this.siswaData});

  @override
  State<EditSiswa> createState() => _EditSiswaState();
}

class _EditSiswaState extends State<EditSiswa> {
  late TextEditingController namaLengkapController;
  late TextEditingController alamatController;
  late TextEditingController usernameController;
  late TextEditingController noTelpController;
  late TextEditingController emailController;
  File? _image;
  bool isLoading = false;
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";

  @override
  void initState() {
    super.initState();
    namaLengkapController =
        TextEditingController(text: widget.siswaData['nama_siswa']);
    alamatController = TextEditingController(text: widget.siswaData['alamat']);
    usernameController =
        TextEditingController(text: widget.siswaData['username']);
    noTelpController = TextEditingController(text: widget.siswaData['telp']);
    emailController = TextEditingController(text: widget.siswaData['email'] );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print("Gambar dipilih: ${pickedFile.path}");
    } else {
      print("Tidak ada gambar yang dipilih.");
    }
  }

  Future<void> _submitForm() async {
  // Debug: Cek nilai setiap controller
  print('Nama Lengkap: ${namaLengkapController.text}');
  print('Alamat: ${alamatController.text}');
  print('No Telepon: ${noTelpController.text}');
  print('Username: ${usernameController.text}');
  

  // Validasi apakah ada field yang kosong
  if (namaLengkapController.text.trim().isEmpty ||
      alamatController.text.trim().isEmpty ||
      noTelpController.text.trim().isEmpty ||
      usernameController.text.trim().isEmpty )
     {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromRGBO(240, 94, 94, 1),
        content: Text('Semua field harus diisi!'),
      ),
    );
    return;
  }

  setState(() => isLoading = true);
  print("Mengirim data...");
  print("Nama: ${namaLengkapController.text}");
  print("Alamat: ${alamatController.text}");
  print("Telepon: ${noTelpController.text}");
  print("Username: ${usernameController.text}");
  print("Email: ${emailController.text}");
  print("Foto: ${_image?.path ?? 'Tidak ada perubahan'}");

  try {
    bool success = await Apiservices().ubahSiswa(
      id: widget.siswaData['id'], 
      namaSiswa: namaLengkapController.text.trim(), 
      email: emailController.text.trim(), 
      username: usernameController.text.trim(), 
      alamat: alamatController.text.trim(), 
      noTelp: noTelpController.text.trim(),
      foto: _image,
    );

    if (success) {
      print("Siswa berhasil diperbarui!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(36, 150, 137, 1),
            content: Text('Siswa berhasil diperbarui!')),
      );
      Navigator.pop(context, true);
    } else {
      print("Gagal memperbarui siswa.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text('Gagal memperbarui data siswa.')),
      );
    }
  } catch (e) {
    print("Error saat memperbarui siswa: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Color.fromRGBO(240, 94, 94, 1),
          content: Text('Terjadi kesalahan saat memperbarui data siswa.')),
    );
  }

  setState(() => isLoading = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Siswa",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (widget.siswaData['foto'] != null
                              ? NetworkImage("$baseUrlRil${widget.siswaData["foto"]}")
                                  as ImageProvider
                              : null),
                      child: _image == null && widget.siswaData['foto'] == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    controller: namaLengkapController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD74339)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    controller: alamatController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD74339)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      labelText: "Alamat",
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
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    controller: noTelpController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD74339)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    controller: usernameController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD74339)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD74339),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Center(
                    child: Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
