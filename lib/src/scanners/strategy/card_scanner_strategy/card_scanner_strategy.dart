import 'dart:math';

import 'package:flutter_scan_tools/src/entities/card_number.dart';
import 'package:flutter_scan_tools/src/entities/card_scan_result.dart';
import 'package:flutter_scan_tools/src/scanners/strategy/scanner_strategy.dart';
import 'package:google_mlkit_commons/src/input_image.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

part 'card_template.dart';
part 'templates.dart';

class CardScannerStrategy extends ScannerStrategy<CardScanResul> {
  CardScannerStrategy({
    required this.recognizer,
    this.requireHolder = false,
    this.requireExpiry = false,
  });

  final TextRecognizer recognizer;
  final bool requireHolder;
  final bool requireExpiry;

  @override
  Future<CardScanResul> scan(InputImage image) async {
    CardNumber? cardNumber;
    String? expiry;
    String? holder;
    final recognizedText = await recognizer.processImage(image);
    final blocks = recognizedText.blocks;
    for (final block in blocks) {
      final lines = block.lines;
      for (final line in lines) {
        final text = line.text;
        if (cardNumber == null) {
          final scanedCardNumber = scanCardNumber(text);
          if (scanedCardNumber != null) {
            cardNumber = scanedCardNumber;
            continue;
          }
        }
        if (requireExpiry && expiry == null) {
          final scanedExpiry = _scanRegex(text, _expiryRegex);
          if (scanedExpiry != null) {
            expiry = scanedExpiry;
            continue;
          }
        }
        if (requireHolder && holder == null) {
          final scanedHolder = _scanRegex(text, _holderRegex);
          if (scanedHolder != null) {
            holder = scanedHolder;
            continue;
          }
        }
      }
    }

    if (cardNumber == null) {
      throw Exception('Card number not found');
    }

    return CardScanResul(
      cardNumber: cardNumber,
      expiry: expiry,
      holder: holder,
    );
  }

  CardNumber? scanCardNumber(String text) {
    print(text);
    final replacedText = text.replaceAll(_nonDigitsRegExp, '');
    print(replacedText);
    final scannedDigits = _scanRegex(replacedText, _cardDigitsRegExp);
    if (scannedDigits != null) {
      var cardData = findCardTemplate(scannedDigits);
      if (cardData != null) {
        return CardNumber(type: cardData.type, number: scannedDigits);
      }
    }
    return null;
  }

  String? _scanRegex(String text, RegExp regExp) {
    final firstMatch = regExp.firstMatch(text);
    if (firstMatch != null) {
      return firstMatch.group(0);
    }
    return null;
  }

  CardTemplate? findCardTemplate(String digits) {
    if (digits.isEmpty) {
      return null;
    }
    for (int i = digits.length; i > 0; i--) {
      final code = int.parse(digits.substring(0, i));
      final cardTemplates = _cardTemplates.where((card) {
        return card.code.isThereValue(code) &&
            card.length.isThereValue(digits.length);
      }).toList();

      if (cardTemplates.length == 1) {
        return cardTemplates[0];
      }
    }
    return null;
  }
}
