import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter_native_ocr/flutter_native_ocr.dart';


class OcrService extends StatelessWidget {
  const OcrService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  Future<String?> ocrMethod() async{
    final ImagePicker imagePicker = ImagePicker();
    String? text;
    final XFile? image= await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if(image!=null){
      String path= image.path;


      final testo= await FlutterTesseractOcr.extractText(
          path,
          language: "ita",
          args: {
            "psm" : "4"
          }
      );

      text=estraiImporto(testo);
      return text;
    }
    return "C'è stato un errore";


  }
  String? estraiImporto(String testo) {

    List<String> righe = testo.split("\n");

    for (String riga in righe) {

      String pulita = riga.toUpperCase();

      if (pulita.contains("IMPORTO PAGATO") || pulita.contains("TOTALE COMPLESSIVO")) {

        RegExp regex = RegExp(r'\d+[,.]\d{2}');

        Match? match = regex.firstMatch(pulita);

        if (match != null) {
          return match.group(0);
        }
      }
    }

    return null;
  }
}














