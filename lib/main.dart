import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/views/main_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: TwelfthColor.background),
      // home: TwelfthMainApp(),
      // home: TwelfthSplashView(),
      home: Scaffold(
        body: Center(
          /*child: Column(
            children: [
              const SizedBox(height: 50),
              TwelfthElevatedButton(
                backgroundColor: TwelfthColor.yellow,
                onPressed: () {
                  print('단색 버튼 활성 클릭');
                },
                textColor: TwelfthColor.black,
                imgPath: TwelfthAssets.kakao,
                child: const Text('Kakao 로그인'),
              ),
              const SizedBox(height: 20),
              TwelfthElevatedButton(
                backgroundColor: TwelfthColor.white,
                onPressed: null,
                textColor: TwelfthColor.black,
                imgPath: TwelfthAssets.kakao,
                child: const Text('Kakao 로그인 (비활성)'),
              ),
            ],
          ),*/
          child: TwelfthElevatedButton(
            imgPath: TwelfthAssets.kakao,
            child: Text('kakao 로그인 ㄱ?'),
          ),
          /*child: TwelfthElevatedButton(
            imgPath: TwelfthAssets.kakao,
            gradient: TwelfthGradient.horizontal(TwelfthColor.silverGradient),
            onPressed: () {
              print('눌림!!!');
            },
            child: const Text('kakao 로그인 ㄱ?'),
          ),*/
        ),
      ),
    );
  }
}
