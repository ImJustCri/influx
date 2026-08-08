import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../models/receipt_data.dart';

class OcrService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<ReceiptData?> extractTotalFromReceipt() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image == null) return null;

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      final List<TextLine> allLines = recognizedText.blocks
          .expand((block) => block.lines)
          .toList();

      if (allLines.isEmpty) return null;

      // 1. Extract Title (Usually the first non-empty line at the top)
      String? extractedTitle = _extractTitle(allLines);

      // 2. Extract Total Price
      String? extractedTotal = _extractTotal(allLines);

      return ReceiptData(
        title: extractedTitle,
        total: extractedTotal,
      );
    } catch (e) {
      debugPrint('OCR Error: $e');
      return null;
    } finally {
      await textRecognizer.close();
    }
  }

  /// Extracts the main title/merchant name from top lines
  String? _extractTitle(List<TextLine> lines) {
    for (final line in lines) {
      final text = line.text.trim();
      // Skip very short text, dates, or common headers
      if (text.length > 2 && !_isNumericOrDate(text)) {
        return text;
      }
    }
    return null;
  }

  /// Extracts the total amount
  String? _extractTotal(List<TextLine> lines) {
    final RegExp priceRegex = RegExp(r'\d+[,.]\s*\d{2}');

    for (final targetLine in lines) {
      final String text = targetLine.text.toUpperCase().trim();

      if (text.contains('TOTALE COMPLESSIVO') || text.contains('TOTALE')) {
        // Check same line
        final Match? sameLineMatch = priceRegex.firstMatch(text);
        if (sameLineMatch != null) {
          return _cleanPrice(sameLineMatch.group(0)!);
        }

        // Check neighboring lines
        final Rect targetBox = targetLine.boundingBox;
        final double targetCenterY = targetBox.top + (targetBox.height / 2);

        for (final candidateLine in lines) {
          if (candidateLine == targetLine) continue;

          final Rect box = candidateLine.boundingBox;
          final double centerY = box.top + (box.height / 2);

          final bool isSameRow = (centerY - targetCenterY).abs() < 20;
          final bool isToTheRight = box.left >= (targetBox.left + 50);

          if (isSameRow && isToTheRight) {
            final Match? candidateMatch = priceRegex.firstMatch(candidateLine.text);
            if (candidateMatch != null) {
              return _cleanPrice(candidateMatch.group(0)!);
            }
          }
        }
      }
    }
    return null;
  }

  bool _isNumericOrDate(String text) {
    // Basic check to skip dates/numbers when identifying the store title
    return RegExp(r'^[\d\s./:-]+$').hasMatch(text);
  }

  String _cleanPrice(String rawPrice) {
    return rawPrice.replaceAll(' ', '').replaceAll(',', '.');
  }
}