import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pheasant_house/constants.dart';

import 'screen/welcome/welcome.dart';

void main() {
  debugPaintSizeEnabled = true;
  debugPaintBaselinesEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.promptTextTheme(),
          scaffoldBackgroundColor: kPrimaryColor),
      color: const Color(0xFF7EA48F),
      home: const Welcomescreen(),
    );
  }
}
