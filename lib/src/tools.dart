import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scan_tools/src/entities/card_scan_options.dart';
import 'package:flutter_scan_tools/src/entities/card_scan_result.dart';
import 'package:flutter_scan_tools/src/views/card_scan_screen.dart';

import 'package:camera/camera.dart';

class FlutterScanTools {
  static Future<CardScanResul?> scanCard(BuildContext context,
      {CardScanOptions options = const CardScanOptions()}) async {
    final cameras = await availableCameras();

    final cameraDescription = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back);

    final scanResul =
        await Navigator.of(context).push<CardScanResul>(MaterialPageRoute(
            builder: (_) => CardScanScreen(
                  cameraDescription: cameraDescription,
                  options: options,
                )));
    return scanResul;
  }
}
