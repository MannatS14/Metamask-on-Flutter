import 'package:flutter/material.dart';
import 'package:metamask_on_flutter/metamask.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MetaMask(),
    );
  }
}
