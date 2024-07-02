import 'package:flutter/material.dart';
import 'package:rolanda/src/views/auth/login.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Rolanda()));
}

class Rolanda extends StatelessWidget {
  const Rolanda({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Login(),
    );
  }
}
