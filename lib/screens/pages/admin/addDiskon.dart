import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantin2_ukk/screens/components/buttonSimpan.dart';
import 'package:kantin2_ukk/screens/components/itemForm.dart';
import 'package:kantin2_ukk/services/apiServices.dart';

class AddDiskon extends StatefulWidget {
  const AddDiskon({super.key});

  @override
  State<AddDiskon> createState() => _AddDiskonState();
}

class _AddDiskonState extends State<AddDiskon> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController diskonController = TextEditingController();
  final TextEditingController presentaseController = TextEditingController();

  DateTime? tanggalMulai;
  DateTime? tanggalSelesai;

  bool isLoading = false;

  @override
  void initState(){
    super.initState();

  }

  void _updateButtonState(){
    setState(() {
      diskonController.addListener(_updateButtonState);
      presentaseController.addListener(_updateButtonState);
    });
  }

  bool get isFormValid{
    return diskonController.text.isNotEmpty &&
    presentaseController.text.isNotEmpty &&
    tanggalMulai != null &&
    tanggalSelesai != null &&
    !isLoading;

  }

  Future<void> _selectDate(BuildContext context, bool isMulai) async{
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2023), 
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey.shade300,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black
              )
            ),
          ), 
          child: child!);
      });

      if (picked != null){
        setState(() {
          if (isMulai){
            tanggalMulai = picked;
          } else {
            tanggalSelesai = picked;
          }
        });
        _updateButtonState();
      }
  }

  String formatData(DateTime? date){
    if (date==null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate() || !isFormValid) return;

    setState(() => isLoading = true);

    bool success = await Apiservices().tambahDiskon(
      namaDiskon: diskonController.text,
      presentase: int.parse(presentaseController.text),
      tanggalMulai: tanggalMulai!,
      tanggalSelesai: tanggalSelesai!,
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        content: Text(
          success
              ? 'Diskon berhasil ditambahkan!'
              : 'Gagal menambahkan diskon!',
          
        ),
      ),
    );

    if (success) Navigator.pop(context);
  }

  Widget buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, style: TextStyle(fontFamily: "Outfit"),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFFFFF5F3),
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value == null ? 'Pilih tanggal' : formatData(value),
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: value == null ? Colors.black : Colors.black
                  ),
                ),
                Icon(Icons.calendar_today, size: 20, color: Colors.black),
              ],
            ),
          ),
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
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
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Text(
                    "Tambah Diskon",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
                const SizedBox(height: 16),
                ItemForm(
                  labelText: "Nama Diskon", 
                  hintText: "Masukkan Nama Diskon",
                  inputType: TextInputType.text,
                  controller: diskonController,
                ),

                const SizedBox(height: 16),
                ItemForm(
                  labelText: "Persentase", 
                  hintText: "Masukkan dalam %",
                  inputType: TextInputType.number,
                  controller: diskonController,
                ),
                
                const SizedBox(height: 16,),
                buildDateField(
                  label: "Tanggal Mulai Diskon", 
                  value: tanggalMulai, 
                  onTap: ()=> _selectDate(context, true)
                ),
          
                const SizedBox(height: 16),
                buildDateField(
                  label: "Tanggal Selesai Diskon", 
                  value: tanggalSelesai, 
                  onTap: ()=> _selectDate(context, false)
                ),
          
                SizedBox(height: 32),
                ButtonSimpan(
                  hintText: isLoading ? "Menyimpan" : "Simpan", 
                  isEnabled: isFormValid, 
                  onPressed: submitForm)
          
                
          
                
          
          
          
              ],
            )),
        ),
      ),
    );
  }
}