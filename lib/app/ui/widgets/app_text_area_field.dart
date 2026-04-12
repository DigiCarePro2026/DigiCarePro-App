import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../theme/app_dimens.dart' show fieldRadius;

class AppTextAreaField extends StatelessWidget {
  const AppTextAreaField({
    super.key,
    required this.title,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.maxLines = 5,
    this.minLines = 3,
  });

  final String title;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final FocusNode? focusNode;
  final int maxLines;
  final int minLines;

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
          validator: validator,
          onChanged: onChanged,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.hintColor),
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
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
