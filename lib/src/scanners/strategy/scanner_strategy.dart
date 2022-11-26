import 'package:flutter_scan_tools/src/entities/scan_result.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class ScannerStrategy<T extends ScanResult> {
  Future<T> scan(InputImage image);
}
