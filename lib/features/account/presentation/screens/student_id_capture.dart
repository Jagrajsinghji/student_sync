import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:student_sync/controller/api_controller.dart';
import 'package:student_sync/features/account/presentation/screens/text_recognition_painter.dart';
import 'package:student_sync/utils/constants/enums.dart';
import 'package:student_sync/utils/routing/app_router.dart';

class StudentIdCapture extends StatefulWidget {
  const StudentIdCapture({super.key});

  @override
  State<StudentIdCapture> createState() => _StudentIdCaptureState();
}

class _StudentIdCaptureState extends State<StudentIdCapture> {
  final APIController apiController = GetIt.I<APIController>();
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> _cameras = [];
  XFile? capturedImage;
  bool isLoading = false;

  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  int _cameraIndex = -1;
  TextRecognizerPainter? _painter;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    if (_cameras.isNotEmpty) _cameraIndex = 0;
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() async {
    _stopLiveFeed();
    _canProcess = false;
    _textRecognizer.close();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 80,
        ),
        const Text("Upload your Student ID", style: TextStyle(fontSize: 18)),
        Expanded(
          flex: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              capturedImage != null
                  ? CustomPaint(
                      foregroundPainter: _painter,
                      child: Image.file(File(capturedImage!.path)))
                  : Center(
                    child: FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (_cameras.isEmpty) {
                            return const Center(
                                child: Text("No cameras available in device"));
                          }
                          if (snapshot.connectionState == ConnectionState.done &&
                              _controller != null) {
                            return CameraPreview(
                              _controller!,
                              child: CustomPaint(painter: _painter),
                            );
                          } else {
                            return LoadingAnimationWidget.flickr(
                                leftDotColor: theme.primaryColor,
                                rightDotColor: theme.colorScheme.primary,
                                size: 50);
                          }
                        },
                      ),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: capturedImage != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                          onPressed: isLoading ? null : retake,
                          child: const Text("Retake")),
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ElevatedButton(
                            onPressed: uploadImage,
                            child: isLoading
                                ? LoadingAnimationWidget.flickr(
                                    leftDotColor: theme.primaryColor,
                                    rightDotColor: theme.colorScheme.secondary,
                                    size: 30)
                                : const Text("Upload")),
                      ),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: _clickPicture, child: const Text("Capture")),
        )
      ],
    ));
  }

  void retake() {
    _startLiveFeed();
    _painter = null;
    if (mounted) {
      setState(() {
        capturedImage = null;
      });
    }
  }

  void uploadImage() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      /// upload student id.
      String url = await apiController.uploadPhoto(
          file: File(capturedImage!.path), type: PhotoType.StudentId);

      ///update database
      var response = await apiController.updateUser(studentIdImage: url);
      if (response != null) {
        if (mounted) {
          apiController.updateUserOnboardingState(UserOnboardingState.idAdded);
          context.go(AppRouter.addSkills);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error while updating data $response",
            toastLength: Toast.LENGTH_LONG);
      }
    } on Exception catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
      Fluttertoast.showToast(
          msg: "Error while uploading the student ID. ${e.toString()}",
          toastLength: Toast.LENGTH_LONG);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _clickPicture() async {
    try {
      await _initializeControllerFuture;
      _stopLiveFeed();
      await _controller?.setFlashMode(FlashMode.off);
      capturedImage = await _controller?.takePicture();
      if (!mounted) return;
      if (capturedImage != null) {
        _processImage(InputImage.fromFilePath(capturedImage!.path));
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _processImage(InputImage? inputImage) async {
    if (inputImage == null) return;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      _painter = TextRecognizerPainter(
        recognizedText,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        CameraLensDirection.back,
      );
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _initializeControllerFuture = _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.startImageStream(
          (image) => _processImage(_inputImageFromCameraImage(image)));
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };
    if (_controller == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
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
