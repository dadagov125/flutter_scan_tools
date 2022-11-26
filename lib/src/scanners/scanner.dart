import 'package:flutter_scan_tools/src/entities/scan_result.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'strategy/scanner_strategy.dart';

class Scanner<T extends ScanResult> {
  Scanner(
    ScannerStrategy<T> strategy,
  ) : _strategy = strategy;

  final ScannerStrategy<T> _strategy;

  Future<T> scan(InputImage image) async {
    return await _strategy.scan(image);
  }
}
