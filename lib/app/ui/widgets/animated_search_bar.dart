import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedSearchField extends StatefulWidget {
  const AnimatedSearchField({super.key});

  @override
  State<AnimatedSearchField> createState() => _AnimatedSearchFieldState();
}

class _AnimatedSearchFieldState extends State<AnimatedSearchField> {
  bool isExpanded = false;
  final Duration animationDuration = const Duration(milliseconds: 300);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        height: 48,
        width: isExpanded ? 200 : 48,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(24),
          // color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            // آیکون سرچ همیشه
            Padding(
              padding: const EdgeInsets.only(left: 11.0, right: 8),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            // فقط وقتی expand شده، TextField اضافه می‌کنیم
            if (isExpanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
          ],
        ),
      )
    );
  }
}
