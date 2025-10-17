import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../theme/app_dimens.dart' show fieldRadius;

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.title,
    required this.items,
    this.hint,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final String title;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          validator: validator,
          items: items,
          onChanged: enabled ? onChanged : null,
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
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled ? theme.iconTheme.color : theme.disabledColor,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: enabled ? theme.textTheme.bodyMedium?.color : theme.disabledColor,
          ),
          dropdownColor: theme.cardColor,
        ),
      ],
    );
  }
}
