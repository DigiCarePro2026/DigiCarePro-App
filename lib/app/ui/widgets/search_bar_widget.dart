import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key, required this.hintText, required this.onChange});

  final String hintText;
  final Function(String) onChange;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(bodyPadding),
      child: SearchBar(
        hintText: widget.hintText,
        onChanged: widget.onChange,
        leading: SvgPicture.asset(
          'assets/icons/search.svg',
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        hintStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.titleMedium),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.8),
        ),
        elevation: WidgetStatePropertyAll(0),
        side: WidgetStatePropertyAll(
          BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        ),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal:12, vertical: 0)),
      ),
    );
  }
}
