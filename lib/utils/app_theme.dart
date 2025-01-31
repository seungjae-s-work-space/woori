import 'package:flutter/material.dart';

class AppTheme {
  // 디바이스 크기별 패딩 일단 혹시 몰라서 디바이스에서 지원할 패딩 값을 넣어주긴 했음

  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 16.0; // 모바일
    } else {
      return 64.0; // 태블릿
    }
  }

  static double getVerticalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 16.0; // 모바일
    } else {
      return 32.0; // 태블릿
    }
  }

  // 입력 폼 사이즈
  static double getInputFormWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 200.0; // 모바일
    } else {
      return 300.0; // 태블릿
    }
  }

  static double getInputFormHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 56.0; // 모바일
    } else {
      return 56.0; // 태블릿
    }
  }
}
