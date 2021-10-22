import 'package:flutter/material.dart';
import 'package:rust_wasm/ui/screens/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Crypto Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignaturePage(),
    );
  }
}