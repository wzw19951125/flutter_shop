import 'package:flutter/material.dart';
import 'package:flutter_shop/router/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: "/",
      onGenerateRoute: onGenerateRoute,
    );
  }
}
