import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // پر کردن عرض
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
