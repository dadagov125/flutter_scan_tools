import 'package:flutter_scan_tools/src/entities/card_scan_options.dart';
import 'package:flutter_scan_tools/src/view_models/card_scan_screen_vm.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';

class CardScanScreen extends StatefulWidget {
  const CardScanScreen({
    super.key,
    required this.cameraDescription,
    required this.options,
  });

  final CameraDescription cameraDescription;
  final CardScanOptions options;

  @override
  State<StatefulWidget> createState() => _CardScanScreenState();
}

class _CardScanScreenState extends State<CardScanScreen> {
  late final CardScanScreenVM vm;

  @override
  void initState() {
    vm = CardScanScreenVM(
      context: context,
      cameraDescription: widget.cameraDescription,
      options: widget.options,
    );
    vm.init();

    super.initState();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  Widget get _flashlightButton {
    return ValueListenableBuilder<bool>(
      valueListenable: vm.flashEnabledState,
      builder: (_, state, __) {
        final icon = state ? Icons.flashlight_on : Icons.flashlight_off;
        return IconButton(onPressed: () => vm.toggleFlash(), icon: Icon(icon));
      },
    );
  }

  Widget get _overlay {
    return widget.options.overlay ??
        Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),
                  BlendMode.srcOut), // This one will create the magic
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              backgroundBlendMode: BlendMode
                                  .dstOut), // This one will handle background + difference out
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: constraints.maxWidth,
                                height: constraints.maxWidth * 0.63,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red,
                        width: 3,
                      ),
                    ),
                    width: constraints.maxWidth,
                    height: constraints.maxWidth * 0.63,
                  );
                },
              ),
            ),
          ],
        );
  }

  Widget get _cameraView {
    return ValueListenableBuilder<CameraController?>(
      valueListenable: vm.cameraControllerState,
      builder: (context, controller, __) {
        if (controller == null || !controller.value.isInitialized) {
          return Container(
            color: Colors.black,
          );
        }

        return CameraPreview(controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ConstrainedBox(
      constraints: BoxConstraints(),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [_flashlightButton],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _cameraView,
          _overlay,
        ],
      ),
    );
  }
}
