import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadFoto extends StatefulWidget {
  final Function(File?) onImagePick;

  const UploadFoto({super.key, required this.onImagePick});

  @override
  State<UploadFoto> createState() => _UploadFotoState();
}

class _UploadFotoState extends State<UploadFoto> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });

      widget.onImagePick(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(185, 185, 185, 1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _selectedImage == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Upload Foto Makanan",
                    textAlign: TextAlign.center,
                  )
                ],
              )
            : Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
      ),
    );
  }
}
