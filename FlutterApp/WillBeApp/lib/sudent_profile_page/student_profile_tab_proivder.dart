import 'package:flutter/material.dart';

class TabViewPageViewProvider extends ChangeNotifier {
  PageController pageController = PageController(initialPage: 0);
  double _sizeWidth = 0.0;
  int tabIndex = 0;
  double tabIndicatorPosition = 0.0;

  void started(double width) {
    _sizeWidth = width;
  }

  void tabChanged(int index) {
    tabIndex = index;
    switch (index) {
      case 0:
        tabIndicatorPosition = 0.0;
        break;
      case 1:
        tabIndicatorPosition = _sizeWidth / 2 - 16;
        break;
      default:
    }
    pageController.jumpToPage(index);

    notifyListeners();
  }
}
