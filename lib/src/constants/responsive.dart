import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;
  final double width;
  final double height;

  Responsive(this.context)
      : width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

  double widthPercent(double percent) => width * percent / 100;
  double heightPercent(double percent) => height * percent / 100;

  bool isPortrait() => height > width;
  bool isLandscape() => width > height;

  bool isMobile() => width < 600;
  bool isTablet() => width >= 600 && width < 1200;
  bool isDesktop() => width >= 1200;
}
