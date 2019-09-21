import 'package:flutter/material.dart';
import 'package:apple_sign_in_example/sign_in_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignInPage());
  }
}
