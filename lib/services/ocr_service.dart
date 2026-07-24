import "package:flutter/material.dart";
import 'package:flutter_native_ocr/flutter_native_ocr.dart';
import 'package:image_picker/image_picker.dart';


class OcrService extends StatelessWidget {
  const OcrService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<String?> ocr_method() async{
    final ocrService= FlutterNativeOcr();
    final imagePicker=ImagePicker();
    String? _text;

    final XFile? image= await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(image!=null) {
      try {
        final temp = await ocrService.recognizeText(image.path);

        return _text= temp.isNotEmpty ? temp : "Nessun testo trovato";

      } catch (e) {
        print(e);
      }
    }



  }
}










