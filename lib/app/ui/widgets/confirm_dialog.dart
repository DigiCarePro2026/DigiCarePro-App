import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FrostedGlassDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<DialogButtonModel> buttons;

  const FrostedGlassDialog({super.key, required this.title, required this.message, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              // Slight gradient + translucency to mimic iOS-style sheet
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(130),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withAlpha(89)),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 20, offset: const Offset(0, 6))],
              ),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(title, style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle / description
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(height: 24),
                  ListView.builder(
                    itemCount: buttons.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) => _buildPillButton(context, buttonModel: buttons[index]),
                  ),
                  const SizedBox(height: 10),
                  _buildPillButton(
                    context,
                    buttonModel: DialogButtonModel(label: 'cancel'.tr, onTap: () {}),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(BuildContext context, {required DialogButtonModel buttonModel}) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            Navigator.of(context).pop();

            buttonModel.onTap.call();
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(100),
              borderRadius: BorderRadius.circular(28),
              // subtle inner shadow / sheen
            ),
            child: Center(
              child: Text(
                buttonModel.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: buttonModel.labelColor ?? Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogButtonModel {
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  DialogButtonModel({required this.label, this.labelColor, required this.onTap});
}
