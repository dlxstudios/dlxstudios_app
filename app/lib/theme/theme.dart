import 'package:flavor_client/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme textTheme = GoogleFonts.robotoMonoTextTheme(
  TextTheme(
    headline2: const TextStyle(
      color: Colors.white,
      // fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      // fontSize: 12.0,
      color: Colors.grey[300],
      fontWeight: FontWeight.w500,
      letterSpacing: 2.0,
    ),
    bodyText1: TextStyle(
      color: Colors.grey[300],
      // fontSize: 14.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
    ),
    bodyText2: TextStyle(
      color: Colors.grey[300],
      letterSpacing: 1.0,
    ),
  ),
);

InputDecoration inputBorder(BuildContext context, String? labelText) {
  return InputDecoration(
    labelText: labelText ?? '',
    // isDense: true,
    labelStyle: Theme.of(context).textTheme.bodyText2,
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(),
    hoverColor: Colors.green,
    fillColor: Colors.green,
    focusColor: Colors.amber,
  );
}

ThemeData darkTheme(primaryColor, TextTheme textTheme) => ThemeData.dark()
    .copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    )
    .copyWith(
      brightness: Brightness.dark,
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      // scaffoldBackgroundColor: const Color(0xFF121212),
      scaffoldBackgroundColor: Colors.transparent,
      backgroundColor: const Color(0xFF121212),
      // primaryColor: Colors.black,
      accentColor: primaryColor,
      iconTheme: const IconThemeData().copyWith(color: Colors.white),
      textTheme: textTheme.merge(defaultTextThemeDark),
      tabBarTheme: ThemeData.dark().tabBarTheme.copyWith(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.black45,
            indicator: ShapeDecoration(
              shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: primaryColor, width: 4, style: BorderStyle.solid),
              ),
            ),
          ),
    );
ThemeData lightTheme(MaterialColor primaryColor, TextTheme textTheme) =>
    ThemeData.light().copyWith(
      // iconTheme: IconThemeData(color: Colors.black),
      // primaryIconTheme: IconThemeData(color: Colors.black),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        primaryColorDark: primaryColor,
        accentColor: primaryColor,
        backgroundColor: primaryColor,
        cardColor: primaryColor,
      ),
      accentColor: primaryColor,
      // primaryColor: Colors.deepOrangeAccent,
      buttonColor: Colors.red,
      scaffoldBackgroundColor: Colors.transparent,
      backgroundColor: Colors.grey.withAlpha(20),
      splashColor: primaryColor,
      cardTheme: CardTheme(elevation: 2.4, color: Colors.grey.shade200),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      chipTheme:
          ThemeData.light().chipTheme.copyWith(selectedColor: Colors.red),
      fixTextFieldOutlineLabel: true,
      // navigationRailTheme: NavigationRailThemeData(),
      textTheme: textTheme.merge(defaultTextThemeLight),
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: Colors.black45,
        indicator: ShapeDecoration(
          shape: UnderlineInputBorder(
            borderSide: BorderSide(
                color: primaryColor, width: 4, style: BorderStyle.solid),
          ),
        ),
      ),
    );

const MaterialColor mcgpalette0 =
    MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
  50: Color(0xFFFAF9E8),
  100: Color(0xFFF2EFC5),
  200: Color(0xFFEAE49F),
  300: Color(0xFFE1D978),
  400: Color(0xFFDAD15B),
  500: Color(_mcgpalette0PrimaryValue),
  600: Color(0xFFCFC338),
  700: Color(0xFFC9BC30),
  800: Color(0xFFC3B528),
  900: Color(0xFFB9A91B),
});
const int _mcgpalette0PrimaryValue = 0xFFD4C93E;

const MaterialColor mcgpalette0Accent =
    MaterialColor(_mcgpalette0AccentValue, <int, Color>{
  100: Color(0xFFFFFDEF),
  200: Color(_mcgpalette0AccentValue),
  400: Color(0xFFFFF289),
  700: Color(0xFFFFEF6F),
});
const int _mcgpalette0AccentValue = 0xFFFFF7BC;
