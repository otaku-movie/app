import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notfound extends StatelessWidget {
  const Notfound({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
      title: const Text('404'),
    ));
  }
}
