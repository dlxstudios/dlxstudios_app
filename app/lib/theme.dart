import 'package:flavor_client/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final textTheme = GoogleFonts.contrailOneTextTheme().copyWith(
  subtitle2: TextStyle(color: Colors.red),
);

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor colorCustom = MaterialColor(0xFFA73030, color);

ThemeData darkTheme(TextTheme textTheme) => flavorThemeMaterialDark.copyWith(
      // primaryColor: Colors.white,
      textTheme: textTheme.merge(defaultTextThemeDark),

      accentColor: colorCustom,
      colorScheme: ColorScheme.dark().copyWith(
        primary: colorCustom,
        secondary: colorCustom,
      ),
      indicatorColor: colorCustom,
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.grey.shade400,
        labelColor: colorCustom,
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
      // buttonColor: Colors.red,
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ButtonStyle(
      //     backgroundColor: MaterialStateProperty.all(Colors.amberAccent),
      //   ),
      // ),
    );
ThemeData lightTheme(TextTheme textTheme) => flavorThemeMaterialLight.copyWith(
      // inputDecorationTheme: InputDecorationTheme(
      //     // fillColor: Colors.white,
      //     ),
      // brightness: Brightness.light,
      // primaryColor: colorCustom,
      // accentColor: colorCustom,
      indicatorColor: colorCustom,
      colorScheme: ColorScheme.light().copyWith(
        // primary: Colors.grey.shade300,
        primary: colorCustom,
        secondary: colorCustom,
        // background: colorCustom,
        // onSurface: Colors.green,
        // onBackground: Colors.blueGrey,
        // onPrimary: Colors.teal,
        // surface: Colors.amber,
        // onSecondary: Colors.limeAccent,
        // primaryVariant: Colors.yellowAccent,
      ),

      buttonColor: Colors.red,
      navigationRailTheme: NavigationRailThemeData(
        // backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(
          color: Colors.red,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.black87,
        ),
        elevation: 5,
      ),

      // splashColor: Colors.red,
      splashColor: colorCustom,

      bottomAppBarColor: colorCustom,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorCustom,
        elevation: 5,
        selectedItemColor: colorCustom,
      ),
      textTheme: textTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        // elevation: 2,
        // brightness: Brightness.light,
      ),
      // buttonBarTheme: ButtonBarThemeData(
      //   buttonTextTheme: ButtonTextTheme.normal,
      // ),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black87,
        labelColor: colorCustom,
      ),
      scaffoldBackgroundColor: Colors.grey.shade300,
      // buttonTheme: ButtonThemeData(buttonColor: colorCustom),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ButtonStyle(
      //       // elevation: MaterialStateProperty.all(4),
      //       backgroundColor: MaterialStateProperty.all(Colors.amber)),
      // ),

      primaryIconTheme: IconThemeData(
        // color: Colors.black87,
        color: colorCustom,
      ),
    );
