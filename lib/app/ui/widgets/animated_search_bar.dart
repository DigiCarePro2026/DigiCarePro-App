import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AnimatedSearchField extends StatefulWidget {
  const AnimatedSearchField({super.key});

  @override
  State<AnimatedSearchField> createState() => _AnimatedSearchFieldState();
}

class _AnimatedSearchFieldState extends State<AnimatedSearchField> {
  bool isExpanded = false;
  bool animationEnd = false;

  final Duration animationDuration = const Duration(milliseconds: 300);
  String? selectedItem;

  final List<String> items = ['Apple', 'Banana', 'Cherry', 'Mango', 'Orange', 'Peach', 'Strawberry'];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;

          if (isExpanded) {
            animationEnd = false;
          }
        });
      },
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        height: 48,
        width: isExpanded ? 250 : 48,
        onEnd: () {
          setState(() {
            animationEnd = true;
          });
        },
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 11.0, right: 8),
              child: SvgPicture.asset(
                'assets/icons/search-customer.svg',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isExpanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Visibility(
                    visible: animationEnd,
                    child: DropdownSearch<String>(
                      items: (filter, infiniteScrollProps) => items,
                      selectedItem: selectedItem,
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        textAlignVertical: TextAlignVertical(y: 0),
                        decoration: InputDecoration(
                          hintText: "Select customer",
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      dropdownBuilder: (context, selectedItem) => Text(
                        selectedItem ?? '',
                        style: Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
