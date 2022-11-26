import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraToInputImageAdapter implements InputImage {
  CameraToInputImageAdapter({
    required this.cameraImage,
    required this.sensorOrientation,
  }) {
    _init();
  }

  final CameraImage cameraImage;
  final int sensorOrientation;

  late final Uint8List _bytes;
  late final InputImageData _inputImageData;

  void _init() {
    final WriteBuffer allBytes = WriteBuffer();
    var planes = cameraImage.planes;

    planes.forEach((plane) => allBytes.putUint8List(plane.bytes));
    _bytes = allBytes.done().buffer.asUint8List();

    final imageRotation =
        InputImageRotationValue.fromRawValue(sensorOrientation)!;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw)!;

    final planeData = planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    _inputImageData = InputImageData(
      size: Size(
        cameraImage.width.toDouble(),
        cameraImage.height.toDouble(),
      ),
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
  }

  @override
  Uint8List? get bytes => _bytes;

  @override
  String? get filePath => null;

  @override
  InputImageData? get inputImageData => _inputImageData;

  Map<String, dynamic> toJson() => {
        'bytes': bytes,
        'type': type.name,
        'path': filePath,
        'metadata': inputImageData == null ? 'none' : inputImageData!.toJson()
      };

  @override
  InputImageType get type => InputImageType.bytes;
}
