import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/views/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: CustomColor.background),
      home: const TwelfthSplashView(),
    );
  }
}
