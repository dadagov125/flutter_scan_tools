import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_tools/src/entities/card_scan_options.dart';
import 'package:flutter_scan_tools/src/entities/card_scan_result.dart';
import 'package:flutter_scan_tools/src/scanners/scanner.dart';
import 'package:flutter_scan_tools/src/scanners/strategy/card_scanner_strategy/card_scanner_strategy.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'common_camera_vm.dart';

class CardScanScreenVM extends CommonCameraVM {
  CardScanScreenVM({
    required BuildContext context,
    required CameraDescription cameraDescription,
    required this.options,
  }) : super(context, cameraDescription: cameraDescription);

  final CardScanOptions options;
  late final TextRecognizer _recognizer;
  late final Scanner<CardScanResul> _scanner;

  @override
  void init() {
    _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    _scanner = Scanner(CardScannerStrategy(
      recognizer: _recognizer,
      requireExpiry: options.requireExpiry,
      requireHolder: options.requireHolder,
    ));

    super.init();
  }

  @override
  void dispose() {
    //возможно закроется до обработки последнего изображения
    _recognizer.close();
    super.dispose();
  }

  @override
  Future<void> onImage(InputImage image) async {
    try {
      final result = await _scanner.scan(image);

      if (options.requireExpiry && result.expiry == null) {
        return;
      }
      if (options.requireHolder && result.holder == null) {
        return;
      }

      dispose();
      Navigator.of(context).pop(result);
    } on Object catch (error) {
      debugPrint(error.toString());
    }
  }
}
