import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var cs = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color(0xff478ee0),
      primary: const Color(0xff478ee0),
      onPrimary: const Color(0xffdddddd),
      surface: const Color(0xff1c1c1c),
      onSurface: const Color(0xff888888),
      surfaceVariant: const Color(0xff2c2d2d),
      onSurfaceVariant: const Color(0xff888888),
      background: const Color(0xff050505),
    );
    var tt = Typography.englishLike2021;
    return MaterialApp(
      title: 'Tonswap',
      theme: ThemeData(
          colorScheme: cs,
          fontFamily: 'Inter',
          textTheme: tt,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: cs.surface,
              systemNavigationBarColor: cs.surface,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: cs.primary,
            unselectedItemColor: cs.onSurface,
            backgroundColor: cs.surface,
          )),
      home: const HomeScreen(),
    );
  }
}
