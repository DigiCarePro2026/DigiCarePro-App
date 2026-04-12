import 'package:digi_care_pro/app/data/models/customer.dart';
import 'package:digi_care_pro/app/logic/missions_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

class AnimatedSearchField extends StatefulWidget {
  List<Customer> employeeCustomers = [];

  AnimatedSearchField({super.key, required this.employeeCustomers});

  @override
  State<AnimatedSearchField> createState() => _AnimatedSearchFieldState();
}

class _AnimatedSearchFieldState extends State<AnimatedSearchField> {
  bool isExpanded = false;
  bool animationEnd = false;

  final Duration animationDuration = const Duration(milliseconds: 300);
  Customer? selectedItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;

          if (isExpanded) {
            animationEnd = false;
          }else{
            selectedItem = null;

            Get.find<MissionsLogic>().onCustomerSelected(selectedItem);
          }
        });
      },
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        height: 40,
        width: isExpanded ? 250 : 40,
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
              padding: const EdgeInsets.only(left: 8.0, right: 5),
              child: SvgPicture.asset(
                isExpanded ? 'assets/icons/mul.svg' : 'assets/icons/search-customer.svg',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isExpanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Visibility(
                    visible: animationEnd,
                    child: DropdownSearch<Customer>(
                      items: (filter, infiniteScrollProps) => widget.employeeCustomers,
                      selectedItem: selectedItem,
                      compareFn: (item, selectedItem) => item.id == selectedItem.id,
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                        });

                        Get.find<MissionsLogic>().onCustomerSelected(value);
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            icon: SvgPicture.asset('assets/icons/search.svg',width:16,color: Theme.of(context).disabledColor,),
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
                        selectedItem == null ? '' : selectedItem.getFullName(),
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
