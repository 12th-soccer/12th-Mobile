import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/bottom_navigation_bar.dart';

class TwelfthMainApp extends StatefulWidget {
  const TwelfthMainApp({super.key});

  @override
  State<TwelfthMainApp> createState() => _TwelfthMainAppState();
}

class _TwelfthMainAppState extends State<TwelfthMainApp> {
  int _currentIndex = 0;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTap(int index) {
    setState(() {
      if (_currentIndex == index) {
        _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
      } else {
        _currentIndex = index;
      }
    });
  }
  /// TODO 페이지 구현 시 Scaffold -> 페이지로 교체
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Navigator(
            key: _navigatorKeys[0],
            onGenerateRoute: (settings) =>
                MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('관심 페이지'),),)),
          ),
          Navigator(
            key: _navigatorKeys[1],
            onGenerateRoute: (settings) =>
                MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('경기 페이지'),),)),
          ),
          Navigator(
            key: _navigatorKeys[2],
            onGenerateRoute: (settings) =>
                MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('마이페이지'),),),),
          ),
        ],
      ),
      bottomNavigationBar: TwelfthBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}