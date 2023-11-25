import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/features/account/presentation/controllers/AccountController.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class StudentIdCapture extends StatefulWidget {
  const StudentIdCapture({super.key});

  @override
  State<StudentIdCapture> createState() => _StudentIdCaptureState();
}

class _StudentIdCaptureState extends State<StudentIdCapture> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> cameras = [];
  XFile? capturedImage;

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  void _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) return;
    _controller = CameraController(cameras.first, ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text("Upload your Student ID", style: TextStyle(fontSize: 18)),
          Expanded(
            flex: 1,
            child: capturedImage != null
                ? Image.file(File(capturedImage!.path))
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (cameras.isEmpty) {
                            return const Center(
                                child: Text("No cameras available in device"));
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              _controller != null) {
                            return CameraPreview(_controller!);
                          } else {
                            return Center(
                                child: LoadingAnimationWidget.flickr(
                                    leftDotColor: theme.primaryColor,
                                    rightDotColor: theme.colorScheme.primary,
                                    size: 50));
                          }
                        },
                      ),
                      ClipPath(
                        clipper: CameraRectClip(),
                        child: Container(
                          color: theme.colorScheme.secondary,
                          height: double.maxFinite,
                          width: double.maxFinite,
                        ),
                      )
                    ],
                  ),
          ),
          if (capturedImage != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                      onPressed: retake, child: const Text("Retake")),
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                        onPressed: uploadImage, child: const Text("Upload")),
                  ),
                ),
              ],
            )
          else
            ElevatedButton(
                onPressed: _clickPicture, child: const Text("Capture"))
        ],
      )),
    );
  }

  void retake() {
    if (mounted) {
      setState(() {
        capturedImage = null;
      });
    }
  }

  void uploadImage() {
    //TODO: upload image and update profile
    GetIt.I<AccountController>()
        .updateUserOnboardingState(UserOnboardingState.idAdded);
    context.go(AppRouter.addSkills);
  }

  void _clickPicture() async {
    try {
      await _initializeControllerFuture;
      await _controller?.setFlashMode(FlashMode.off);
      capturedImage = await _controller?.takePicture();
      if (!mounted) return;
      if (capturedImage != null) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class CameraRectClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    path.lineTo(0, size.height / 4);
    path.lineTo(0, (3 * size.height) / 4);
    path.lineTo(size.width, (3 * size.height) / 4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
