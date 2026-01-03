import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:digi_care_pro/app/logic/upload_document_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_area_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:path/path.dart' as p;

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key, required this.missionId, required this.customerId});

  final String missionId;
  final String customerId;

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final UploadDocumentLogic logic = UploadDocumentLogic();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController titleController = TextEditingController();

  final List<XFile> capturedFiles = [];

  @override
  void initState() {
    Get.put(logic);
    super.initState();
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return;

    final compressed = await compressImage(photo);

    setState(() {
      capturedFiles.add(compressed);
    });
  }

  Future<XFile> compressImage(XFile file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 50,
      minWidth: 1280,
      minHeight: 1280,
    );

    return XFile(result!.path);
  }

  Future<File> _createPdfFromImages(List<XFile> images) async {
    final pdf = pw.Document();

    for (final image in images) {
      final bytes = await image.readAsBytes();
      final pdfImage = pw.MemoryImage(bytes);

      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(16),
          build: (context) {
            return pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain));
          },
        ),
      );
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf');

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadDocumentLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text('upload_document'.tr)),
          body: Padding(
            padding: const EdgeInsets.all(bodyPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: Text('taking_a_photo'.tr),
                      onPressed: _takePhoto,
                    ),
                  ),

                  const SizedBox(height: fieldSpace),

                  if (capturedFiles.isNotEmpty) ...[
                    Text('pictures_taken'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: capturedFiles.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(capturedFiles[index].path),
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    capturedFiles.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: fieldSpace),
                  ],

                  AppTextAreaField(title: 'short_title'.tr, controller: titleController),
                ],
              ),
            ),
          ),

          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: bodyPadding,
              right: bodyPadding,
              bottom: bodyPadding + MediaQuery.of(context).padding.bottom,
            ),
            child: PrimaryButton(
              enabled: capturedFiles.isNotEmpty,
              label: 'upload'.tr,
              onPressed: () async {
                final pdfFile = await _createPdfFromImages(capturedFiles);
                final pdfBytes = await pdfFile.readAsBytes();

                logic.upload(widget.missionId, widget.customerId, titleController.text, pdfBytes.toList());
              },
            ),
          ),
        );
      },
    );
  }
}
