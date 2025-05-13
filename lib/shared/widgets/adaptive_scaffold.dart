import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  const AdaptiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    // Use the platform to determine the style
    final useCupertino = Platform.isIOS;

    return useCupertino
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(title),
              trailing: actions != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    )
                  : null,
              backgroundColor: backgroundColor,
              automaticallyImplyLeading: automaticallyImplyLeading,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(child: body),
                  if (bottomNavigationBar != null) bottomNavigationBar!,
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: actions,
              backgroundColor: backgroundColor,
              automaticallyImplyLeading: automaticallyImplyLeading,
            ),
            body: body,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            backgroundColor: backgroundColor,
          );
  }
}
