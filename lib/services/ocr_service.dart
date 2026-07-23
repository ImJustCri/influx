import "package:flutter/material.dart";
import 'package:flutter_native_ocr/flutter_native_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class OcrService extends StatelessWidget {
  const OcrService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<void> ocr_method() async{
    final ocrService= FlutterNativeOcr();
    final imagePicker=ImagePicker();
    String? _text;
    File? _image;

    final XFile? image= await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(image!=null){
      _image=File(image.path);
    }

    try{

      final



    }catch (e){
      print(e);
    }



  }
}










