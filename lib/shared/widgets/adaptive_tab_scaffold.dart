import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class TabItem {
  final String title;
  final IconData icon;
  final Widget screen;

  TabItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}

class AdaptiveTabScaffold extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AdaptiveTabScaffold({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: tabs
                  .map((tab) => BottomNavigationBarItem(
                        icon: Icon(tab.icon),
                        label: tab.title,
                      ))
                  .toList(),
              currentIndex: currentIndex,
              onTap: onTabSelected,
              activeColor: CupertinoTheme.of(context).primaryColor,
            ),
            tabBuilder: (context, index) {
              return CupertinoTabView(
                builder: (context) => tabs[index].screen,
              );
            },
          )
        : Scaffold(
            body: tabs[currentIndex].screen,
            bottomNavigationBar: BottomNavigationBar(
              items: tabs
                  .map((tab) => BottomNavigationBarItem(
                        icon: Icon(tab.icon),
                        label: tab.title,
                      ))
                  .toList(),
              currentIndex: currentIndex,
              onTap: onTabSelected,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
            ),
          );
  }
}
