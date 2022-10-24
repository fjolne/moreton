import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/create_wallet.dart';
import 'screens/home.dart';
import 'state.dart' as state;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var isNewUser = await state.init();

  runApp(MyApp(isNewUser: isNewUser));
}

class MyApp extends StatelessWidget {
  final bool isNewUser;
  const MyApp({super.key, required this.isNewUser});

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
      title: 'MoreTON',
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
      home: isNewUser ? const CreateWallet() : const HomeScreen(),
    );
  }
}
