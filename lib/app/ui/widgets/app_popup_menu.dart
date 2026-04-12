import 'package:flutter/material.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';

class AppPopupMenu extends StatelessWidget {
  final List<AppPopupMenuItem> items;
  final Widget child;

  const AppPopupMenu({
    super.key,
    required this.items,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        final popupMenu = PopupMenu(
          context: context,
          config: MenuConfig(
            backgroundColor: Theme.of(context).colorScheme.primary,
            lineColor: const Color(0x33FFFFFF),
            highlightColor: const Color(0x33FFFFFF),
          ),
          items: items
              .map(
                (e) => PopUpMenuItem(
              title: e.title,
              image: Padding(
                padding: const EdgeInsets.all(4.0),
                child: e.icon,
              ),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w400
              ),
            ),
          )
              .toList(),
          onClickMenu: (item) {
            final selected =
            items.firstWhere((e) => e.title == item.menuTitle);
            selected.onTap();
          },
        );

        final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

        popupMenu.show(
          rect: Rect.fromPoints(
            details.globalPosition,
            details.globalPosition,
          ),
        );
      },
      child: child,
    );
  }
}


class AppPopupMenuItem {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const AppPopupMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

