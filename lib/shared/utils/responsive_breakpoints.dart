import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  static const double phone = 360;
  static const double tablet = 768;
  static const double desktop = 1024;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet &&
      MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}
