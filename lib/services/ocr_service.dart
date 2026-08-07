import 'dart:math';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


class OcrService extends StatelessWidget {
  const OcrService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<String?> ocrMethod() async {
    final ImagePicker imagePicker = ImagePicker();

    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (image == null) {
      return "C'è stato un errore";
    }

    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final InputImage inputImage = InputImage.fromFilePath(image.path);

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    final List<TextLine> lines = [];

    for (TextBlock block in recognizedText.blocks) {
      lines.addAll(block.lines);
    }

    for (TextLine targetLine in lines) {
      final String targetText = targetLine.text.toUpperCase().trim();

      if (targetText.contains('TOTALE COMPLESSIVO')) {
        final Rect targetBox = targetLine.boundingBox;

        final double targetCenterY = targetBox.top + (targetBox.height / 2);


        for (TextLine line in lines) {
          if (line == targetLine) {
            continue;
          }

          final Rect box = line.boundingBox;

          final double centerY = box.top + (box.height / 2);

          final double differenzaY = (centerY - targetCenterY).abs();

          final bool stessaRiga = differenzaY < 15;

          final bool aDestra = box.left > targetBox.right;

          if (stessaRiga && aDestra) {
            final RegExp priceRegex = RegExp(r'\d+[,.]\s*\d{2}');

            final Match? match = priceRegex.firstMatch(line.text);

            if (match != null) {
              final String price = match.group(0)!.replaceAll(' ', '');
              await textRecognizer.close();

              return price;
            }
          }
        }
      }
    }

    await textRecognizer.close();

    return 'Prezzo non trovato';
  }
}














