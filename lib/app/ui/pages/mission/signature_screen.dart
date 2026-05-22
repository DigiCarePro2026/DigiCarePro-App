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
            child: Row(
              children: [
                Expanded(
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
                      ),Positioned(
                          left: 50,
                          bottom: 50,
                          child: Text(
                            'X.........................',
                            style: Theme.of(context).textTheme.titleMedium,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: bodyPadding),
                  child: Column(
                    children: [
                      _button(
                        context,
                        color: AppColors.green,
                        icon: 'assets/icons/tick.svg',
                        label: 'submit'.tr,
                        onTap: () async {
                          final signature = signatureGlobalKey.currentState!;
                          final image = await signature.toImage();
                          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                          final Uint8List pngBytes = byteData!.buffer.asUint8List();
                          logic.upload(widget.missionId, false, pngBytes.toList());
                        },
                      ),
                      const SizedBox(height: 8),
                      _button(
                        context,
                        color: AppColors.blue,
                        icon: 'assets/icons/forward.svg',
                        label: 'without_sign'.tr,
                        onTap: () async {
                          logic.upload(widget.missionId, true, null);
                        },
                      ),
                      const SizedBox(height: 8),
                      _button(
                        context,
                        color: AppColors.yellow,
                        icon: 'assets/icons/eraser.svg',
                        label: 'clear'.tr,
                        onTap: () {
                          signatureGlobalKey.currentState!.clear();
                        },
                      ),
                      const SizedBox(height: 8),
                      _button(
                        context,
                        color: AppColors.red,
                        icon: 'assets/icons/mul.svg',
                        label: 'cancel'.tr,
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _button(
      BuildContext context, {
        required Color color,
        required String icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardRadius),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          width: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
