import 'package:flutter/material.dart';

class TabViewPageViewProvider extends ChangeNotifier {
  //pageView 
  PageController pageController = PageController(initialPage: 0);
  double _sizeWidth = 0.0;
  int tabIndex = 0;
  double tabIndicatorPosition = 0.0;
  
  String get someData {
    // 필요한 데이터를 반환하는 로직을 여기에 추가
    return "Some Data"; // 예시 데이터, 실제 데이터 반환 로직으로 변경
  }
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
