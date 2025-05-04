import 'dart:io';
import 'dart:convert'; // Import jsonEncode
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class CetakNotaSiswa extends StatelessWidget {
  final Map<String, dynamic> dataTransaksi;

  CetakNotaSiswa({required this.dataTransaksi});

  Future<void> generatePdf() async {
    try {
      // Mendapatkan path direktori dokumen aplikasi untuk iOS
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/nota.pdf';

      // Membuat dokumen PDF menggunakan package pdf
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            // Mengonversi dataTransaksi menjadi string menggunakan jsonEncode
            String dataTransaksiString = jsonEncode(dataTransaksi);

            return pw.Center(
              child: pw.Text(dataTransaksiString, style: pw.TextStyle(fontSize: 12)), // Menampilkan data transaksi di PDF
            );
          },
        ),
      );

      // Menyimpan file PDF ke dalam direktori aplikasi
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Menampilkan notifikasi atau feedback
      print("PDF berhasil disimpan di: $filePath");
    } catch (e) {
      print("Terjadi error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cetak Nota Siswa"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            generatePdf(); // Memanggil fungsi untuk membuat dan menyimpan PDF
          },
          child: Text("Cetak Nota"),
        ),
      ),
    );
  }
}
