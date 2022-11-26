import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_tools/src/adapters/camera_to_input_image_apadter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'view_model.dart';

abstract class CommonCameraVM extends ViewModel with WidgetsBindingObserver {
  CommonCameraVM(
    super.context, {
    required CameraDescription cameraDescription,
    Duration scanPauseDuration = const Duration(milliseconds: 300),
  })  : _scanPauseDuration = scanPauseDuration,
        _cameraDescription = cameraDescription;

  final ValueNotifier<CameraController?> cameraControllerState =
      ValueNotifier<CameraController?>(null);

  final ValueNotifier<bool> flashEnabledState = ValueNotifier(false);

  final CameraDescription _cameraDescription;
  final Duration _scanPauseDuration;

  CameraController? get _controller => cameraControllerState.value;
  Timer? _timer;
  bool _canScan = true;
  bool _isScanning = false;

  @override
  void init() {
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    super.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    cameraControllerState.value = null;
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? oldController = _controller;
    if (oldController == null || !oldController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      oldController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    final CameraController? oldController = _controller;
    if (oldController != null) {
      cameraControllerState.value = null;
      await oldController.dispose();
    }

    CameraController newController = CameraController(
        _cameraDescription, ResolutionPreset.max,
        enableAudio: false);

    newController.addListener(() {
      if (newController.value.hasError) {
        showMessage('${newController.value.errorDescription}');
      }
    });

    try {
      await newController.initialize();
      cameraControllerState.value = newController;
      await newController.setFlashMode(FlashMode.auto);
      await newController.setFocusMode(FocusMode.auto);
    } on CameraException catch (e) {
      showMessage(e.description ?? '');
    }

    _initTimer();

    try {
      await newController.startImageStream(_processCameraImage);
    } on Exception catch (e) {
      showMessage(e.toString());
    }
  }

  _initTimer() {
    Timer? oldTimer = _timer;
    if (oldTimer != null) {
      _timer = null;
      oldTimer.cancel();
    }
    _timer = Timer.periodic(_scanPauseDuration, (_) {
      _canScan = true;
    });
  }

  Future _processCameraImage(CameraImage image) async {
    if (!_canScan) {
      return;
    }
    if (_isScanning) {
      return;
    }

    _canScan = false;
    _isScanning = true;
    print('>>>>>> Scan Start');

    try {
      var adapter = CameraToInputImageAdapter(
          cameraImage: image,
          sensorOrientation: _controller!.description.sensorOrientation);

      await onImage(adapter);
    } catch (error) {
      print(error);
    }

    _isScanning = false;
    print('>>>>>> Scan End');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> onImage(InputImage image);

  Future<void> toggleFlash() async {
    final value = flashEnabledState.value;
    if (value) {
      await _controller?.setFlashMode(FlashMode.off);
    } else {
      await _controller?.setFlashMode(FlashMode.torch);
    }
    flashEnabledState.value = !value;
  }
}
