import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

TextBlock createBlock(List<String> lines) {
  return TextBlock(
      text: '',
      recognizedLanguages: [],
      boundingBox: Rect.zero,
      cornerPoints: [],
      lines: lines.map(createLine).toList());
}

TextLine createLine(String line) {
  return TextLine(
    text: line,
    elements: [],
    recognizedLanguages: [],
    boundingBox: Rect.zero,
    cornerPoints: [],
  );
}
