import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color blackColor = Colors.black87;
  static const Color lightGreyColor = Colors.black54;
  static const Color successColor = Colors.green;
  static const Color textSecondary = Colors.grey;
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  
  // Border Radius
  static const double borderRadius = 8.0;
  
  // Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 14,
    color: whiteColor,
  );

  static const TextStyle greetingTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );

  static const TextStyle promoTextStyle = TextStyle(
    color: whiteColor,
    fontSize: 11,
  );

  static const TextStyle searchTitleTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static const TextStyle searchTextStyle = TextStyle(
    color: blackColor,
    fontSize: 12,
  );

  static const TextStyle historyTitleTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 12,
    color: blackColor,
  );

  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 12,
    color: lightGreyColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 14,
    color: whiteColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle priceTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle infoTextStyle = TextStyle(
    fontSize: 12,
    color: blackColor,
  );

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: greyColor,
  );

  // New Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: blackColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );

  // Container Styles
  static BoxDecoration promoContainerDecoration = BoxDecoration(
    color: whiteColor.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: whiteColor.withOpacity(0.3)),
  );

  static BoxDecoration searchContainerDecoration = BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey.shade300),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  // Padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(16);
  static const EdgeInsets smallPadding = EdgeInsets.all(12);
  static const EdgeInsets mediumPadding = EdgeInsets.all(8);

  // Icon Sizes
  static const double smallIconSize = 16;
  static const double mediumIconSize = 20;
  static const double largeIconSize = 24;

  // Theme Data
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: whiteColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        elevation: 0,
        titleTextStyle: appBarTitleStyle,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 14, color: blackColor),
        bodyMedium: TextStyle(fontSize: 12, color: blackColor),
        bodySmall: TextStyle(fontSize: 11, color: blackColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: hintTextStyle,
        contentPadding: smallPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
} 