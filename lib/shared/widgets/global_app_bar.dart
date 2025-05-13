import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBurgerMenu;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final double height;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBurgerMenu = true,
    this.scaffoldKey,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Combined actions: custom actions plus the burger menu if enabled
    final List<Widget> combinedActions = [
      ...(actions ?? []),
      if (showBurgerMenu)
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (scaffoldKey != null) {
              scaffoldKey!.currentState!.openEndDrawer();
            } else {
              Scaffold.of(context).openEndDrawer();
            }
          },
        ),
    ];

    return AppBar(
      title: Text(title),
      actions: combinedActions,
      automaticallyImplyLeading: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
