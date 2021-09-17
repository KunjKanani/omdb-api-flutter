import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradexa/provider/schedule.dart';
import 'package:tradexa/view/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (BuildContext context) => Schedule(),
        child: HomePage(),
      ),
    );
  }
}
