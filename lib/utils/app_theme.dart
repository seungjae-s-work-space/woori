import 'package:flutter/material.dart';

class AppTheme {
  // ========================================
  // 색상 팔레트 (Sky Blue + White 컨셉)
  // ========================================

  // 메인 컬러
  static const Color primarySky = Color(0xff98C4E5);
  static const Color primarySkyLight = Color(0xffB8D9F5);
  static const Color primarySkyDark = Color(0xff7AB0D8);

  // 배경 컬러
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundGray = Color(0xffF8F8F8);
  static const Color backgroundLight = Color(0xffFAFAFA);

  // 텍스트 컬러
  static const Color textPrimary = Color(0xff212121);
  static const Color textSecondary = Color(0xff757575);
  static const Color textHint = Color(0xffBDBDBD);

  // 강조 컬러
  static const Color accentRed = Color(0xffFF6B6B);
  static const Color accentGreen = Color(0xff51CF66);

  // 중립 컬러
  static const Color divider = Color(0xffE0E0E0);
  static const Color border = Color(0xffEEEEEE);
  static const Color shadow = Color(0x1A000000);

  // ========================================
  // 타이포그래피
  // ========================================

  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  // ========================================
  // 간격 (Spacing)
  // ========================================

  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // ========================================
  // Border Radius
  // ========================================

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusCircle = 999.0;

  // ========================================
  // Elevation & Shadow
  // ========================================

  static List<BoxShadow> get cardShadow => const [
    BoxShadow(
      color: shadow,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get buttonShadow => const [
    BoxShadow(
      color: shadow,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  // ========================================
  // 디바이스 크기별 패딩
  // ========================================

  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return spacing16; // 모바일
    } else {
      return spacing48 + spacing16; // 태블릿
    }
  }

  static double getVerticalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return spacing16; // 모바일
    } else {
      return spacing32; // 태블릿
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

  // ========================================
  // ThemeData
  // ========================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primarySky,
      scaffoldBackgroundColor: backgroundWhite,

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card 테마
      cardTheme: CardTheme(
        color: backgroundWhite,
        elevation: 2,
        shadowColor: shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
      ),

      // Input 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primarySky, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: accentRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing16,
        ),
      ),

      // ElevatedButton 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySky,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0x4D7AB0D8),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: button,
        ),
      ),

      // TextButton 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primarySky,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // BottomNavigationBar 테마
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundWhite,
        selectedItemColor: primarySky,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),

      // Icon 테마
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),

      // Divider 테마
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
