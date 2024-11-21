import 'package:flutter/material.dart';
import 'pages/splash.dart';

void main() {
  runApp(MyMainApplication());
}

class MyMainApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Aer 🌩 Moder weather forecasting.',
      debugShowCheckedModeBanner: false,
      home: BackgroundImagePage(),
    );
  }
}