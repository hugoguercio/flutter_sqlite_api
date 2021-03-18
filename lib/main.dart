import 'package:flutter/material.dart';
import 'package:flutter_sqlite/presentation/home_page.dart';

const PrimaryColor = const Color(0xFF151026);
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
      },
      theme: ThemeData(primaryColor: PrimaryColor),
    );
  }
}
