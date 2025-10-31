import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.12),
          foregroundColor: enabled
              ? colorScheme.onPrimary
              : colorScheme.onSurface.withOpacity(0.38),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium!.copyWith(
            color: enabled
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withOpacity(0.38),
          ),
        ),
      ),
    );
  }
}
