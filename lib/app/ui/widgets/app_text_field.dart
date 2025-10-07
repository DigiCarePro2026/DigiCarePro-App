import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_dimens.dart' show fieldRadius;

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.title,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.keyboardType,
  });

  final String title;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.hintColor),
            counter: Container(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
