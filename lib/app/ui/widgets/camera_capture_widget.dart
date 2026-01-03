// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
//
// class CameraCaptureWidget extends StatefulWidget {
//    CameraCaptureWidget({super.key, this.callback});
//
//   Function(XFile result)? callback;
//
//   @override
//   State<CameraCaptureWidget> createState() => _CameraCaptureWidgetState();
// }
//
// class _CameraCaptureWidgetState extends State<CameraCaptureWidget> {
//   CameraController? _controller;
//   XFile? _capturedImage;
//   bool _isCameraInitialized = false;
//   bool _isTakingPicture = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }
//
//   Future<void> _initCamera() async {
//     final cameras = await availableCameras();x
//     final camera = cameras.first; // دوربین اصلی (پشتی)
//
//     _controller = CameraController(
//       camera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     await _controller!.initialize();
//     setState(() {
//       _isCameraInitialized = true;
//     });
//   }
//
//   Future<void> _takePicture() async {
//     if (!_controller!.value.isInitialized || _isTakingPicture) return;
//
//     setState(() => _isTakingPicture = true);
//
//     try {
//       final image = await _controller!.takePicture();
//       setState(() {
//         _capturedImage = image;
//
//         if(widget.callback != null) {
//           widget.callback!(_capturedImage!);
//         }
//       });
//     } catch (e) {
//       debugPrint('Error taking picture: $e');
//     } finally {
//       setState(() => _isTakingPicture = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 3 / 4,
//       child: _capturedImage != null
//           ? Stack(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: Image.file(
//               File(_capturedImage!.path),
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 16,
//             child: Center(
//               child: FloatingActionButton(
//                 backgroundColor: Colors.black54,
//                 onPressed: () {
//                   setState(() => _capturedImage = null);
//                 },
//                 child: const Icon(Icons.close),
//               ),
//             ),
//           ),
//         ],
//       )
//           : _isCameraInitialized
//           ? Stack(
//         children: [
//           SizedBox(
//               width: double.infinity,
//               child: CameraPreview(_controller!)),
//           Positioned(
//             bottom: 16,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: FloatingActionButton(
//                 backgroundColor: Colors.white,
//                 onPressed: _takePicture,
//                 child: _isTakingPicture
//                     ? const CircularProgressIndicator(color: Colors.black)
//                     : const Icon(Icons.camera_alt, color: Colors.black),
//               ),
//             ),
//           ),
//         ],
//       )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
