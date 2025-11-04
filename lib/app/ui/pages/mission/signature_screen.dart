import 'dart:async';
import 'dart:ui' as ui;

import 'package:digi_care_pro/app/logic/mission_signature_logic.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureScreen extends StatefulWidget {
  SignatureScreen({super.key,required this.missionId});

  String missionId;

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {

  MissionSignatureLogic logic = MissionSignatureLogic();
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    Get.put(logic);

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MissionSignatureLogic>(builder: (logic) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(bodyPadding),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme
                        .of(context)
                        .disabledColor),
                  ),
                  child: SfSignaturePad(
                    key: signatureGlobalKey,
                    strokeColor: Colors.black,
                  ),
                ),
                PositionedDirectional(
                  end: 0, bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(bodyPadding),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            final signature = signatureGlobalKey.currentState!;
                            final image = await signature.toImage(); // ui.Image
                            final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                            final Uint8List pngBytes = byteData!.buffer.asUint8List();

                            logic.upload(widget.missionId, pngBytes.toList());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(cardRadius),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                'assets/icons/tick.svg',
                                width: 32,
                                height: 32,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            signatureGlobalKey.currentState!.clear();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(cardRadius),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                'assets/icons/eraser.svg',
                                width: 32,
                                height: 32,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(cardRadius),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                'assets/icons/mul.svg',
                                width: 32,
                                height: 32,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
