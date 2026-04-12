import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: child,
      ),
    );
  }
}
